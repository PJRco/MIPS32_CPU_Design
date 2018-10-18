library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity alu is
port(
     								-- 运算控制信号（算术/逻辑）
     a1:in std_logic_vector(31 downto 0);			-- 操作码
						    
     b1:in std_logic_vector(31 downto 0);			-- 第一操作数（operand）
     alucontr:in std_logic_vector(3 downto 0);			-- 第二操作数
     result:buffer std_logic_vector(31 downto 0);		-- 运算结果
     zero: out std_logic							-- 运算结果标志位flag
    );
end alu;

architecture behav of alu is
begin
 process(a1,b1,alucontr)

 begin

  case alucontr is
   when "0000"=> result<=a1 and b1 ;  --and
   when "0001"=> result<=a1 or b1 ;   --or
   when "0010"=> result<=a1 + b1 ;  --add
   when "0011"=> result<=a1 xor b1 ;  --xor
   when "0100"=> result<=a1 nor b1 ; --nor
   when "0101"=> result<=TO_STDLOGICVECTOR(to_bitvector(a1) sll conv_integer(b1)) ;  --sll
   when "0110"=> result<=a1 - b1 ;  --sub
   when "1001"=> result<=a1+1 ;      --inc
   when "1010"=> result<=a1-1 ;     --dec
   when "0111"=>                 --slt
    if(a1<b1)then result<=x"00000001" ;
       else result<=x"00000000" ;
     end if; 
   when "1000"=> result<=TO_STDLOGICVECTOR(to_bitvector(a1) srl conv_integer(b1)) ;  --srl
   when others=> result<=x"00000000" ;
   end case;
  if(a1=b1)then   --beq
   zero<='1';
  else
   zero<='0';
  end if;

  end process;
end behav;
