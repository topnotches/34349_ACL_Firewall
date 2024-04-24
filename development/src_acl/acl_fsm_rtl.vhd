library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
  use work.acl_hash_if.all;
  use work.acl_defs_pkg.all;

entity acl_fsm_rtl is
  port (
    pil_clk : in    std_logic;
    pil_rst : in    std_logic;
    -- Header extractor input
    pilv8_data         : in    std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0);
    pil_valid          : in    std_logic;
    pil_start_of_tuple : in    std_logic;
    -- Table ports
    polv_addr    : out   std_logic_vector(ACL_HASH_LENGTH - 1 downto 0);
    polv_read_en : out   std_logic;
    -- Hash table ports
    -- Decision
    polv_block : out   std_logic
  );
end entity acl_fsm_rtl;

architecture rtl of acl_fsm_rtl is

  signal   slv104_tuple,      slv104_tuple_next      : std_logic_vector(ACL_TUPLE_LENGTH - 1 downto 0)       := (others => '0');
  signal   si_tuple_counter,  si_tuple_counter_next  : natural range 0 to ACL_BYTES_PER_TUPLE - 1            := ACL_TUPLE_COUNTER_INIT - 1;
  constant clv4_check_zero                           : std_logic_vector(ACL_TUPLE_COUNTER_BITS - 1 downto 0) := (others => '0');
  signal   sl_counter_is_zero                        : std_logic                                             := '0';
  signal   sl_gated_hash_clk                         : std_logic                                             := '0';
  signal   sif_hash                                  : acl_hash_if;
  signal   slv8_hash_address, slv8_hash_address_next : std_logic_vector(ACL_HASH_LENGTH - 1 downto 0)        := (others => '0');
  signal   slv8_hash                                 : std_logic_vector(7 downto 0)                          := (others => '0');
  signal   sl_hash_rdy                               : std_logic                                             := '0';

  type state_acl_fsm_t is (
    state_acl_fsm_idle,
    state_acl_fsm_load_header,
    state_acl_get_hash_value,
    state_acl_fsm_load_hash_address,
    state_acl_fsm_assert_rule,
    state_acl_fsm_do_action_block,
    state_acl_fsm_do_action_permit
  );

  attribute enum_encoding                    : string;
  attribute enum_encoding of state_acl_fsm_t : type is "one-hot"; -- encoding style of the enumerated type
  signal sstate_acl_fsm,      sstate_acl_fsm_next : state_acl_fsm_t := state_acl_fsm_idle;

begin

  hash_function : entity work.hash_rtl(rtl)
    port map (
      pil_rst      => pil_rst,
      pil_clk      => sl_gated_hash_clk,
      piif_hash    => sif_hash,
      pol_hash_rdy => sl_hash_rdy,
      polv8_hash   => slv8_hash
    );

  --------------------------------------------
  --                                        --
  --  GEN GATED CLOCK FOR HASH FUNCTION     --
  --                                        --
  --------------------------------------------
  sl_gated_hash_clk <= pil_valid and pil_clk;

  ----------------------------------------
  --                                    --
  --  ZERO CHECK LOGIC                  --
  --                                    --
  ----------------------------------------
  sl_counter_is_zero <= or si_tuple_counter;
  ----------------------------------------
  --                                    --
  --  ACL CONTROL FSM NEXT STATE LOGIC  --
  --                                    --
  ----------------------------------------
  process (slv104_tuple,
           sstate_acl_fsm,
           slv8_hash_address,
           pilv8_data,
           si_tuple_counter,
           slv8_hash) is
  begin

    -- Remove inferred latches
    slv104_tuple_next      <= slv104_tuple;
    sstate_acl_fsm_next    <= sstate_acl_fsm;
    slv8_hash_address_next <= slv8_hash_address;

    case sstate_acl_fsm is

      when state_acl_fsm_idle =>

        if (pil_start_of_tuple = '1') then
          sstate_acl_fsm_next <= state_acl_fsm_load_header;
          si_tuple_counter    <= ACL_TUPLE_COUNTER_INIT;
        end if;

      when state_acl_fsm_load_header =>

        if (pil_valid = '1') then
          -- store
          slv104_tuple_next(si_tuple_counter * ACL_DATA_BUS_LENGTH + ACL_DATA_BUS_LENGTH - 1 downto si_tuple_counter * ACL_DATA_BUS_LENGTH) <= pilv8_data;
          if (sl_counter_is_zero = '0') then
            si_tuple_counter_next <= si_tuple_counter - 1;
          else
            sstate_acl_fsm_next <= state_acl_get_hash_value;
          end if;
        end if;

      when state_acl_get_hash_value =>

        if (sl_hash_rdy = '1') then
          sstate_acl_fsm_next    <= state_acl_fsm_load_hash_address;
          slv8_hash_address_next <= slv8_hash;
        end if;

      when state_acl_fsm_load_hash_address =>

        sstate_acl_fsm_next <= state_acl_fsm_assert_rule;

      when state_acl_fsm_assert_rule =>

        sstate_acl_fsm_next <= state_acl_fsm_do_action_block;

      when state_acl_fsm_do_action_block =>

        sstate_acl_fsm_next <= state_acl_fsm_do_action_permit;

      when state_acl_fsm_do_action_permit =>

        sstate_acl_fsm_next <= state_acl_fsm_idle;

      when others =>

        null;

    end case;

  end process;

  ----------------------------------------
  --                                    --
  --  ACL CONTROL FSM STATE REGISTERS   --
  --                                    --
  ----------------------------------------
  process (pil_clk, pil_rst) is
  begin

    if rising_edge(pil_clk) then
      if (pil_rst = '0') then
        sstate_acl_fsm    <= state_acl_fsm_idle;
        slv104_tuple      <= (others => '0');
        si_tuple_counter  <= ACL_TUPLE_COUNTER_INIT - 1;
        slv8_hash_address <= (others => '0');
      else
        sstate_acl_fsm    <= sstate_acl_fsm_next;
        slv104_tuple      <= slv104_tuple_next;
        si_tuple_counter  <= si_tuple_counter_next;
        slv8_hash_address <= slv8_hash_address_next;
      end if;
    end if;

  end process;

end architecture rtl;
