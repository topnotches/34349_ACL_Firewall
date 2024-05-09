library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.acl_hash_if.all;
use work.acl_defs_pkg.all;

entity acl_fsm_rtl is
    port
    (
        pil_clk : in std_logic;
        pil_rst : in std_logic;
        -- Header extractor input
        pilv8_data         : in std_logic_vector(ACL_DATA_BUS_LENGTH - 1 downto 0);
        pil_valid          : in std_logic;
        pil_start_of_tuple : in std_logic;
        -- Table ports
        polv8_table_addr   : out std_logic_vector(ACL_HASH_LENGTH - 1 downto 0);
        pol_table_read_en  : out std_logic;
        pilv128_table_data : in std_logic_vector(128 - 1 downto 0);
        -- Hash table ports
        -- Decision
        pol_block : out std_logic
    );
end entity acl_fsm_rtl;

architecture rtl of acl_fsm_rtl is

    signal slv104_tuple, slv104_tuple_next             : std_logic_vector(ACL_TUPLE_LENGTH - 1 downto 0)       := (others => '0');
    signal slv104_tuple_table, slv104_tuple_table_next : std_logic_vector(ACL_TUPLE_LENGTH - 1 downto 0)       := (others => '0');
    signal slv104_rule_xor                             : std_logic_vector(ACL_TUPLE_LENGTH - 1 downto 0)       := (others => '0');
    signal sl_rule_hit                                 : std_logic                                             := '0';
    signal si_tuple_counter, si_tuple_counter_next     : natural range 0 to ACL_BYTES_PER_TUPLE - 1            := ACL_TUPLE_COUNTER_INIT - 1;
    constant clv4_check_zero                           : std_logic_vector(ACL_TUPLE_COUNTER_BITS - 1 downto 0) := (others => '0');
    signal sl_counter_is_zero                          : std_logic                                             := '0';
    signal sl_gated_hash_clk                           : std_logic                                             := '0';
    signal sif_hash                                    : acl_hash_if;
    signal slv8_hash_address, slv8_hash_address_next   : std_logic_vector(ACL_HASH_LENGTH - 1 downto 0) := (others => '0');
    signal slv8_hash                                   : std_logic_vector(7 downto 0)                   := (others => '0');
    signal slv8_data                                   : std_logic_vector(7 downto 0)                   := (others => '0');
    signal sl_hash_rdy                                 : std_logic                                      := '0';
    signal sl_hash_valid, sl_hash_valid_next           : std_logic                                      := '0';

    type state_acl_fsm_t is (
        state_acl_fsm_idle,
        state_acl_fsm_load_header,
        state_acl_get_hash_value,
        state_acl_fsm_request_hash_address,
        state_acl_fsm_load_hash_address,
        state_acl_fsm_assert_rule,
        state_acl_fsm_do_action_block,
        state_acl_fsm_do_action_permit
    );

    attribute enum_encoding                    : string;
    attribute enum_encoding of state_acl_fsm_t : type is "one-hot"; -- encoding style of the enumerated type
    signal sstate_acl_fsm, sstate_acl_fsm_next : state_acl_fsm_t := state_acl_fsm_idle;

begin

    polv8_table_addr <= slv8_hash_address;

    hash_function : entity work.hash_rtl(rtl)
        port map
        (
            pil_rst      => pil_rst,
            pil_en       => pil_valid,
            pil_clk      => pil_clk,
            piif_hash    => sif_hash,
            pol_hash_rdy => sl_hash_rdy,
            polv8_hash   => slv8_hash
        );

    tuple_xor_gen : for i in 0 to ACL_TUPLE_LENGTH - 1 generate
        slv104_rule_xor(i) <= slv104_tuple(i) xor slv104_tuple_table(i);
    end generate tuple_xor_gen;

    -- not supported in quartus!
    -- sl_rule_hit <= or(slv104_rule_xor);

    process (slv104_rule_xor) is
    begin

        if (to_integer(unsigned(slv104_rule_xor)) = 0) then
            sl_rule_hit <= '0';
        else
            sl_rule_hit <= '1';
        end if;

    end process;

    --------------------------------------------
    --                                        --
    --  GEN GATED CLOCK FOR HASH FUNCTION     --
    --                                        --
    --------------------------------------------
    -- sl_gated_hash_clk <= pil_valid and pil_clk;
    -- Gated clocks are notty notty for fpga

    ----------------------------------------
    --                                    --
    --  ZERO CHECK LOGIC                  --
    --                                    --
    ----------------------------------------
    -- not supported in quartus!
    -- sl_counter_is_zero <= or(std_logic_vector(to_unsigned(si_tuple_counter, 4)));

    process (si_tuple_counter) is
    begin

        if (si_tuple_counter = 0) then
            sl_counter_is_zero <= '0';
        else
            sl_counter_is_zero <= '1';
        end if;

    end process;

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
        slv8_hash,
        pil_valid,
        sl_counter_is_zero,
        pilv128_table_data,
        sl_rule_hit,
        slv8_data,
        sl_hash_rdy) is
    begin

        -- Remove inferred latches
        slv104_tuple_next       <= slv104_tuple;
        sstate_acl_fsm_next     <= sstate_acl_fsm;
        slv8_hash_address_next  <= slv8_hash_address;
        slv104_tuple_table_next <= (others => '0');

        sl_hash_valid_next    <= '0';
        sif_hash              <= ACL_HASH_IF_ZERO;
        si_tuple_counter_next <= si_tuple_counter;
        pol_table_read_en     <= '0';
        pol_block             <= '0';

        case sstate_acl_fsm is

            when state_acl_fsm_idle =>

                if (pil_valid = '1') then
                    sstate_acl_fsm_next <= state_acl_fsm_load_header;

                    slv104_tuple_next(si_tuple_counter * ACL_DATA_BUS_LENGTH + ACL_DATA_BUS_LENGTH - 1 downto si_tuple_counter * ACL_DATA_BUS_LENGTH) <= pilv8_data;

                    si_tuple_counter_next <= si_tuple_counter - 1;

                    sif_hash.lv8_data <= slv8_data;
                    sif_hash.l_first  <= '1';
                end if;

            when state_acl_fsm_load_header =>

                if (pil_valid = '1') then
                    slv104_tuple_next(si_tuple_counter * ACL_DATA_BUS_LENGTH + ACL_DATA_BUS_LENGTH - 1 downto si_tuple_counter * ACL_DATA_BUS_LENGTH) <= pilv8_data;

                    sif_hash.lv8_data <= slv8_data;

                    if (sl_counter_is_zero = '1') then
                        si_tuple_counter_next <= si_tuple_counter - 1;
                    else
                        sif_hash.l_last     <= '1';
                        sstate_acl_fsm_next <= state_acl_get_hash_value;
                    end if;
                end if;

            when state_acl_get_hash_value =>

                if (sl_hash_rdy = '1') then
                    sstate_acl_fsm_next    <= state_acl_fsm_request_hash_address;
                    slv8_hash_address_next <= slv8_hash;
                end if;

            when state_acl_fsm_request_hash_address =>

                sstate_acl_fsm_next <= state_acl_fsm_load_hash_address;
                pol_table_read_en   <= '1';

            when state_acl_fsm_load_hash_address =>

                sstate_acl_fsm_next     <= state_acl_fsm_assert_rule;
                slv104_tuple_table_next <= pilv128_table_data(pilv128_table_data'length - 1 downto pilv128_table_data'length - ACL_TUPLE_LENGTH);

            when state_acl_fsm_assert_rule =>

                if (sl_rule_hit = '1') then
                    sstate_acl_fsm_next <= state_acl_fsm_do_action_permit;
                else
                    sstate_acl_fsm_next <= state_acl_fsm_do_action_block;
                end if;

            when state_acl_fsm_do_action_block =>

                pol_block           <= '1';
                sstate_acl_fsm_next <= state_acl_fsm_idle;

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
            if (pil_rst = '1') then
                sstate_acl_fsm     <= state_acl_fsm_idle;
                slv104_tuple       <= (others => '0');
                si_tuple_counter   <= ACL_TUPLE_COUNTER_INIT - 1;
                slv8_hash_address  <= (others => '0');
                slv104_tuple_table <= (others => '0');
                slv8_data          <= (others => '0');
            else
                sstate_acl_fsm     <= sstate_acl_fsm_next;
                slv104_tuple       <= slv104_tuple_next;
                si_tuple_counter   <= si_tuple_counter_next;
                slv8_hash_address  <= slv8_hash_address_next;
                slv104_tuple_table <= slv104_tuple_table_next;
                slv8_data          <= pilv8_data;
            end if;
        end if;

    end process;

end architecture rtl;