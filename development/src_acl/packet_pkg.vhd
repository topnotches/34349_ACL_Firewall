library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.acl_defs_pkg.all;

package packet_pkg is
    type packet_header_rec is record
        ip_header  : std_logic_vector(ACL_STATIC_IP_HEADER_LENGTH_BITS - 1 downto 0);
        ip_options : std_logic_vector(ACL_STATIC_IP_OPTIONS_LENGTH_BITS - 1 downto 0);
        tcp_header : std_logic_vector(ACL_STATIC_TCP_HEADER_LENGTH_BITS - 1 downto 0);
    end record;

    function init_packet_header_rec_zero return packet_header_rec;
    function init_packet_header_rec(

        -- ip header
        version          : std_logic_vector(ACL_NIBBLE_LENGTH - 1 downto 0);
        ihl              : std_logic_vector(ACL_NIBBLE_LENGTH - 1 downto 0);
        tos              : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0);
        total_length     : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        id               : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        flags_n_frags_os : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        ttl              : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0);
        protocol         : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0);
        head_checksum    : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        src_addr         : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0);
        dest_addr        : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0);

        -------------
        -- OPTIONS --
        -------------

        -- tcp header
        src_port       : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        dest_port      : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        seq_num        : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0);
        ack_num        : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0);
        reserved       : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0);
        flags          : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0);
        window_size    : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        checksum       : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        urgent_pointer : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0)
    ) return packet_header_rec;
    function packet_header_rec_to_lv(arg_packet_header_rec : packet_header_rec) return std_logic_vector;

    function get_lv_byte_ip_header (arg_packet_header_rec : packet_header_rec; argi_index : natural range 0 to ACL_STATIC_IP_HEADER_LENGTH_BYTES - 1) return std_logic_vector;
    function get_lv_byte_ip_options (arg_packet_header_rec : packet_header_rec; argi_index : natural range 0 to ACL_STATIC_IP_OPTIONS_LENGTH_BYTES - 1) return std_logic_vector;
    function get_lv_byte_tcp_header (arg_packet_header_rec : packet_header_rec; argi_index : natural range 0 to ACL_STATIC_TCP_HEADER_LENGTH_BYTES - 1) return std_logic_vector;

end package packet_pkg;

package body packet_pkg is
    function init_packet_header_rec_zero return packet_header_rec is
        variable vrec_packet_zero : packet_header_rec;
    begin
        vrec_packet_zero.ip_header  := (others => '0');
        vrec_packet_zero.ip_options := (others => '0');
        vrec_packet_zero.tcp_header := (others => '0');
        return vrec_packet_zero;
    end function init_packet_header_rec_zero;
    function init_packet_header_rec(
        version          : std_logic_vector(ACL_NIBBLE_LENGTH - 1 downto 0);
        ihl              : std_logic_vector(ACL_NIBBLE_LENGTH - 1 downto 0);
        tos              : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0);
        total_length     : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        id               : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        flags_n_frags_os : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        ttl              : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0);
        protocol         : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0);
        head_checksum    : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        src_addr         : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0);
        dest_addr        : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0);
        src_port         : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        dest_port        : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        seq_num          : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0);
        ack_num          : std_logic_vector(ACL_WORD_LENGTH - 1 downto 0);
        reserved         : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0);
        flags            : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0);
        window_size      : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        checksum         : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0);
        urgent_pointer   : std_logic_vector(ACL_HALFWORD_LENGTH - 1 downto 0)
    ) return packet_header_rec is
        variable init_data : packet_header_rec;
    begin
        init_data.ip_header  := version & ihl & tos & total_length & id & flags_n_frags_os & ttl & protocol & head_checksum & src_addr & dest_addr;
        init_data.ip_options := (others => '0');
        init_data.tcp_header := src_port & dest_port & seq_num & ack_num & reserved & flags & window_size & checksum & urgent_pointer;
        return init_data;
    end function init_packet_header_rec;
    function packet_header_rec_to_lv(arg_packet_header_rec : packet_header_rec) return std_logic_vector is
        variable alv_lv                                        : std_logic_vector(ACL_STATIC_TOTAL_HEADER_LENGTH - 1 downto 0);
    begin

        alv_lv := arg_packet_header_rec.ip_header & arg_packet_header_rec.tcp_header;
        return alv_lv;
    end packet_header_rec_to_lv;

    -- FUNCTION "get_lv_byte_ip_header" 

    function get_lv_byte_ip_header (arg_packet_header_rec : packet_header_rec; argi_index : natural range 0 to ACL_STATIC_IP_HEADER_LENGTH_BYTES - 1) return std_logic_vector is

        variable vlv8_ip_header_byte : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0) := (others => '0');

    begin

        vlv8_ip_header_byte := arg_packet_header_rec.ip_header(ACL_BYTE_LENGTH * (argi_index + 1) - 1 downto ACL_BYTE_LENGTH * (argi_index));

        return vlv8_ip_header_byte;

    end function get_lv_byte_ip_header;

    -- FUNCTION "get_lv_byte_ip_options" 

    function get_lv_byte_ip_options (arg_packet_header_rec : packet_header_rec; argi_index : natural range 0 to ACL_STATIC_IP_OPTIONS_LENGTH_BYTES - 1) return std_logic_vector is

        variable vlv8_ip_options_byte : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0) := (others => '0');

    begin

        vlv8_ip_options_byte := arg_packet_header_rec.ip_options(ACL_BYTE_LENGTH * (argi_index + 1) - 1 downto ACL_BYTE_LENGTH * (argi_index));

        return vlv8_ip_options_byte;

    end function get_lv_byte_ip_options;

    -- FUNCTION "get_lv_byte_tcp_header" 

    function get_lv_byte_tcp_header (arg_packet_header_rec : packet_header_rec; argi_index : natural range 0 to ACL_STATIC_TCP_HEADER_LENGTH_BYTES - 1) return std_logic_vector is

        variable vlv8_tcp_header_byte : std_logic_vector(ACL_BYTE_LENGTH - 1 downto 0) := (others => '0');

    begin

        vlv8_tcp_header_byte := arg_packet_header_rec.tcp_header(ACL_BYTE_LENGTH * (argi_index + 1) - 1 downto ACL_BYTE_LENGTH * (argi_index));

        return vlv8_tcp_header_byte;

    end function get_lv_byte_tcp_header;
end package body packet_pkg;