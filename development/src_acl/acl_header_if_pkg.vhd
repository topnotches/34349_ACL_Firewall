library ieee;
use ieee.std_logic_1164.all;
use work.acl_defs_pkg.all;

package acl_hash_if is

  -- Define the record type for GMII interface

  type acl_hash_if is record
    l_first    : std_logic;
    l_last     : std_logic;
    lv8_data   : std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0);
    lv4_select : std_logic_vector(ACL_HASH_FUNCTION_SELECT_COUNT - 1 downto 0);
  end record acl_hash_if;

  -- Constant to set all signals to 0 in acl_hash_if record type
  constant ACL_HASH_IF_ZERO : acl_hash_if :=
  (
  l_first => '0',
  l_last  => '0',
  lv8_data => (others => '0'),
  lv4_select => (others => '0')
  );

end package acl_hash_if;

package body acl_hash_if is

  -- No implementation needed in the package body for this example

end package body acl_hash_if;