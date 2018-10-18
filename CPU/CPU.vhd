library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity CPU is
port(
	rout1,rout2: out std_logic_vector(31 downto 0);
   clk1,ret: in std_logic
);
end CPU;
architecture behave of CPU is

signal a1,a2,a3,a4:std_logic_vector(31 downto 0);
signal b1:std_logic_vector(25 downto 0);
signal b2,b7:std_logic_vector(5 downto 0);
signal b3,b4,b5,b8:std_logic_vector(4 downto 0);
signal b6:std_logic_vector(15 downto 0);
signal c1,c2,c3,c4,c5,c6,c7,c8,c9,b20:std_logic_vector(31 downto 0);
signal d1:std_logic_vector(1 downto 0);
signal e1,e2,e3,e4,e5,e6,e7,e8,e9,e10 :std_logic;
signal f1:std_logic_vector(3 downto 0);
--signal g1:std_logic_vector(27 downto 0);

component Add4
port(pcin:in std_logic_vector(31 downto 0);
	pcout:out std_logic_vector(31 downto 0)); 
end component;

component pc
	port(pc_in:   	in std_logic_vector(31 downto 0);
	     clk,reset: in std_logic;
	     pc_out:    out std_logic_vector(31 downto 0));
end component;

component IM
port( address:   in std_logic_vector(31 downto 0);
        im_out:  out std_logic_vector(31 downto 0); ---b20
       i_out1:   out std_logic_vector(25 downto 0);  --b1
       i_out2:   out std_logic_vector(31 downto 26);  --b2
       i_out3:   out std_logic_vector(25 downto 21);  --b3
       i_out4:   out std_logic_vector(20 downto 16);   --b4
       i_out5:   out std_logic_vector(15 downto 11);  --b5
       i_out6:   out std_logic_vector(15 downto 0);   --b6
       i_out7:   out std_logic_vector(5 downto 0)       --b7
      );
end component;

component add
    Port ( a: in  STD_LOGIC_VECTOR (31 downto 0);
	         b : in  STD_LOGIC_VECTOR (31 downto 0);
           y : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component mux2_1
    generic (width:integer:=5);
    Port ( d0,d1 : in  STD_LOGIC_VECTOR (width-1 downto 0);
           s : in  STD_LOGIC;
           y : out  STD_LOGIC_VECTOR (width-1 downto 0)); 
end component;

component mux2_11
    generic (width:integer:=32);
    Port ( d01,d11 : in  STD_LOGIC_VECTOR (width-1 downto 0);
           s1 : in  STD_LOGIC;
           y1 : out  STD_LOGIC_VECTOR (width-1 downto 0));
end component;

component and_gate
port(
	a,b:in std_logic;
	c:out std_logic
	);
end component;

component controller
    Port ( memtoreg,memwrite,memread : out  STD_LOGIC;
           op : in  STD_LOGIC_VECTOR (5 downto 0);
           branch,alusrc : out  STD_LOGIC;
           regdst,regwrite : out  STD_LOGIC;
           jump : out  STD_LOGIC;
           aluop : out  STD_LOGIC_VECTOR (1 downto 0));
end component;

component regfile
    Port ( clk : in  STD_LOGIC;
           we3 : in  STD_LOGIC;
           ra1 : in  STD_LOGIC_VECTOR (4 downto 0);
           ra2 : in  STD_LOGIC_VECTOR (4 downto 0);
           wa3 : in  STD_LOGIC_VECTOR (4 downto 0);
           wd3 : in  STD_LOGIC_VECTOR (31 downto 0);
           rd1 : out  STD_LOGIC_VECTOR (31 downto 0);
           rd2 : out  STD_LOGIC_VECTOR (31 downto 0)); 
end component;

component signext
    Port ( a : in  STD_LOGIC_VECTOR (15 downto 0);
           y : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component alu
Port (
 a1, b1 : in STD_LOGIC_vector(31 downto 0);
 alucontr: in STD_LOGIC_VECTOR (3 downto 0);
 result : buffer STD_LOGIC_VECTOR (31 downto 0);
 zero : out STD_LOGIC
);
end component;

component alucontrol
    Port ( funct : in  STD_LOGIC_VECTOR (5 downto 0);
           aluop1 : in  STD_LOGIC_VECTOR (1 downto 0);
           aluoper : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

component dm
port(
    address: in std_logic_vector(31 downto 0);
    data_in: in std_logic_vector(31 downto 0);
    write,read: in std_logic;
    data_out: out std_logic_vector(31 downto 0);
    clock: in std_logic
    );
end component;

component tregfile
    Port ( tclk : in  STD_LOGIC;
           twe3 : in  STD_LOGIC;
           tra1 : in  STD_LOGIC_VECTOR (4 downto 0):=("00001");
           tra2 : in  STD_LOGIC_VECTOR (4 downto 0):=("00000");
           twa3 : in  STD_LOGIC_VECTOR (4 downto 0):=("00001");
           twd3 : in  STD_LOGIC_VECTOR (31 downto 0);
           trd1 : out  STD_LOGIC_VECTOR (31 downto 0);
           trd2 : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component Iregfile

    Port ( iclk : in  STD_LOGIC;
           iwe3 : in  STD_LOGIC;
           ira1 : in  STD_LOGIC_VECTOR (4 downto 0):=("00001");
           ira2 : in  STD_LOGIC_VECTOR (4 downto 0):=("00000");
           iwa3 : in  STD_LOGIC_VECTOR (4 downto 0):=("00001");
           iwd3 : in  STD_LOGIC_VECTOR (31 downto 0);
           ird1 : out  STD_LOGIC_VECTOR (31 downto 0);
           ird2 : out  STD_LOGIC_VECTOR (31 downto 0));
end component;



begin
process(clk1)
  begin
   if(clk1'event and clk1='1') then
     rout1<=b20;
	 rout2<=c2; 
  end if;
end process;
a4<=(a3(31 downto 26))&(b1);
z1:Add4 port map
(
pcin=>a1,
pcout=>a3
);
z2:and_gate port map
(
a=>e2,
b=>e9,
c=>e10
);
z3:mux2_1 port map
(
d0=>b4,
d1=>b5,
s=>e7,
y=>b8
);
z4:mux2_11 port map
(
d01=>c4,
d11=>c1,
s1=>e6,
y1=>c5
);
z5:mux2_11 port map  --memtoreg
(
d01=>c6,
d11=>c7,
s1=>e3,
y1=>c2
);
z6:mux2_11 port map  
(
d01=>a3,
d11=>c8,
y1=>c9,
s1=>e10
);
z7:mux2_11 port map
(
d01=>c9,
d11=>a4,
y1=>a2,
s1=>e8

);
z8:regfile port map
(
clk=>clk1,
we3=>e1,
ra1=>b3,
ra2=>b4,
wa3=>b8,
wd3=>c2,
rd1=>c3,
rd2=>c4
);
z9:signext port map
(
a=>b6,
y=>c1
);

z12:pc port map
(
pc_in=>a2,
pc_out=>a1,
clk=>clk1,
reset=>ret
);
z13:IM port map
(
 im_out=>b20,
 i_out1=>b1,
 i_out2=>b2,
 i_out3=>b3,
 i_out4=>b4,
 i_out5=>b5,
 i_out6=>b6,
 i_out7=>b7,
 address=>a1

);
z14:add port map
(
a=>a3,
b=>c1,
y=>c8
);
z15:controller port map
(
memtoreg=>e3,
memwrite=>e4,
memread=>e5,
op=>b2,
branch=>e2,
alusrc=>e6,
regdst=>e7,
regwrite=>e1,
jump=>e8,
aluop=>d1
);
z16:alu port map
(
a1=>c3,
b1=>c5,
alucontr=>f1,
result=>c6,
zero=>e9
);
z17:alucontrol port map
(
funct=>b7,
aluop1=>d1,
aluoper=>f1
);
z18:dm port map
(
address=>c6,
data_in=>c4,
write=>e4,
read=>e5,
data_out=>c7,
clock=>clk1
);


end behave;
