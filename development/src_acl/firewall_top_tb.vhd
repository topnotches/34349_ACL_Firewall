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

    --------------------
    -- HEADER STIMULI --
    --------------------
    type arr10lv4_nibble_header_stim_t is array (natural range 0 to N_PACKETS - 1) of std_logic_vector(ACL_NIBBLE_LENGTH - 1 downto 0);
    type arr10lv8_byte_header_stim_t is array (natural range 0 to N_PACKETS - 1) of std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0);
    type arr10lv16_halfword_header_stim_t is array (natural range 0 to N_PACKETS - 1) of std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
    type arr10lv32_word_header_stim_t is array (natural range 0 to N_PACKETS - 1) of std_logic_vector(ACL_WORD_LENGTH - 1 downto 0);
    type arr10lv8_stim_results_t is array (natural range 0 to N_PACKETS - 1) of std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0);

    -----------------
    -- signal sarr10lv4_NAME_stim  : arr10lv4_nibble_header_stim_t    := (others => '0');
    -- signal sarr10lv8_NAME_stim  : arr10lv8_byte_header_stim_t      := (others => '0');
    -- signal sarr10lv16_NAME_stim : arr10lv16_halfword_header_stim_t := (others => '0');
    -- signal sarr10lv32_NAME_stim : arr10lv32_word_header_stim_t     := (others => '0');
    -----------------

    -- EXPECTED HASH VALUES:
    constant carr10lv8_stim_results : arr10lv8_stim_results_t := (
    x"2E",
    x"E5",
    x"B0",
    x"5B",
    x"20",
    x"00",
    x"00",
    x"00",
    x"00",
    x"00"
    );
    -- INPUT STIM VECTORS
    signal sarr10lv4_ihl_stim : arr10lv4_nibble_header_stim_t := (
    x"0",
    x"0",
    x"0",
    x"0",
    x"0",
    x"0",
    x"0",
    x"0",
    x"0",
    x"0"
    );
    signal sarr10lv8_protocol_stim : arr10lv8_byte_header_stim_t := (
    x"3F",
    x"F2",
    x"69",
    x"42",
    x"5B",
    x"FE",
    x"00",
    x"00",
    x"00",
    x"00"
    );
    signal sarr10lv32_ip_src_addr_stim : arr10lv32_word_header_stim_t := (
    x"FFFFFFFF",
    x"01234567",
    x"69696969",
    x"42424242",
    x"DCBA9876",
    x"00000000",
    x"00000000",
    x"00000000",
    x"00000000",
    x"00000000"
    );
    signal sarr10lv32_ip_dest_addr_stim : arr10lv32_word_header_stim_t := (
    x"F1FFF1FF",
    x"89ABCDEF",
    x"69696969",
    x"42424242",
    x"543210FF",
    x"00000000",
    x"00000000",
    x"00000000",
    x"00000000",
    x"00000000"
    );
    signal sarr10lv16_port_src_addr_stim : arr10lv16_halfword_header_stim_t := (
    x"FFFF",
    x"0123",
    x"6969",
    x"4242",
    x"0123",
    x"0000",
    x"0000",
    x"0000",
    x"0000",
    x"0000"
    );
    signal sarr10lv16_port_dest_addr_stim : arr10lv16_halfword_header_stim_t := (
    x"FFFF",
    x"4567",
    x"6969",
    x"4242",
    x"4567",
    x"0000",
    x"0000",
    x"0000",
    x"0000",
    x"0000"
    );

    constant CLV4_NIBBLE_ZEROS    : std_logic_vector(ACL_NIBBLE_LENGTH - 1 downto 0)   := (others => '0');
    constant CLV8_BYTE_ZEROS      : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0)     := (others => '0');
    constant CLV16_HALFWORD_ZEROS : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0) := (others => '0');
    constant CLV32_WORD_ZEROS     : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0)     := (others => '0');

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

            impure function set_header_stim(index : natural) return packet_header_rec is

            begin

                return init_packet_header_rec(

                -- ip header
                CLV4_NIBBLE_ZEROS,
                sarr10lv4_ihl_stim(index),
                CLV8_BYTE_ZEROS,
                CLV16_HALFWORD_ZEROS,
                CLV16_HALFWORD_ZEROS,
                CLV16_HALFWORD_ZEROS,
                CLV8_BYTE_ZEROS,
                sarr10lv8_protocol_stim(index),
                CLV16_HALFWORD_ZEROS,
                sarr10lv32_ip_src_addr_stim(index),
                sarr10lv32_ip_dest_addr_stim(index),
                -- tcp header
                sarr10lv16_port_src_addr_stim(index),
                sarr10lv16_port_dest_addr_stim(index),
                CLV32_WORD_ZEROS,
                CLV32_WORD_ZEROS,
                CLV8_BYTE_ZEROS,
                CLV8_BYTE_ZEROS,
                CLV16_HALFWORD_ZEROS,
                CLV16_HALFWORD_ZEROS,
                CLV16_HALFWORD_ZEROS
                );
            end function;
        begin
            wait until sl_rst = '0';
            for index_ip_packet in 0 to N_PACKETS - 1 loop
                vn_options_word_length := natural(rand_real(real(ACL_STATIC_IP_OPTIONS_MIN_LENGTH_WORDS), real(ACL_STATIC_IP_OPTIONS_MAX_LENGTH_WORDS)));
                vrec_packet            := set_header_stim(index_ip_packet);
                sl_gmii_rx_en <= '1';
                clock_procedure;
                for index_ip_header in ACL_STATIC_IP_HEADER_LENGTH_BYTES - 1 downto 0 loop
                    slv8_gmii_rxd <= get_lv_byte_ip_header(vrec_packet, index_ip_header);
                    clock_procedure;
                end loop;
                for index_ip_options in vn_options_word_length - 1 downto 0 loop
                    slv8_gmii_rxd <= get_lv_byte_ip_options(vrec_packet, index_ip_options);
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