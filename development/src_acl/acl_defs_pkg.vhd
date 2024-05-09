-- noc_defs package

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package acl_defs_pkg is

  constant ACL_BYTES_PER_WORD : natural := 4;

  constant ACL_DATA_BUS_LENGTH            : natural := 8;
  constant ACL_TUPLE_LENGTH               : natural := 104;
  constant ACL_BYTES_PER_TUPLE            : natural := 13;
  constant ACL_TUPLE_COUNTER_BITS         : natural := 4;
  constant ACL_HASH_LENGTH                : natural := 8;
  constant ACL_HASH_TABLE_LENGTH          : natural := ACL_HASH_LENGTH;
  constant ACL_HASH_FUNCTION_SELECT_COUNT : natural := 4;
  constant ACL_HASH_TABLE_M9K_LENGTH      : natural := 32;
  constant ACL_HASH_TABLE_ADDRESS_LENGTH  : natural := 128;

  -- TUPLE COUNTER INITS
  constant ACL_MIN_HEADER_WORDS    : natural := 5;
  constant ACL_MAX_HEADER_WORDS    : natural := 15;
  constant ACL_TUPLE_COUNTER_ZERO  : natural := 0;
  constant ACL_TUPLE_COUNTER_INIT  : natural := 13;
  constant ACL_HEADER_BYTE_COUNTER : natural := ACL_MAX_HEADER_WORDS * ACL_BYTES_PER_WORD;
  constant ACL_IPV4_HEADER_BYTES   : natural := ACL_MIN_HEADER_WORDS * ACL_BYTES_PER_WORD;
  constant ACL_TCP_HEADER_BYTES    : natural := 4;

  -- excluding options
  constant ACL_STATIC_IP_HEADER_LENGTH_WORDS  : natural := 5;
  constant ACL_STATIC_IP_HEADER_LENGTH_BYTES  : natural := ACL_STATIC_IP_HEADER_LENGTH_WORDS * 4;
  constant ACL_STATIC_IP_HEADER_LENGTH_BITS   : natural := ACL_STATIC_IP_HEADER_LENGTH_BYTES * 8;
  constant ACL_STATIC_TCP_HEADER_LENGTH_WORDS : natural := 5;
  constant ACL_STATIC_TCP_HEADER_LENGTH_BYTES : natural := ACL_STATIC_TCP_HEADER_LENGTH_WORDS * 4;
  constant ACL_STATIC_TCP_HEADER_LENGTH_BITS  : natural := ACL_STATIC_TCP_HEADER_LENGTH_BYTES * 8;
  constant ACL_STATIC_TOTAL_HEADER_LENGTH     : natural := ACL_STATIC_IP_HEADER_LENGTH_BITS + ACL_STATIC_TCP_HEADER_LENGTH_BITS;
end package acl_defs_pkg;

package body acl_defs_pkg is

end package body acl_defs_pkg;