library ieee;
context ieee.ieee_std_context;
use ieee.math_real.all;

use work.acl_header_if.all;
use work.acl_defs_pkg.all;

entity acl_fsm_rtl is
  port
  (
    pil_clk : in std_logic;
    pil_rst : in std_logic;
    -- Header extractor input
    pilv8_data : in std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0)
    pil_valid  : in std_logic;
    -- Hash ports
    p_gated_hash_clk
    poif_hash          : out acl_header_if;
    polv8_hash_address : in std_logic_vector(ACL_HASH_LENGTH - 1 downto 0);

    -- Hash table ports

  );
end entity acl_fsm_rtl;

architecture rtl of acl_fsm_rtl is

begin

end architecture;