library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.acl_defs_pkg.all;
use work.packet_pkg.all;
entity firewall_top_tb is

end entity firewall_top_tb;

architecture rtl of firewall_top_tb is
    constant N_PACKETS   : natural                      := 10;
    signal sl_clk        : std_logic                    := '0';
    signal sl_rst        : std_logic                    := '1';
    signal slv8_gmii_rxd : std_logic_vector(7 downto 0) := (others => '0');
    signal sl_gmii_rx_en : std_logic                    := '0';
    signal slv8_gmii_txd : std_logic_vector(7 downto 0) := (others => '0');
    signal sl_gmii_tx_en : std_logic                    := '0';
    type arr255slv160_packet_stimuli_t is array (0 to 255) of std_logic_vector(ACL_STATIC_IP_HEADER_LENGTH_BITS - 1 downto 0);
    signal sarr255slv160_packet_stimuli : arr255slv160_packet_stimuli_t := (others => (others => '0'));

begin

    UUT_FIREWALL_TOP : entity work.firewall_top_rtl(rtl)
        port map
        (
            pil_clk => sl_clk,
            pil_rst => sl_rst,
            -- stats

            -- GMII in
            pilv8_gmii_rxd => slv8_gmii_rxd,
            pil_gmii_rx_en => sl_gmii_rx_en,
            -- GMII out
            polv8_gmii_txd => slv8_gmii_txd,
            pol_gmii_tx_en => sl_gmii_tx_en
        );

    TB : block
    begin
        process
            variable vn_options_word_length                    : natural range 0 to 10 := 0;
            variable rand_packet_delay                         : natural               := 1;
            variable vrec_packet                               : packet_header_rec     := init_packet_header_rec_zero;
            impure function rand_real(arg_min_val, arg_max_val : real) return real is

                variable r     : real;
                variable seed1 : integer := 42;
                variable seed2 : integer := 42;
            begin
                uniform(seed1, seed2, r);
                return r * (arg_max_val - arg_min_val) + arg_min_val;
            end function;
            procedure clock_procedure is
            begin
                wait for 1 ns;
                sl_clk <= '1';
                wait for 1 ns;
                sl_clk <= '0';
            end procedure;
        begin
            for index_ip_packet in 0 to N_PACKETS - 1 loop
                vn_options_word_length := natural(rand_real(real(ACL_STATIC_IP_OPTIONS_MIN_LENGTH_WORDS), real(ACL_STATIC_IP_OPTIONS_MAX_LENGTH_WORDS)));
                sl_gmii_rx_en <= '1';
                for index_ip_header in ACL_STATIC_IP_HEADER_LENGTH_BYTES - 1 downto 0 loop
                    slv8_gmii_rxd <= get_lv_byte_ip_header(vrec_packet,index_ip_header);
                    clock_procedure;
                end loop;
                for index_ip_options in vn_options_word_length - 1 downto 0 loop
                    slv8_gmii_rxd <= get_lv_byte_ip_options(vrec_packet,index_ip_options);
                    clock_procedure;
                end loop;
                for index_tcp_header in ACL_STATIC_TCP_HEADER_LENGTH_BYTES - 1 downto 0 loop
                    slv8_gmii_rxd <= get_lv_byte_tcp_header(vrec_packet, index_tcp_header);
                    clock_procedure;
                end loop;

                sl_gmii_rx_en <= '0';
                for index_packet_delay in 0 to rand_packet_delay loop

                end loop;
                clock_procedure;
            end loop;
        end process;
    end block;
    sl_rst <= '0' after 50 ns;
end architecture;