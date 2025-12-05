library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SmartLibraryCore is
    port (
        clk          : in  std_logic;
        rst_n        : in  std_logic;  -- active low reset

        -- Quantized sensor flags (Step 1)
        T_high       : in  std_logic;  -- temperature high
        R_rise       : in  std_logic;  -- rapid temperature rise
        S_smoke      : in  std_logic;  -- smoke / gas hazard
        P_pm_high    : in  std_logic;  -- PM2.5 high
        G_gas_high   : in  std_logic;  -- gas / VOC high
        N_noise      : in  std_logic;  -- noise high

        -- Actuators (outputs)
        SP_sprinkler : out std_logic;
        AL_alarm     : out std_logic;
        FAN_fire     : out std_logic;
        FAN_aq       : out std_logic;
        PUR_purifier : out std_logic;
        BZ_buzzer    : out std_logic
    );
end entity SmartLibraryCore;


architecture rtl of SmartLibraryCore is

    -- Fire FSM states (Step 3)
    type fire_state_type is (S0_SAFE, S1_WARNING, S2_FIRE);
    signal fire_state, fire_state_next : fire_state_type;

    -- Helper signals
    signal fire_any       : std_logic;
    signal fire_interlock : std_logic;
    signal air_dirty      : std_logic;

begin

    -- helper logic
    fire_any       <= T_high or R_rise or S_smoke;
    fire_interlock <= S_smoke and (T_high or R_rise);
    air_dirty      <= P_pm_high or G_gas_high;

    -- next-state logic
    fire_fsm_next : process(fire_state, fire_any, fire_interlock)
    begin
        fire_state_next <= fire_state;
        case fire_state is
            when S0_SAFE =>
                if fire_interlock = '1' then
                    fire_state_next <= S2_FIRE;
                elsif fire_any = '1' then
                    fire_state_next <= S1_WARNING;
                end if;

            when S1_WARNING =>
                if fire_interlock = '1' then
                    fire_state_next <= S2_FIRE;
                elsif fire_any = '0' then
                    fire_state_next <= S0_SAFE;
                end if;

            when S2_FIRE =>
                fire_state_next <= S2_FIRE;  -- latched
        end case;
    end process fire_fsm_next;

    -- state register
    fire_fsm_reg : process(clk, rst_n)
    begin
        if rst_n = '0' then
            fire_state <= S0_SAFE;
        elsif rising_edge(clk) then
            fire_state <= fire_state_next;
        end if;
    end process fire_fsm_reg;

    -- output logic
    outputs_proc : process(fire_state, air_dirty, N_noise)
    begin
        SP_sprinkler <= '0';
        AL_alarm     <= '0';
        FAN_fire     <= '0';
        FAN_aq       <= '0';
        PUR_purifier <= '0';
        BZ_buzzer    <= '0';

        BZ_buzzer    <= N_noise;

        case fire_state is
            when S0_SAFE =>
                null;
            when S1_WARNING =>
                AL_alarm <= '1';
                FAN_fire <= '1';
            when S2_FIRE =>
                AL_alarm     <= '1';
                FAN_fire     <= '1';
                SP_sprinkler <= '1';
        end case;

        if (SP_sprinkler = '0') and (air_dirty = '1') then
            FAN_aq       <= '1';
            PUR_purifier <= '1';
        end if;
    end process outputs_proc;

end architecture rtl;
