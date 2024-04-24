-- noc_defs package

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package acl_defs_pkg is
  constant ACL_DATA_BUS_LENGTH            : natural := 8;
  constant ACL_TUPLE_LENGTH               : natural := 104;
  constant ACL_BYTES_PER_TUPLE            : natural := 13;
  constant ACL_TUPLE_COUNTER_BITS         : natural := 4;
  constant ACL_HASH_LENGTH                : natural := 8;
  constant ACL_HASH_TABLE_LENGTH          : natural := ACL_HASH_LENGTH;
  constant ACL_HASH_FUNCTION_SELECT_COUNT : natural := 4;

  -- TUPLE COUNTER INITS

  constant ACL_TUPLE_COUNTER_ZERO : natural := 0;
  constant ACL_TUPLE_COUNTER_INIT : natural := 13;

end package acl_defs_pkg;

package body acl_defs_pkg is

end package body acl_defs_pkg;