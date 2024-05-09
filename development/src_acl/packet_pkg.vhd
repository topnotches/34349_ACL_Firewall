library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.acl_defs_pkg.all;

package packet_pkg is
    type package_header_rec is record
        ip_header  : std_logic_vector(ACL_STATIC_IP_HEADER_LENGTH_BITS - 1 downto 0);
        ip_options : std_logic_vector(ACL_STATIC_IP_OPTIONS_LENGTH_BITS - 1 downto 0);
        tcp_header : std_logic_vector(ACL_STATIC_TCP_HEADER_LENGTH_BITS - 1 downto 0);
    end record;

    function init_package_header_rec(
        version          : std_logic_vector(ACL_NIBBLE_LENGTH - 1 downto 0),
        ihl              : std_logic_vector(ACL_NIBBLE_LENGTH - 1 downto 0),
        tos              : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0),
        total_length     : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        id               : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        flags_n_frags_os : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        ttl              : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0),
        protocol         : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0),
        head_checksum    : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        src_addr         : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0),
        dest_addr        : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0),
        src_port         : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        dest_port        : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        seq_num          : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0),
        ack_num          : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0),
        reserved         : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0),
        flags            : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0),
        window_size      : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        checksum         : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        urgent_pointer   : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0)
    ) return package_header_rec;

    function slv_to_ip_header_rec(slv : std_logic_vector) return ip_header_rec;
    ;
    function package_header_rec_to_slv(arg_package_header_rec : package_header_rec) return std_logic_vector(ACL_STATIC_TOTAL_HEADER_LENGTH - 1 downto 0);
    function ip_header_rec_to_slv(arg_package_header_rec      : package_header_rec) return std_logic_vector(ACL_STATIC_IP_HEADER_LENGTH_BITS - 1 downto 0);
    function tcp_header_rec_to_slv(arg_package_header_rec     : package_header_rec) return std_logic_vector(ACL_STATIC_TCP_HEADER_LENGTH_BITS - 1 downto 0);
    function get_slv_byte_ip_header (arg_package_header_rec   : package_header_rec) return std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0);

end package packet_pkg;

package body packet_pkg is

    function init_package_header_rec(
        version          : std_logic_vector(ACL_NIBBLE_LENGTH - 1 downto 0),
        ihl              : std_logic_vector(ACL_NIBBLE_LENGTH - 1 downto 0),
        tos              : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0),
        total_length     : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        id               : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        flags_n_frags_os : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        ttl              : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0),
        protocol         : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0),
        head_checksum    : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        src_addr         : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0),
        dest_addr        : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0),
        src_port         : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        dest_port        : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        seq_num          : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0),
        ack_num          : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0),
        reserved         : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0),
        flags            : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0),
        window_size      : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        checksum         : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0),
        urgent_pointer   : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0)
    ) return package_header_rec is
        variable init_data : package_header_rec;
    begin
        init_data.ip_header  := version & ihl & tos & total_length & id & flags_n_frags_os & ttl & protocol & head_checksum & src_addr & dest_addr;
        init_data.tcp_header := src_port & dest_port & seq_num & ack_num & reserved & flags & window_size & checksum & urgent_pointer;
        return init_data;
    end function init_package_header_rec;

    function slv_to_package_header_rec(slv : std_logic_vector) return package_header_rec is
        variable d_if                          : package_header_rec;
    begin
        -- TODO_JESPER: Only implement if necessary, keeping this open
        return d_if
    end slv_to_package_header_rec;

    function package_header_rec_to_slv(arg_package_header_rec : package_header_rec) return std_logic_vector(ACL_STATIC_TOTAL_HEADER_LENGTH - 1 downto 0) is
        variable slv_result                                       : std_logic_vector(ACL_STATIC_TOTAL_HEADER_LENGTH - 1 downto 0);
    begin

        slv_result := arg_package_header_rec.ip_header & arg_package_header_rec.tcp_header;
        return slv_result;
    end package_header_rec_to_slv;

end package body packet_pkg;