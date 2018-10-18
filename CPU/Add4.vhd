library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity Add4 is
port(  pcin:   in std_logic_vector(31 downto 0);
       pcout:   out std_logic_vector(31 downto 0)
      );
end Add4;

architecture behavioral of Add4 is
begin
  process(pcin)
  begin
    pcout<=pcin+1;
  end process;
end behavioral;