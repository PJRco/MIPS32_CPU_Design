library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Iregfile is
port(
	     iclk:in std_logic;
         iwe3:in std_logic;   
         ira1:in std_logic_vector(4 downto 0);  
         ira2:in std_logic_vector(4 downto 0);   
         iwa3:in std_logic_vector(4 downto 0);  
         iwd3:in std_logic_vector(31 downto 0);  
         ird1:out std_logic_vector(31 downto 0);  
	     ird2:out std_logic_vector(31 downto 0)); 
end Iregfile;

architecture behave of Iregfile is
  type ramtype is array(31 downto 0) of STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL mem:ramtype;
begin
		
process(iclk)
  begin
   if(iclk'event and iclk='1') then
     if(iwe3='1') then mem(CONV_INTEGER(iwa3))<=iwd3;
    end if;
  end if;
end process;

process(ira1,ira2)
  begin
   if(conv_integer(ira1)=0)then ird1<=x"00000000";
     else ird1<=mem(conv_integer(ira1));
    end  if;
  if(conv_integer(ira2)=0)then ird2<=x"00000000";
     else ird2<=mem(conv_integer(ira2));
    end  if;
end process;

end behave;
