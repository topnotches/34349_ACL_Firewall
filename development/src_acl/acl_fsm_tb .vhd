library ieee;
  use ieee.std_logic_1164.all;
  use ieee.math_real.all;
  use ieee.numeric_std.all;
  use work.acl_defs_pkg.all;
  use work.acl_hash_if.all;

entity acl_fsm_tb is
end entity acl_fsm_tb;

architecture behavioral of acl_fsm_tb is

  signal sil_clk            : std_logic                                      := '0';
  signal sil_rst            : std_logic                                      := '0';
  signal silv8_data         : std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0);
  signal sil_valid          : std_logic                                      := '0';
  signal sil_start_of_tuple : std_logic                                      := '0';
  signal solv_addr          : std_logic_vector(ACL_HASH_LENGTH - 1 downto 0) := (others => '0');
  signal solv_read_en       : std_logic                                      := '0';
  signal solv_block         : std_logic                                      := '0';

  type arr_stim_t is array (0 to 15) of integer range 0 to 255;

  signal sarr_stim : arr_stim_t := (192, 168, 5, 0, 251, 88, 0, 25, 25, 192, 168, 15, 245);

begin

  dut_hash_gen : entity work.acl_fsm_rtl(rtl)
    port map (
      pil_clk            => sil_clk,
      pil_rst            => sil_rst,
      pilv8_data         => silv8_data,
      pil_valid          => sil_valid,
      pil_start_of_tuple => sil_start_of_tuple,
      polv_addr          => solv_addr,
      polv_read_en       => solv_read_en,
      polv_block         => solv_block
    );

  silv8_data <= std_logic_vector(to_unsigned(sarr_stim(i), silv8_data'length));
  -- Testbench for diagonal input

  tb : block is
  begin

    process is

      variable counter : integer range 0 to 15;

    begin

      if rising_edge(sil_clk) then
        if (sarr_stim(i) != 0) then
          sil_valid <= '1';
        else
          sil_valid <= '0';
        end if;
        counter <= counter + 1;
      end if;

    end process;

  end block tb;

  sil_rst <= '0' after 20 ns;
  sil_clk <= not sil_clk after 1 ns;

end architecture behavioral;
