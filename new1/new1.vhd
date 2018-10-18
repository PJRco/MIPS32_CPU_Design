library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity new1 is
port(
     clk: in std_logic;								
     a1:in std_logic_vector(31 downto 0);			
     aluopt:in std_logic;				    
     b1:in std_logic_vector(31 downto 0);			
     result:buffer std_logic_vector(31 downto 0);
     buff1:buffer std_logic_vector(31 downto 0);
     buff2:buffer std_logic_vector(31 downto 0);		
     zero: out std_logic							
    );
end new1;

architecture behav of new1 is
begin
 process(a1,b1)
 variable x1:integer;
 begin
   if(aluopt='1') then
   x1:=8;
   if(clk'event and clk='1') then
   buff2<=a1;
   end if;
   while(x1>0)loop
   if(clk'event and clk='1') then
   buff1<=buff2+1;
   end if;
   if(clk'event and clk='1') then
   buff2<=buff1;
   end if;
   x1:=x1-1;
   end loop;
   result<=buff1;
   else result<=x"00000000" ;
   end if;
  end process;
end behav;

