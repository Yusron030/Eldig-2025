library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eldig_fsm is
  port (
    clk         : in  std_logic;
    rst_n       : in  std_logic; -- active-low async reset
    reset_fire  : in  std_logic; -- active-high: FIRE -> SAFE
    T           : in  std_logic;
    R           : in  std_logic;
    G           : in  std_logic;
    state       : out std_logic_vector(1 downto 0); -- 00 SAFE, 01 WARNING, 10 FIRE
    alarm       : out std_logic;
    suppression : out std_logic
  );
end entity;

architecture rtl of eldig_fsm is
  type st_t is (SAFE, WARNING, FIRE);
  signal s, ns : st_t;
begin

  -- Next-state logic
  process(s, T, R, G, reset_fire)
    variable any_warn : boolean;
  begin
    ns <= s;
    any_warn := (T = '1') or (R = '1') or (G = '1');

    case s is
      when SAFE =>
        if any_warn then
          ns <= WARNING;
        end if;

      when WARNING =>
        if (G = '1') and ((T = '1') or (R = '1')) then
          ns <= FIRE;
        elsif not any_warn then
          ns <= SAFE; -- optional: return to SAFE if all clear
        end if;

      when FIRE =>
        if reset_fire = '1' then
          ns <= SAFE;
        else
          ns <= FIRE; -- latched
        end if;
    end case;
  end process;

  -- State register
  process(clk, rst_n)
  begin
    if rst_n = '0' then
      s <= SAFE;
    elsif rising_edge(clk) then
      s <= ns;
    end if;
  end process;

  -- Outputs (Moore)
  process(s)
  begin
    alarm       <= '0';
    suppression <= '0';
    state       <= "00";

    case s is
      when SAFE =>
        state       <= "00";
        alarm       <= '0';
        suppression <= '0';

      when WARNING =>
        state       <= "01";
        alarm       <= '1';
        suppression <= '0';

      when FIRE =>
        state       <= "10";
        alarm       <= '1';
        suppression <= '1';
    end case;
  end process;

end architecture;
