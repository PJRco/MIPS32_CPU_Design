library ieee;
use ieee.std_logic_1164.all;
entity mux2_1 is
 generic(width:integer:=5);
port(
  d0,d1:in STD_LOGIC_VECTOR(width-1 downto 0);
  s:in STD_LOGIC;
  y:out STD_LOGIC_VECTOR(width-1 downto 0)
  );
 end mux2_1;

  ARCHITECTURE BEHAV OF mux2_1 IS
   BEGIN 
    y<=d0 when s='0' else d1;--s在cpu文件中对应e7，e7对应regdst，s=0时y写入d0，d0对应b4，b4即为reg2地址，s=1时regdst写入y，这其实时判断这条指令用了几个寄存器
END ARCHITECTURE BEHAV;