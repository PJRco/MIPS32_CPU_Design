library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity regfile is
port(
	 clk:in std_logic;
         we3:in std_logic;    --写入使能信号
         ra1:in std_logic_vector(4 downto 0);   --哪个寄存器读选择1
         ra2:in std_logic_vector(4 downto 0);   --哪个寄存器读选择2
         wa3:in std_logic_vector(4 downto 0);   --哪个寄存器写选择3
         wd3:in std_logic_vector(31 downto 0);  --写入数据
         rd1:out std_logic_vector(31 downto 0);  --读出数据1
	 rd2:out std_logic_vector(31 downto 0)); --读出数据2
end regfile;

architecture behave of regfile is
  type ramtype is array(31 downto 0) of STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL mem:ramtype:=((x"00000000"),(x"00000001"),(x"00000002"),(x"00000003"),
                       (x"00000004"),(x"00000005"),(x"00000006"),(x"00000007"),
                       (x"00000008"),(x"00000009"),(x"0000000a"),(x"0000000b"),
                       (x"0000000c"),(x"0000000d"),(x"0000000e"),(x"0000000f"),
                        (x"00000000"),(x"00000001"),(x"00000002"),(x"00000003"),
                       (x"00000004"),(x"00000005"),(x"00000006"),(x"00000007"),
                       (x"00000008"),(x"00000009"),(x"0000000a"),(x"0000000b"),
                       (x"0000000c"),(x"0000000d"),(x"0000000e"),(x"0000000f")
                       );
begin
		
process(clk)
  begin
   if(clk'event and clk='1') then
     if(we3='1') then mem(CONV_INTEGER(wa3))<=wd3;
    end if;
  end if;
end process;

process(ra1,ra2)
  begin
   if(conv_integer(ra1)=0)then rd1<=x"00000000";
     else rd1<=mem(conv_integer(ra1));
    end  if;
  if(conv_integer(ra2)=0)then rd2<=x"00000000";
     else rd2<=mem(conv_integer(ra2));
    end  if;
end process;

end behave;
