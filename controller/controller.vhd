library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity controller is
    Port ( memtoreg,memwrite,memread : out  STD_LOGIC;
           op : in  STD_LOGIC_VECTOR (5 downto 0);
           branch,alusrc : out  STD_LOGIC;
           regdst,regwrite : out  STD_LOGIC;
           jump : out  STD_LOGIC;
           aluop : out  STD_LOGIC_VECTOR (1 downto 0));
end controller;

architecture Behavioral of controller is

signal controls:STD_LOGIC_VECTOR (9 downto 0);
begin
process(op)begin
   case op is
	      when "000000"=>controls<="0110000010";--R型
		  when "100011"=>controls<="1101001000";--lw(只有这种情况memread会是1)
		  when "101011"=>controls<="0001010000";--sw
		  when "000100"=>controls<="0000110000";--beq
		  when "001111"=>controls<="0101000000";--lui
		  when "001000"=>controls<="0101000000";--addi
		  when "000010"=>controls<="0000000100";--J
		  when others  =>controls<="----------";
	end case;
end process;

memread <=controls(9);
regwrite<=controls(8);
regdst  <=controls(7);
alusrc  <=controls(6);
branch  <=controls(5);
memwrite<=controls(4);
memtoreg<=controls(3);
jump    <=controls(2);
aluop   <=controls(1 downto 0);

end Behavioral;
