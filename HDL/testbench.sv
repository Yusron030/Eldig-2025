library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_SmartLibraryCore is
end entity tb_SmartLibraryCore;

architecture sim of tb_SmartLibraryCore is

    signal clk          : std_logic := '0';
    signal rst_n        : std_logic := '0';

    signal T_high       : std_logic := '0';
    signal R_rise       : std_logic := '0';
    signal S_smoke      : std_logic := '0';
    signal P_pm_high    : std_logic := '0';
    signal G_gas_high   : std_logic := '0';
    signal N_noise      : std_logic := '0';

    signal SP_sprinkler : std_logic;
    signal AL_alarm     : std_logic;
    signal FAN_fire     : std_logic;
    signal FAN_aq       : std_logic;
    signal PUR_purifier : std_logic;
    signal BZ_buzzer    : std_logic;

begin

    -- DUT
    dut : entity work.SmartLibraryCore
        port map (
            clk          => clk,
            rst_n        => rst_n,
            T_high       => T_high,
            R_rise       => R_rise,
            S_smoke      => S_smoke,
            P_pm_high    => P_pm_high,
            G_gas_high   => G_gas_high,
            N_noise      => N_noise,
            SP_sprinkler => SP_sprinkler,
            AL_alarm     => AL_alarm,
            FAN_fire     => FAN_fire,
            FAN_aq       => FAN_aq,
            PUR_purifier => PUR_purifier,
            BZ_buzzer    => BZ_buzzer
        );

    -- clock 10 ns
    clk_proc : process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process clk_proc;

    -- stimulus
    stim_proc : process
    begin
        rst_n <= '0';
        wait for 20 ns;
        rst_n <= '1';

        -- normal
        wait for 40 ns;

        -- air dirty only
        P_pm_high <= '1';
        wait for 50 ns;
        P_pm_high <= '0';
        G_gas_high <= '1';
        wait for 50 ns;
        G_gas_high <= '0';

        -- warning fire (temp only)
        T_high <= '1';
        wait for 60 ns;
        T_high <= '0';

        -- full fire interlock
        S_smoke <= '1';
        T_high  <= '1';
        wait for 60 ns;

        -- clear sensors, fire latched
        S_smoke <= '0';
        T_high  <= '0';
        wait for 80 ns;

        -- noise event
        N_noise <= '1';
        wait for 40 ns;
        N_noise <= '0';

        wait for 100 ns;
        assert false report "Simulation finished" severity failure;
    end process stim_proc;

end architecture sim;
