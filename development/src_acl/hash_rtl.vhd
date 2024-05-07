library ieee;
  use ieee.std_logic_1164.all;
  use work.acl_hash_if.all;
  use work.acl_defs_pkg.all;

entity hash_rtl is
  port (
    pil_rst      : in    std_logic;                                     -- system clock
    pil_en       : in    std_logic;                                     -- system clock
    pil_clk      : in    std_logic;                                     -- system clock
    piif_hash    : in    acl_hash_if;
    pol_hash_rdy : out   std_logic;                                     -- hash address.
    polv8_hash   : out   std_logic_vector(ACL_HASH_LENGTH - 1 downto 0) -- hash address.
  );
end entity hash_rtl;

architecture rtl of hash_rtl is

  -- FSM signals

  type hash_state_t is (acl_state_idle, acl_state_gen_hash, acl_state_hash_final, acl_state_hash_done);

  signal hash_state,      hash_state_next      : hash_state_t                                   := acl_state_idle;
  signal slv8_hash_value, slv8_hash_value_next : std_logic_vector(ACL_HASH_LENGTH - 1 downto 0) := (others => '0');

begin

  --------------------------------
  --                            --
  --  HASH FUNCTION SWITCH      --
  --                            --
  --------------------------------

  hash_select_function : process (piif_hash, slv8_hash_value) is
  begin

    case piif_hash.lv4_select is

      when "0000" =>

        slv8_hash_value_next(0) <= slv8_hash_value(0) xor slv8_hash_value(6) xor slv8_hash_value(7) xor piif_hash.lv8_data(0);
        slv8_hash_value_next(1) <= slv8_hash_value(0) xor slv8_hash_value(1) xor slv8_hash_value(6) xor piif_hash.lv8_data(1);
        slv8_hash_value_next(2) <= slv8_hash_value(0) xor slv8_hash_value(1) xor slv8_hash_value(2) xor slv8_hash_value(6) xor piif_hash.lv8_data(2);
        slv8_hash_value_next(3) <= slv8_hash_value(1) xor slv8_hash_value(2) xor slv8_hash_value(3) xor slv8_hash_value(7) xor piif_hash.lv8_data(3);
        slv8_hash_value_next(4) <= slv8_hash_value(2) xor slv8_hash_value(3) xor slv8_hash_value(4) xor piif_hash.lv8_data(4);
        slv8_hash_value_next(5) <= slv8_hash_value(3) xor slv8_hash_value(4) xor slv8_hash_value(5) xor piif_hash.lv8_data(5);
        slv8_hash_value_next(6) <= slv8_hash_value(4) xor slv8_hash_value(5) xor slv8_hash_value(6) xor piif_hash.lv8_data(6);
        slv8_hash_value_next(7) <= slv8_hash_value(5) xor slv8_hash_value(6) xor slv8_hash_value(7) xor piif_hash.lv8_data(7);

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

  hash_next_state : process (piif_hash, slv8_hash_value_next, hash_state, slv8_hash_value) is
  begin

    hash_state_next <= hash_state;
    polv8_hash      <= (others => '0');
    pol_hash_rdy    <= '0';

    case hash_state is

      when acl_state_idle =>

        if (piif_hash.l_first = '1') then
          hash_state_next <= acl_state_gen_hash;
        end if;

      when acl_state_gen_hash =>

        if (piif_hash.l_last = '1') then
          hash_state_next <= acl_state_hash_final;
        end if;

      when acl_state_hash_final =>

        hash_state_next <= acl_state_hash_done;

      when acl_state_hash_done =>

        hash_state_next <= acl_state_idle;
        polv8_hash      <= slv8_hash_value;
        pol_hash_rdy    <= '1';

      when others =>

        hash_state_next <= acl_state_idle;

    end case;

  end process hash_next_state;

  ------------------------------------------
  --                                      --
  --  HASH FUNCTION FSM STATE REGISTERS   --
  --                                      --
  ------------------------------------------
  process (pil_rst, pil_clk) is
  begin

    if rising_edge(pil_clk) then
      if (pil_rst = '1') then
        hash_state      <= acl_state_idle;
        slv8_hash_value <= (others => '0');
      elsif (pil_en) then
        hash_state      <= hash_state_next;
        slv8_hash_value <= slv8_hash_value_next;
      end if;
    end if;

  end process;

end architecture rtl;
