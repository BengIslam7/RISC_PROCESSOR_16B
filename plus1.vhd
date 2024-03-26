library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity plus1 is
    Port ( 
           in0 : in STD_LOGIC_VECTOR(15 downto 0 );
           outp : out STD_LOGIC_VECTOR( 15 downto 0 )
         );
end plus1;

architecture arch of plus1 is
    signal res : STD_LOGIC_VECTOR ( 15 downto 0 );
begin
    process (in0)
    begin
       res <= in0 + "0000000000000001" ;
    end process;
    outp <= res ;
end arch;