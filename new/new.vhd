library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity new is
port(
     								-- ????????D?o?�ꡧ??��?/???-��?
     a1:in std_logic_vector(31 downto 0);			-- 2������??
     aluopt:in std_logic;				    
     b1:in std_logic_vector(31 downto 0);			-- �̨���?2�����¨�y�ꡧoperand��?
     alucontr:in std_logic_vector(3 downto 0);			-- �̨�?t2�����¨�y
     result:buffer std_logic_vector(31 downto 0);
     buff1:buffer std_logic_vector(31 downto 0);
     buff2:buffer std_logic_vector(31 downto 0);		-- ?????��1?
     zero: out std_logic							-- ?????��1?����????flag
    );
end new;

architecture behav of new is
begin
 process(a1,b1,alucontr)
 variable x1:integer;
 begin
   if(aluopt='1') then
   x1:=8;
   buff2<=a1;
   while(x1>0)loop
   buff1<=buff2+1;
   buff2<=buff1;
   x1:=x1-1;
   end loop;
   result<=buff1;
   else result<=x"00000000" ;
  end if;
  end process;
end behav;
