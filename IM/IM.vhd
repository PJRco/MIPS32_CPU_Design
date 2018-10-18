library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity IM is
port( address:   in std_logic_vector(31 downto 0);
        im_out:  out std_logic_vector(31 downto 0); ---b20ÓÃÓÚ²âÊÔ
       i_out1:   out std_logic_vector(25 downto 0);  --b1jumpÖ¸Áî
       i_out2:   out std_logic_vector(31 downto 26);  --b2 opcode
       i_out3:   out std_logic_vector(25 downto 21);  --b3 ¼Ä´æÆ÷
       i_out4:   out std_logic_vector(20 downto 16);   --b4 ¼Ä´æÆ÷
       i_out5:   out std_logic_vector(15 downto 11);  --b5 ¼Ä´æÆ÷
       i_out6:   out std_logic_vector(15 downto 0);   --b6  IÐÍÖ¸ÁîÁ¢¼´Êý
       i_out7:   out std_logic_vector(5 downto 0)       --b7 funct
      );
end IM;

architecture behavioral of IM is
signal  im_ex:  std_logic_vector(31 downto 0);

subtype dword is std_logic_vector(31 downto 0);
type memory is array(0 to 16)of dword;
signal mem_initial:memory:=(
(x"02328020"),(x"012a4022"),(x"02959824"),(x"02d78025"),(x"018d5826"),--0~4add,sub,and,or,xor
(x"01ae782a"),(x"01ae7827"),(x"8d300001"),(x"ad290001"),(x"21280001"),--5~9slt,nor,lw,sw,addi
(x"022d4002"),(x"022a4000"),(x"01c04003"),(x"01a04004"),--10~13,srl,sll,inc,dec
(x"1129000f"),--beq
(x"00000000"),--nop
(x"08000000")--j

);
begin
  process(address)
  begin
   im_ex<=mem_initial(conv_integer(address));
   im_out<=im_ex(31 downto 0);
   i_out1<=im_ex(25 downto 0);
   i_out2<=im_ex(31 downto 26);
   i_out3<=im_ex(25 downto 21);
   i_out4<=im_ex(20 downto 16);
   i_out5<=im_ex(15 downto 11);
   i_out6<=im_ex(15 downto 0);
   i_out7<=im_ex(5 downto 0);
  end process;
end behavioral;