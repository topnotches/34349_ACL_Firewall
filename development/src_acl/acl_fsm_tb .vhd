library ieee;
  use ieee.std_logic_1164.all;
  use ieee.math_real.all;
  use ieee.numeric_std.all;
  use work.acl_defs_pkg.all;
  use work.acl_hash_if.all;

entity acl_fsm_tb is
end entity acl_fsm_tb;

architecture behavioral of acl_fsm_tb is

  signal sil_clk            : std_logic                                      := '1';
  signal sil_rst            : std_logic                                      := '1';
  signal silv8_data         : std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0);
  signal sil_valid          : std_logic                                      := '0';
  signal sil_start_of_tuple : std_logic                                      := '0';
  signal silv128_table_data : std_logic_vector(128 - 1 downto 0)             := (others => '0');
  signal solv8_table_addr   : std_logic_vector(ACL_HASH_LENGTH - 1 downto 0) := (others => '0');
  signal sol_table_read_en  : std_logic                                      := '0';
  signal sol_block          : std_logic                                      := '0';

  type arr_stim_t is array (0 to 15) of integer range 0 to 255;

  signal sarr_stim    : arr_stim_t            := (192, 168, 5, 0, 251, 88, 0, 25, 25, 192, 0, 0, 168, 15, 245, 0);
  signal counter      : integer range 0 to 15 := 0;
  signal sl_first_run : std_logic             := '1';

begin

  dut_hash_gen : entity work.acl_fsm_rtl(rtl)
    port map (
      pil_clk            => sil_clk,
      pil_rst            => sil_rst,
      pilv8_data         => silv8_data,
      pil_valid          => sil_valid,
      pil_start_of_tuple => sil_start_of_tuple,
      polv8_table_addr   => solv8_table_addr,
      pol_table_read_en  => sol_table_read_en,
      pilv128_table_data => silv128_table_data,
      pol_block          => sol_block
    );

  silv8_data <= std_logic_vector(to_unsigned(sarr_stim(counter), silv8_data'length));
  -- Testbench for diagonal input

  tb : block is
  begin

    process (sil_clk, sil_rst) is
    begin

      if (sil_rst /= '1') then
        if (rising_edge(sil_clk) and sl_first_run = '1') then
          if (sarr_stim(counter) /= 0) then
            sil_valid <= '1';
          else
            sil_valid <= '0';
          end if;
          if (counter < 15) then
            counter <= counter + 1;
          else
            sl_first_run <= '0';
          end if;
        end if;
      end if;

    end process;

  end block tb;

  sil_rst <= '0' after 20 ns;
  sil_clk <= not sil_clk after 1 ns;

end architecture behavioral;
