library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.acl_defs_pkg.all;
entity firewall_top_rtl is
    port
    (
        pil_clk : in std_logic;
        pil_rst : in std_logic;
        -- stats

        -- GMII in
        pilv8_gmii_rxd : in std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0);
        pil_gmii_rx_en : in std_logic;
        -- GMII out
        polv8_gmii_txd : out std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0);
        pol_gmii_tx_en : out std_logic
    );
end entity firewall_top_rtl;

architecture rtl of firewall_top_rtl is
    -------
    signal slv8_fwtop_gmii_header_data        : std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0) := (others => '0');
    signal sl_fwtop_gmii_header_enable        : std_logic                                          := '0';
    signal slv8_fwtop_header_acl_data         : std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0) := (others => '0');
    signal sl_fwtop_header_acl_valid_field    : std_logic                                          := '0';
    signal sl_fwtop_header_acl_start_of_tuple : std_logic                                          := '0';
    signal slv8_fwtop_header_fifo_data        : std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0) := (others => '0');
    signal sl_fwtop_header_fifo_rd_en         : std_logic                                          := '0';
    -------
    signal slv8_fwtop_acl_table_addr   : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0)               := (others => '0');
    signal sl_fwtop_acl_table_read_en  : std_logic                                                    := '0';
    signal slv128_fwtop_table_acl_data : std_logic_vector(ACL_HASH_TABLE_ADDRESS_LENGTH - 1 downto 0) := (others => '0');
    signal sl_fwtop_block              : std_logic                                                    := '0';
begin

    COMP_ACL_TOP_HEADER_EXT : entity work.header_extraction_rtl(rtl)
        port map
        (
            pil_clk => pil_clk,
            pil_rst => pil_rst,

            -- GMII interface
            pilv8_gmii_data => slv8_fwtop_gmii_header_data,
            pil_gmii_enable => sl_fwtop_gmii_header_enable,

            -- header extractor output
            polv8_acl_data         => slv8_fwtop_header_acl_data,
            pol_acl_valid_field    => sl_fwtop_header_acl_valid_field,
            pol_acl_start_of_tuple => sl_fwtop_header_acl_start_of_tuple,

            -- FIFO output
            polv8_fifo_data => slv8_fwtop_header_fifo_data,
            pol_fifo_rd_en  => sl_fwtop_header_fifo_rd_en
        );
    COMP_ACL_TOP_ACL_FSM : entity work.acl_fsm_rtl(rtl)
        port
        map (
        pil_clk            => pil_clk,
        pil_rst            => pil_rst,
        pilv8_data         => slv8_fwtop_header_acl_data,
        pil_valid          => sl_fwtop_header_acl_valid_field,
        pil_start_of_tuple => sl_fwtop_header_acl_start_of_tuple,
        polv8_table_addr   => slv8_fwtop_acl_table_addr,
        pol_table_read_en  => sl_fwtop_acl_table_read_en,
        pilv128_table_data => slv128_fwtop_table_acl_data,
        pol_block          => sl_fwtop_block
        );

    COMP_FW_TOP_HASH_TABLE_0 : entity work.hash_table_rtl(rtl)
        port
        map (
        pil_clk => pil_clk,
        pil_rst => pil_rst,

        pilv8_hash_table_rd_addr => slv8_fwtop_acl_table_addr,
        pil_hash_rd_en           => sl_fwtop_acl_table_read_en,

        pilv8_hash_table_wr_addr => (others => '0'),
        pil_hash_wr_en => '0',

        pilv128_hash_wr_value => (others => '0'),
        polv128_hash_rd_value => slv128_fwtop_table_acl_data
        );

end architecture;