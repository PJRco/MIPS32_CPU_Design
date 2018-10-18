library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity tregfile is
port(
	     tclk:in std_logic;
         twe3:in std_logic;   
         tra1:in std_logic_vector(4 downto 0);  
         tra2:in std_logic_vector(4 downto 0);   
         twa3:in std_logic_vector(4 downto 0);  
         twd3:in std_logic_vector(31 downto 0);  
         trd1:out std_logic_vector(31 downto 0);  
	     trd2:out std_logic_vector(31 downto 0)); 
end tregfile;

architecture behave of tregfile is
  type ramtype is array(31 downto 0) of STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL mem:ramtype;
begin
		
process(tclk)
  begin
   if(tclk'event and tclk='1') then
     if(twe3='1') then mem(CONV_INTEGER(twa3))<=twd3;
    end if;
  end if;
end process;

process(tra1,tra2)
  begin
   if(conv_integer(tra1)=0)then trd1<=x"00000000";
     else trd1<=mem(conv_integer(tra1));
    end  if;
  if(conv_integer(tra2)=0)then trd2<=x"00000000";
     else trd2<=mem(conv_integer(tra2));
    end  if;
end process;

end behave;
