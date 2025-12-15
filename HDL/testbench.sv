library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end entity;

architecture tb of testbench is
  signal clk         : std_logic := '0';
  signal rst_n       : std_logic := '0';
  signal reset_fire  : std_logic := '0';
  signal T           : std_logic := '0';
  signal R           : std_logic := '0';
  signal G           : std_logic := '0';
  signal state       : std_logic_vector(1 downto 0);
  signal alarm       : std_logic;
  signal suppression : std_logic;

  function st_name(s : std_logic_vector(1 downto 0)) return string is
  begin
    if s = "00" then return "SAFE";
    elsif s = "01" then return "WARNING";
    elsif s = "10" then return "FIRE";
    else return "UNK";
    end if;
  end function;

begin
  -- DUT
  dut: entity work.eldig_fsm
    port map (
      clk         => clk,
      rst_n       => rst_n,
      reset_fire  => reset_fire,
      T           => T,
      R           => R,
      G           => G,
      state       => state,
      alarm       => alarm,
      suppression => suppression
    );

  -- Clock 10 ns period
  clk <= not clk after 5 ns;

  -- Stimulus (finite)
  stim: process
  begin
    -- Hold reset
    rst_n <= '0';
    reset_fire <= '0';
    T <= '0'; R <= '0'; G <= '0';
    wait for 20 ns;

    -- Release reset
    rst_n <= '1';
    wait for 10 ns;

    -- SAFE -> WARNING (T)
    T <= '1'; wait for 10 ns;
    T <= '0'; wait for 20 ns;

    -- WARNING -> FIRE (G and R)
    G <= '1'; R <= '1'; wait for 10 ns;
    R <= '0'; wait for 10 ns;
    G <= '0'; wait for 20 ns;

    -- FIRE latched (wait a bit)
    wait for 30 ns;

    -- reset_fire -> SAFE
    reset_fire <= '1'; wait for 10 ns;
    reset_fire <= '0'; wait for 20 ns;

    report "Simulation finished." severity note;

    -- Stop simulator safely (avoid infinite run)
    -- Preferred (VHDL-2019):
    -- std.env.stop;
    -- More compatible:
    assert false report "END_SIM" severity failure;
  end process;

  -- Monitor ONLY when state changes (low output)
  mon: process
    variable prev_state : std_logic_vector(1 downto 0) := "XX";
  begin
    wait until rising_edge(clk);
    if state /= prev_state then
      report "state=" & st_name(state) &
             "  (T=" & std_logic'image(T) &
             " R=" & std_logic'image(R) &
             " G=" & std_logic'image(G) &
             " alarm=" & std_logic'image(alarm) &
             " sup=" & std_logic'image(suppression) & ")"
             severity note;
      prev_state := state;
    end if;
  end process;

end architecture;
