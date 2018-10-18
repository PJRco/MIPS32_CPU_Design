library ieee;
use ieee.std_logic_1164.all;


entity pc is
port(
	 clk,reset:in std_logic;
         pc_in:in std_logic_vector(31 downto 0);  
	 pc_out:out std_logic_vector(31 downto 0)); 
end pc;

architecture behave of pc is
  
begin
		
F:process(clk)
  begin
   if(clk'event and clk='1') then
     if(reset='0') then 
      pc_out<=pc_in;
    end if;
  end if;
end process;
end behave;
