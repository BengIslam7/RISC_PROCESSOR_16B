library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity alu is
    Port ( op : in STD_LOGIC_VECTOR(3 downto 0);
           i1 : in STD_LOGIC_VECTOR(15 downto 0);
           i2 : in STD_LOGIC_VECTOR(15 downto 0);
           o : out STD_LOGIC_VECTOR(15 downto 0);
           st : out STD_LOGIC_VECTOR ( 3 downto 0 ));
end alu;

architecture ArchALU of alu is
begin
    process (i1, i2, op)
variable res :  STD_LOGIC_VECTOR(15 downto 0);
variable flg : STD_LOGIC_VECTOR( 3 downto 0 );
variable shift : integer;
    begin
        flg := "0000" ;
        res := "0000000000000000";
        case op is
            when "0000" => 
                res := i1 and i2;
            when "0001" => 
                res := i1 or i2;
            when "0010" => 
                res := i1 xor i2;
            when "0011" => 
                res := not i1;
            when "0100" => 
                res := i1 + i2;
                -- CARRY FLAG
                if i1(15) = '1' and i2(15) = '0' and res(15)='0' then
                    flg(1) := '1';
                elsif i1(15) = '0' and i2(15) = '1' and res(15)='0' then
                    flg(1) := '1';
                elsif i1(15) = '1' and i2(15) = '1' and res(15) = '0' then
                    flg(1) := '1';
                elsif i1(15) = '1' and i2(15) = '1' and res(15)='1' then
                    flg(1) := '1';
                else
                    flg(1) := '0';
                end if;
                -- OVERFLOW FLAG
                if ( i1(15) = '1' and i2(15) = '1' and res(15)='0' ) or ( i1(15) = '0' and i2(15) = '0' and res(15)='1' )then
                    flg(0) := '1';
                else
                    flg(0) := '0';
                end if;
            when "0101" =>
                res := i1 - i2 ;
                if (i1(15) = '0' and i2(15) = '1' and res(15)='0') or (i1(15) = '1' and i2(15) = '1' and res(15)='1') or (i1(15) = '0' and i2(15) = '1' and res(15)='1') or  (i1(15) = '0' and i2(15) = '0' and res(15)='1') then
                    flg(1) := '0';
                else flg(1) := '1';
                end if ;
                -- OVERFLOW FLAG
                if ( i1(15) = '1' and i2(15) = '0' and res(15)='0' ) or ( i1(15) = '0' and i2(15) = '1' and res(15)='1' )then
                    flg(0) := '1';
                else
                    flg(0) := '0';
                end if;
            when "0110" => -- SLL               
            shift := to_integer(signed(i2));
            res := STD_LOGIC_VECTOR(shift_left(unsigned(i1), shift));
            if ( i1(15)='0' and res(15)='1') or ( i1(15)='1' and res(15)='0') then
                flg(0):='1';
            else flg(0):='0';
            end if ;
            if ( shift > 0 ) and ( shift <17) then
            flg(1):=i1((15-shift)+1);
            elsif  ( shift < 0) and (shift > -17) then
            flg(1):=i1(-(shift)-1);
            else flg(1):='0';
            end if;
            when "0111" => -- SRL                
            shift := to_integer(signed(i2));
            res := STD_LOGIC_VECTOR(shift_right(unsigned(i1), shift));
            if ( i1(15)='0' and res(15)='1') or ( i1(15)='1' and res(15)='0') then
                flg(0):='1';
            else flg(0):='0';
            end if;
            if ( shift > 0 ) and ( shift <17) then
            flg(1):=i1(shift-1);
            elsif  ( shift < 0) and (shift > -17) then
            flg(1):=i1(15-(-shift)+1);
            else flg(1):='0';
            end if;
            when "1000" => -- LDA
                res := i2 ;
            when "1001" => -- STA
                res := i1 ;
            when "1010" => --MTA
                res := i2 ;
            when "1011" => --MTR
                res := i1 ;
            when "1100" => --JRP
                res := i1 + i2 ;
            when "1101" => --JRN
                res := i1 - i2 ;
            when "1110" => --JPR
                res := i2 ;
            when "1111" => --CALL
                res := i2 ;
            when others =>
                res := "0000000000000000" ;
        end case;
    if res="0000000000000000" then
        flg(3) :='1' ; --ZERO FLAG
    end if;
    if res(15)='1' then 
        flg(2) := '1'; --NEG FLAG
    end if ;
    st <= flg ;
    o <= res ;
   end process ;
end ArchALU ;