library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use work.acl_defs_pkg.all;
use work.acl_hash_if.all;

entity hash_tb is
end entity hash_tb;

architecture rtl of hash_tb is

    signal sl_rst                : std_logic                                      := '0';
    signal sl_clk                : std_logic                                      := '0'; -- system clock
    signal sif_hash              : acl_hash_if                                    := ACL_HASH_IF_ZERO;
    signal sl_hash_rdy           : std_logic                                      := '0'; -- hash address.
    signal slv8_hash             : std_logic_vector(ACL_HASH_LENGTH - 1 downto 0) := (others => '0');
    signal si_hash_input_counter : integer range 0 to 12                          := 0;

    type arr_input_stim_t is array (natural range 0 to 10) of natural range 0 to 2 ** ACL_HASH_LENGTH - 1;

    signal sarr_input_stim   : arr_input_stim_t := (192, 168, 5, 251, 88, 25, 25, 192, 168, 15, 245);
    signal si_counter_sanity : integer          := 0;

begin

    dut_hash_gen : entity work.hash_rtl(rtl)
        port map
        (
            pil_rst      => sl_rst,
            pil_clk      => sl_clk,
            piif_hash    => sif_hash,
            pol_hash_rdy => sl_hash_rdy,
            polv8_hash   => slv8_hash
        );

    -- Testbench for diagonal input

    tb : block is
    begin

        process is
        begin

            sl_rst <= '1';
            wait for 100 ns;
            sl_rst <= '0';

            for i in 0 to 12 loop

                si_counter_sanity <= i;
                wait for 5 ns;
                sl_clk <= '0';

                case i is

                    when 0 =>

                        sif_hash.l_first  <= '1';
                        sif_hash.lv8_data <= std_logic_vector(to_unsigned(sarr_input_stim(i), sif_hash.lv8_data'length));

                    when 10 =>

                        sif_hash.l_last   <= '1';
                        sif_hash.lv8_data <= std_logic_vector(to_unsigned(sarr_input_stim(i), sif_hash.lv8_data'length));

                    when 11 =>

                        sif_hash <= ACL_HASH_IF_ZERO;
                        report "Test: DONE";

                    when others =>

                        sif_hash.lv8_data <= std_logic_vector(to_unsigned(sarr_input_stim(i), sif_hash.lv8_data'length));

                end case;

                wait for 5 ns;
                sl_clk <= '1';

            end loop;

        end process;

    end block tb;

end architecture rtl;