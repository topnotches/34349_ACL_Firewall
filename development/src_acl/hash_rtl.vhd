library ieee;
use ieee.std_logic_1164.all;
use work.acl_header_if.all;
use work.acl_defs_pkg.all;

entity hash_rtl is
  port
  (
    pl_rst           : in std_logic; -- system clock
    pl_clk           : in std_logic; -- system clock
    pif_header       : in acl_header_if;
    plv4_select_hash : in std_logic_vector(3 downto 0);
    pl_hash_rdy      : out std_logic; -- hash address.
    plv8_hash        : out std_logic_vector(ACL_HASH_LENGTH - 1 downto 0) -- hash address.
  );
end entity hash_rtl;

architecture rtl of hash_rtl is

  -- FSM signals

  type hash_state_t is (ACL_STATE_IDLE, ACL_STATE_GEN_HASH, ACL_STATE_HASH_FINAL, ACL_STATE_HASH_DONE);

  signal hash_state, hash_state_next           : hash_state_t                                   := ACL_STATE_IDLE;
  signal slv8_hash_value, slv8_hash_value_next : std_logic_vector(ACL_HASH_LENGTH - 1 downto 0) := (others => '0');

begin

  --------------------------------
  --                            --
  --  HASH FUNCTION SWITCH      --
  --                            --
  --------------------------------
  -- FILL OUT LATER
  hash_select_function : process (pif_header, slv8_hash_value, plv4_select_hash) is
  begin

    case plv4_select_hash is

      when "0000" =>

        slv8_hash_value_next(0) <= slv8_hash_value(0) xor slv8_hash_value(6) xor slv8_hash_value(7) xor pif_header.data(0);
        slv8_hash_value_next(1) <= slv8_hash_value(0) xor slv8_hash_value(1) xor slv8_hash_value(6) xor pif_header.data(1);
        slv8_hash_value_next(2) <= slv8_hash_value(0) xor slv8_hash_value(1) xor slv8_hash_value(2) xor slv8_hash_value(6) xor pif_header.data(2);
        slv8_hash_value_next(3) <= slv8_hash_value(1) xor slv8_hash_value(2) xor slv8_hash_value(3) xor slv8_hash_value(7) xor pif_header.data(3);
        slv8_hash_value_next(4) <= slv8_hash_value(2) xor slv8_hash_value(3) xor slv8_hash_value(4) xor pif_header.data(4);
        slv8_hash_value_next(5) <= slv8_hash_value(3) xor slv8_hash_value(4) xor slv8_hash_value(5) xor pif_header.data(5);
        slv8_hash_value_next(6) <= slv8_hash_value(4) xor slv8_hash_value(5) xor slv8_hash_value(6) xor pif_header.data(6);
        slv8_hash_value_next(7) <= slv8_hash_value(5) xor slv8_hash_value(6) xor slv8_hash_value(7) xor pif_header.data(7);
        --  when "0001" =>
        --  when "0010" =>
        --  when "0011" =>
        --  when "0100" =>
        --  when "0101" =>
        --  when "0110" =>
        --  when "0111" =>
        --  when "1000" =>
        --  when "1001" =>
        --  when "1010" =>
        --  when "1011" =>
        --  when "1100" =>
        --  when "1101" =>
        --  when "1110" =>
        --  when "1111" =>
      when others =>
        slv8_hash_value_next <= slv8_hash_value;
    end case;

  end process hash_select_function;

  ------------------------------------------
  --                                      --
  --  HASH FUNCTION FSM NEXT STATE LOGIC  --
  --                                      --
  ------------------------------------------

  hash_next_state : process (pif_header, slv8_hash_value_next, hash_state) is
  begin

    hash_state_next <= hash_state;
    plv8_hash       <= (others => '0');
    pl_hash_rdy     <= '0';
    case hash_state is

      when ACL_STATE_IDLE =>

        if (pif_header.first = '1') then
          hash_state_next <= ACL_STATE_GEN_HASH;
        end if;

      when ACL_STATE_GEN_HASH =>

        if (pif_header.last = '1') then
          hash_state_next <= ACL_STATE_HASH_FINAL;
        end if;

      when ACL_STATE_HASH_FINAL =>

        hash_state_next <= ACL_STATE_HASH_DONE;
      when ACL_STATE_HASH_DONE =>

        hash_state_next <= ACL_STATE_IDLE;
        plv8_hash       <= slv8_hash_value;
        pl_hash_rdy     <= '1';
      when others =>

        hash_state_next <= ACL_STATE_IDLE;

    end case;

  end process hash_next_state;

  ------------------------------------------
  --                                      --
  --  HASH FUNCTION FSM STATE REGISTERS   --
  --                                      --
  ------------------------------------------
  process (pl_rst, pl_clk)
  begin
    if rising_edge(pl_clk) then
      if (pl_rst = '1') then
        hash_state      <= ACL_STATE_IDLE;
        slv8_hash_value <= (others => '0');
      else
        hash_state      <= hash_state_next;
        slv8_hash_value <= slv8_hash_value_next;
      end if;
    end if;
  end process;

end architecture rtl;