library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity alucontrol is
port(
     							
     funct:in std_logic_vector(5 downto 0);			
						    
     aluop1:in std_logic_vector(1 downto 0);			
     aluoper:buffer std_logic_vector(3 downto 0)					
    );
end alucontrol;

architecture behav of alucontrol is
begin
 process(aluop1,funct)
   begin

  case aluop1 is
   when "00"=> aluoper<="0010" ;  --add(for 1w,sw,addi,lui,j)
   when "01"=> aluoper<="0110" ;  --sub--(for beq)
   when others=>
  case funct is
   when "100000"=> aluoper<="0010";  --add
   when "100010"=> aluoper<="0110";  --sub
   when "100100"=> aluoper<="0000";  --and
   when "100101"=> aluoper<="0001";  --0r
   when "101010"=> aluoper<="0111";  --slt
   when "100110"=> aluoper<="0011";  --xor
   when "100111"=> aluoper<="0100";  --nor
   when "000000"=> aluoper<="0101";  --sll
   when "000010"=> aluoper<="1000";  --srl
   when "000011"=> aluoper<="1001";  --inc
   when "000100"=> aluoper<="1010";  --dec
   when "000111"=> aluoper<="1011";  --loop
   when others =>aluoper<="----";
   end case;
   end case;

  end process;
end behav;
