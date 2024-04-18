library ieee;
  use ieee.std_logic_1164.all;

package acl_header_if is

  -- Define the record type for GMII interface

  type acl_header_if is record
    first : std_logic;
    last  : std_logic;
    data  : std_logic_vector(7 downto 0);
  end record acl_header_if;

  -- Constant to set all signals to 0 in acl_header_if record type
  constant ACL_HEADER_IF_ZERO : acl_header_if :=
  (
    first => '0',
    last  => '0',
    data  => (others => '0')
  );

end package acl_header_if;

package body acl_header_if is

-- No implementation needed in the package body for this example

end package body acl_header_if;
