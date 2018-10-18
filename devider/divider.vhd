--ÊµÑé7 ³ý·¨Æ÷
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED;

ENTITY divider IS
     GENERIC(k : POSITIVE := 31); --input number word length less one
     PORT( dividend    : IN    BIT_VECTOR(k DOWNTO 0);
		   divisor     : IN    BIT_VECTOR(k DOWNTO 0);
		   alucontr    :in std_logic_vector(3 downto 0);	
           clock       : IN    BIT; 
		   quotient    : OUT   BIT_VECTOR(k DOWNTO 0);
		   remainder_r : OUT   BIT_VECTOR(k DOWNTO 0);--remainder		  
           remainder   : INOUT BIT_VECTOR((2*k + 2) DOWNTO 0);--remainder REG
		   finish      : INOUT BIT
          );
END divider;

ARCHITECTURE structural OF divider IS

SIGNAL drreg      : BIT_VECTOR(k DOWNTO 0);
SIGNAL adderout   : BIT_VECTOR(k DOWNTO 0);
SIGNAL carries    : BIT_VECTOR(k DOWNTO 0);
SIGNAL augend     : BIT_VECTOR(k DOWNTO 0);
SIGNAL tcbuffout  : BIT_VECTOR(k DOWNTO 0);
SIGNAL adder_ovfl : BIT;
SIGNAL clr_dr     : BIT; 
SIGNAL load_dr    : BIT;
SIGNAL init_rem   : BIT;
SIGNAL load_rem   : BIT;
SIGNAL shift_rem  : BIT;
SIGNAL add_op     : BIT; 
signal count      : INTEGER RANGE 0 TO k :=0;
SIGNAL count2     : INTEGER RANGE 0 TO 3 :=0;

BEGIN
PROCESS --main clocked process containing all sequential elements
BEGIN
if(alucontr="1011")
then
		WAIT UNTIL (clock'EVENT AND clock = '1');

        --register to hold divisor during division
        IF clr_dr = '1' THEN
                drreg <= (OTHERS => '0');
        ELSIF load_dr = '1' THEN
                drreg <= divisor;
        ELSE
                drreg <= drreg;
        END IF;                
       
        --register/shifter accumulates partial remainder register
        IF init_rem = '1' THEN
                remainder <= (OTHERS => '0');
                remainder((k+1) DOWNTO 1) <= dividend; --initialize remainder and sll 1 
        ELSIF load_rem = '1' THEN
                remainder((2*k + 1) DOWNTO (k + 1)) <= adderout; --load to top half  
				remainder(2*k+2) <= NOT remainder(2*k+1);	
                remainder(k DOWNTO 0) <= remainder(k DOWNTO 0);  --refresh right half
		ELSIF shift_rem = '1' THEN
                remainder <= remainder ROL 1; --rotate left		
        ELSE
                remainder <= remainder;
        END IF;
END IF;
END PROCESS;

--adder adds/subtracts divisor to left half of the remainder register
augend <= remainder((2*k+1) DOWNTO (k+1));
addgen : FOR i IN adderout'RANGE 
        GENERATE
                lsadder : IF i = 0 GENERATE
                        adderout(i) <= tcbuffout(i) XOR augend(i) XOR (NOT add_op);
                        carries(i) <= (tcbuffout(i) AND augend(i)) OR
                                      (tcbuffout(i) AND (NOT add_op)) OR
                                      ((NOT add_op) AND augend(i));
                        END GENERATE;
                otheradder : IF i /= 0 GENERATE
                        adderout(i) <= tcbuffout(i) XOR augend(i) XOR carries(i-1);
                        carries(i) <= (tcbuffout(i) AND augend(i)) OR
                                      (tcbuffout(i) AND carries(i-1)) OR
                                      (carries(i-1) AND augend(i));
                        END GENERATE;
        END GENERATE;
adder_ovfl <= carries(k-1) XOR carries(k);

tcbuffout <= NOT drreg WHEN (add_op='0') ELSE drreg;

--divider state counter
PROCESS(clock) 

BEGIN 	
if(alucontr="1011")
then
	IF (clock'event AND clock='1') THEN        
		IF (count=count'high AND count2=count2'high) THEN
				count <= 0;
				count2 <= 0;
				finish <='1';			
		ELSIF (count2=count2'high) THEN
				count2 <=1;
				count <= count+1;
				finish <='0';
		ELSE
				count2 <= count2 +1;
				finish <='0';
		END IF;
	END IF;
	end if;
END PROCESS;

--assign control signal values based on state 
PROCESS(count2)

BEGIN
if(alucontr="1011")
then
        --assign defaults, all registers refresh 				
		add_op <='0';
        clr_dr <= '0';
        load_dr <= '0';
        init_rem <= '0';
        load_rem <= '0';
        shift_rem <= '0';		
        IF count2 = 0 THEN
                load_dr <= '1';
                init_rem <= '1';
		ELSIF count2=1 THEN   --minus divisor 
        		add_op <='0';
				load_rem <='1'; 
        ELSIF count2=2 THEN   --restore dividend         
				IF remainder(2*k+1)='0' THEN
					add_op<='0';
					load_rem<='0';				
				ELSE
					add_op<='1';
					load_rem<='1';
				END IF;	
        ELSE  --shift left and set the rem0
            	shift_rem <= '1';   
        END IF;
        end if;
END PROCESS;

PROCESS(finish)
BEGIN
if(alucontr="1011")
then
	IF finish='1' THEN
		remainder_r <='0' & remainder((2*k+1) DOWNTO (k+2));
		quotient <= remainder(k DOWNTO 0);
	ELSE
		quotient <= (OTHERS => '0');
		remainder_r <= (OTHERS => '0');
	END IF;
	end if;
END PROCESS;
END structural;
