library ieee;
context ieee.ieee_std_context;
use ieee.math_real.all;

use work.acl_hash_if.all;
use work.acl_defs_pkg.all;

entity acl_fsm_rtl is
  port
  (
    pil_clk : in std_logic;
    pil_rst : in std_logic;
    -- Header extractor input
    pilv8_data         : in std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0)
    pil_valid          : in std_logic;
    pil_start_of_tuple : in std_logic;
    -- Hash ports

    -- Hash table ports

    type state_acl_fsm_t is (STATE_ACL_FSM_IDLE,
      STATE_ACL_FSM_LOAD_HEADER,
      STATE_ACL_FSM_LOAD_HASH_ADDRESS,
      STATE_ACL_FSM_ASSERT_RULE,
      STATE_ACL_FSM_DO_ACTION_BLOCK,
      STATE_ACL_FSM_DO_ACTION_PERMIT);
    signal sstate_acl_fsm, sstate_acl_fsm_next : sstate_acl_fsm_t := ACL_FSM_STATE_IDLE;
  );
end entity acl_fsm_rtl;

architecture rtl of acl_fsm_rtl is
  signal slv104_tuple, slv104_tuple_next         : std_logic_vector(ACL_TUPLE_LENGTH - 1 downto 0)       := (others => '0');
  signal si_tuple_counter, si_tuple_counter_next : natural range 0 to ACL_BYTES_PER_TUPLE - 1            := TUPLE_COUNTER_INIT - 1;
  constant clv4_check_zero                       : std_logic_vector(ACL_TUPLE_COUNTER_BITS - 1 downto 0) := (others => '0');
  signal sl_counter_is_zero                      : std_logic                                             := '0';
  signal sl_gated_hash_clk                       : std_logic                                             := '0';
  signal sif_hash                                : acl_hash_if;
  signal slv8_hash_address                       : std_logic_vector(ACL_HASH_LENGTH - 1 downto 0);
begin

  HASH_FUNCTION : work.hash_rtl(rtl)
  port map
  (
    pil_rst      => pil_rst,
    pil_clk      => sl_gated_hash_clk,
    piif_hash    => sif_hash,
    pol_hash_rdy => sl_hash_rdy,
    polv8_hash   => slv8_hash
  );

  gen
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
  process (all)
  begin
    -- Remove inferred latches
    slv104_tuple_next <= slv104_tuple;

    case sstate_acl_fsm is
      when STATE_ACL_FSM_IDLE =>
        if (pil_start_of_tuple = '1') then
          sstate_acl_fsm_next <= STATE_ACL_FSM_LOAD_HEADER;
        end if;
      when STATE_ACL_FSM_LOAD_HEADER =>
        if (pil_valid = '1') then
          -- store
          slv104_tuple_next(si_tuple_counter * ACL_DATA_BUS_LENGTH + ACL_DATA_BUS_LENGTH - 1 downto si_tuple_counter * ACL_DATA_BUS_LENGTH) <=
          if (sl_counter_is_zero = '0') then
            si_tuple_counter_next <= si_tuple_counter - 1;
          else
            sstate_acl_fsm_next <= STATE_ACL_FSM_LOAD_HASH_ADDRESS;
          end if;
        end if;
      when STATE_ACL_FSM_LOAD_HASH_ADDRESS =>
        sstate_acl_fsm_next <= STATE_ACL_FSM_ASSERT_RULE;
      when STATE_ACL_FSM_ASSERT_RULE =>
        sstate_acl_fsm_next <= STATE_ACL_FSM_DO_ACTION_BLOCK;
      when STATE_ACL_FSM_DO_ACTION_BLOCK =>
        sstate_acl_fsm_next <= STATE_ACL_FSM_DO_ACTION_PERMIT;
      when STATE_ACL_FSM_DO_ACTION_PERMIT =>
        sstate_acl_fsm_next <= STATE_ACL_FSM_IDLE;
      when others =>
        null;
    end case;
  end process;
end if;
when STATE_ACL_FSM_LOAD_HEADER =>
if (pil_valid = '1') then
  if (si_tuple_counter < 13) then

    sstate_acl_fsm_next <= STATE_ACL_FSM_LOAD_HASH_ADDRESS;
  end if;
end if;
when STATE_ACL_FSM_LOAD_HASH_ADDRESS =>
sstate_acl_fsm_next <= STATE_ACL_FSM_ASSERT_RULE;
when STATE_ACL_FSM_ASSERT_RULE =>
sstate_acl_fsm_next <= STATE_ACL_FSM_DO_ACTION_BLOCK;
when STATE_ACL_FSM_DO_ACTION_BLOCK =>
sstate_acl_fsm_next <= STATE_ACL_FSM_DO_ACTION_PERMIT;
when STATE_ACL_FSM_DO_ACTION_PERMIT =>
sstate_acl_fsm_next <= STATE_ACL_FSM_IDLE;
when others =>
null;
end case;
end process;
----------------------------------------
--                                    --
--  ACL CONTROL FSM STATE REGISTERS   --
--                                    --
----------------------------------------
process (pil_clk, pil_rst)
begin
  if rising_edge(pil_clk) then
    if (pil_rst = '0') then
      sstate_acl_fsm <= (others =>);
    else
      sstate_acl_fsm <= sstate_acl_fsm_next;
    end if;
  end if;
end process;
end architecture;