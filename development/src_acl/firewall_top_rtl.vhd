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
    polv8_gmii_rxd : out std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0);
    pol_gmii_rx_en : out std_logic
  );
end entity firewall_top_rtl;

architecture rtl of firewall_top_rtl is

begin

  COMP_ACL_TOP_HEADER_EXT : entity work.header_extraction_rtl(rtl)
    port map
    (
      pil_clk => sl_fwtop_header_clk;
      pil_rst => sl_fwtop_header_rst;

      -- GMII interface
      pilv8_gmii_data => slv8_fwtop_header_gmii_data;
      pil_gmii_enable => sl_fwtop_header_gmii_enable;

      -- header extractor output
      polv8_acl_data         => slv8_fwtop_header_acl_data;
      pol_acl_valid_field    => sl_fwtop_header_acl_valid_field;
      pol_acl_start_of_tuple => sl_fwtop_header_acl_start_of_tuple;

      -- FIFO output
      polv8_fifo_data => slv8_fwtop_header_fifo_data;
      pol_fifo_rd_en  => sl_fwtop_header_fifo_rd_en
    );
end architecture;