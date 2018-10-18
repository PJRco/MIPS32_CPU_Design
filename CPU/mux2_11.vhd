library ieee;
use ieee.std_logic_1164.all;
entity mux2_11 is
 generic(width:integer:=32);
port(
  d01,d11:in STD_LOGIC_VECTOR(width-1 downto 0);
  s1:in STD_LOGIC;
  y1:out STD_LOGIC_VECTOR(width-1 downto 0)
  );
 end mux2_11;

  ARCHITECTURE BEHAV OF mux2_11 IS
   BEGIN 
    y1<=d01 when s1='0' else d11;
END ARCHITECTURE BEHAV;