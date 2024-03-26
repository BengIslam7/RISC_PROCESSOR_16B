library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux21 is
    Port ( 
           in0 : in STD_LOGIC_VECTOR (15 downto 0);
           in1 : in STD_LOGIC_VECTOR (15 downto 0);
           sel : in STD_LOGIC ;
           outp : out STD_LOGIC_VECTOR (15 downto 0)
         );
end mux21;

architecture arch of mux21 is
begin
    process (sel, in0, in1)
    begin
        case sel is
            when '0' =>
                outp <= in0;
            when '1' =>
                outp <= in1;
            when others =>
                outp <= X"0000"; -- ou une valeur par défaut si nécessaire
        end case;
    end process;
end arch;
