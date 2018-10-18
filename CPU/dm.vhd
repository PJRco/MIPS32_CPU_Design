library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity dm is
port(
     								
     address:in std_logic_vector(31 downto 0);			
						    
     data_in:in std_logic_vector(31 downto 0);			
     write,read:in std_logic;		
     data_out:buffer std_logic_vector(31 downto 0);		
     clock:in std_logic							
    );
end dm;

architecture behav of dm is

type ramtype is array(31 downto 0) of std_logic_vector(31 downto 0);
signal sram:ramtype:=(
(x"00000001"),(x"00000002"),(x"00000003"),(x"00000004"),(x"00000005"),(x"00000006"),(x"00000007"),(x"00000008"),
(x"00000001"),(x"00000002"),(x"00000003"),(x"00000004"),(x"00000005"),(x"00000006"),(x"00000007"),(x"00000008"),
(x"00000001"),(x"00000002"),(x"00000003"),(x"00000004"),(x"00000005"),(x"00000006"),(x"00000007"),(x"00000008"),
(x"00000001"),(x"00000002"),(x"00000003"),(x"00000004"),(x"00000005"),(x"00000006"),(x"00000007"),(x"00000008"));
begin
 write_op:process(write,clock)
  begin
   if(clock'event and clock='1')then
     if(read='0'and write='1')then
      sram(conv_integer(address))<=data_in;
     end if;
    end if;
  end process;
 read_op:process(read,sram,address,write)
  begin
     if(read='1' and write='0')then
      data_out<=sram(conv_integer(address));
      else
     data_out<=(others=>'Z');
     end if;
  end process;
end behav;