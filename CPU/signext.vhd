library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity signext is
port(
         a:in std_logic_vector(15 downto 0);  
	 y:out std_logic_vector(31 downto 0));
end signext;

architecture behave of signext is
  
begin
		
y<=x"0000"&a when a(15)='0' else x"ffff"&a;   --��������չ

end behave;
