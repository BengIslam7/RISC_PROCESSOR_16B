library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity instr_reg is
    Port ( 
           clk : in  std_logic;
           ce  : in  std_logic;
           rst : in  std_logic;
           instr : in STD_LOGIC_VECTOR ( 15 downto 0 );
           cond : out STD_LOGIC_VECTOR ( 3 downto 0 );
           op : out STD_LOGIC_VECTOR ( 3 downto 0 );
           updt : out STD_LOGIC ;
           imm : out STD_LOGIC ;
           val : out STD_LOGIC_VECTOR (5 downto 0 )); 
end instr_reg;

architecture Arch of instr_reg is
begin
    process (clk,rst)
    begin
    if rst='1' then 
        cond <="0000" ;
        op <="0000";
        updt <='0';
        imm <='0';
        val <="000000";
    elsif ce='1' and clk'event and clk='1' then
        cond <= instr ( 15 downto 12);  
        op <= instr ( 11 downto 8); 
        updt <= instr (7);   
        imm <= instr (6);
        val <= instr( 5 downto 0);
   end if ;
   end process ;
end Arch ;
