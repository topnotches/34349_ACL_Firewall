library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

use work.acl_defs_pkg.all;

entity header_extraction_rtl is
  port
  (
    pil_clk : in std_logic;
    pil_rst : in std_logic;

    -- GMII interface
    pilv8_gmii_data : in std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0);
    pil_gmii_start  : in std_logic;

    -- header extractor output
    polv8_acl_data         : out std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0);
    pol_acl_valid_field    : out std_logic;
    pol_acl_start_of_tuple : out std_logic;

    -- FIFO output
    polv8_fifo_data : out std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0);
    pol_fifo_rd_en  : out std_logic

  );
end entity header_extraction_rtl;

architecture rtl of header_extraction_rtl is
  type header_ext_states_t is (header_ext_fsm_state_idle, header_ext_fsm_state_load_ipv4, header_ext_fsm_state_load_tcp);
  signal fsm_state_header_ext, fsm_state_header_ext_next : header_ext_states_t := header_ext_fsm_state_idle;

  signal sarr2lv4_header_ext_ipv4_valid_fields : std_logic_vector(ACL_IPV4_HEADER_BYTES - 1 downto 0) := (x"004FF");
  signal sarr2lv4_header_ext_tcp_valid_fields  : std_logic_vector(ACL_TCP_HEADER_BYTES - 1 downto 0)  := (x"F");

  signal si_header_ext_byte_counter, si_header_ext_byte_counter_next : integer range 0 to ACL_HEADER_BYTE_COUNTER - 1       := 0;
  signal slv4_header_ipv4_length, slv4_header_ipv4_length_next       : std_logic_vector(ACL_IPV4_HEADER_BYTES - 1 downto 0) := (others => '0');

begin

  next_state_process : process (
    fsm_state_header_ext,
    si_header_ext_byte_counter,
    sarr2lv4_header_ext_ipv4_valid_fields,
    slv4_header_ipv4_length,
    sarr2lv4_header_ext_tcp_valid_fields
    )
  begin
    pol_acl_valid_field             <= '0';
    fsm_state_header_ext_next       <= fsm_state_header_ext;
    si_header_ext_byte_counter_next <= si_header_ext_byte_counter;
    slv4_header_ipv4_length_next    <= slv4_header_ipv4_length;

    case fsm_state_header_ext is

      when header_ext_fsm_state_idle =>
        if (pil_gmii_start = '1') then
          fsm_state_header_ext_next       <= header_ext_fsm_state_load_ipv4;
          si_header_ext_byte_counter_next <= si_header_ext_byte_counter + 1;
          slv4_header_ipv4_length_next    <= pilv8_gmii_data(3 downto 0) & "00";
        end if;
      when header_ext_fsm_state_load_ipv4 =>
        pol_acl_valid_field <= sarr2lv4_header_ext_ipv4_valid_fields(si_header_ext_byte_counter);

        if (slv4_header_ipv4_length = std_logic_vector(to_unsigned(si_header_ext_byte_counter, slv4_header_ipv4_length'length))) then
          fsm_state_header_ext_next       <= header_ext_fsm_state_load_tcp;
          si_header_ext_byte_counter_next <= 0;
        end if;
      when header_ext_fsm_state_load_tcp =>

        pol_acl_valid_field <= sarr2lv4_header_ext_tcp_valid_fields(si_header_ext_byte_counter);
        if (si_header_ext_byte_counter = 3) then
          fsm_state_header_ext_next <= header_ext_fsm_state_idle;
        end if;
      when others =>
        fsm_state_header_ext_next <= header_ext_fsm_state_idle;

    end case;

  end process;

  fsm_registers_process : process (pil_clk, pil_rst)

  begin
    if rising_edge(pil_clk) then
      if (pil_rst = '1') then
        fsm_state_header_ext       <= header_ext_fsm_state_idle;
        si_header_ext_byte_counter <= 0;
        slv4_header_ipv4_length    <= (others => '0');
      else
        fsm_state_header_ext       <= fsm_state_header_ext_next;
        si_header_ext_byte_counter <= si_header_ext_byte_counter_next;
        slv4_header_ipv4_length    <= slv4_header_ipv4_length_next;
      end if;

    end if;
  end process;

end architecture;