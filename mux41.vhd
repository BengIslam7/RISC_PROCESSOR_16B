library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux41 is
    Port ( 
           in1 : in STD_LOGIC_VECTOR ( 15 downto 0);
           in2 : in STD_LOGIC_VECTOR ( 15 downto 0);
           in3 : in STD_LOGIC_VECTOR ( 15 downto 0);
           sel : in STD_LOGIC_VECTOR(1 downto 0);
           outp : out STD_LOGIC_VECTOR ( 15 downto 0)
         );
end mux41 ;

architecture arch of mux41 is
begin
    process (sel,in1, in2, in3)
    begin
        case sel is
            when "10" =>
                outp <= in1;
            when "00" =>
                outp <= in2;
            when "01" =>
                outp <= in3;
            when others =>
                outp <= X"0000"; -- ou une valeur par d�faut si n�cessaire
        end case;
    end process;
end arch;

