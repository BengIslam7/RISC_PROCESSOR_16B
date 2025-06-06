library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control is
    port ( clk : in  std_logic;
         rst : in  std_logic;

         status     : in  std_logic_vector(3 downto 0);
         instr_cond : in  std_logic_vector(3 downto 0);
         instr_op   : in  std_logic_vector(3 downto 0);
         instr_updt : in  std_logic;

         instr_ce  : out std_logic;
         status_ce : out std_logic;
         acc_ce    : out std_logic;
         pc_ce     : out std_logic;
         rpc_ce    : out std_logic;
         rx_ce     : out std_logic;

         ram_we : out std_logic;

         sel_ram_addr : out std_logic;
         sel_op1      : out std_logic;
         sel_rf_din   : out std_logic_vector(1 downto 0) );
end control;
architecture Arch of control is
    type state is (st_fetch1, st_fetch2, st_decode, st_exec, st_store);
    signal state_0 : state ; -- NEXT STATE
    signal state_r : state := st_fetch1 ; -- CURRENT STATE
    begin
    process (clk, rst)
    begin
        if rst = '1' then
            state_r <= st_fetch1;
        elsif clk'event and clk='1' then
            state_r <= state_0;
        end if;
    end process;
    process (state_r , status , instr_cond , instr_op , instr_updt)
    begin
        case state_r is
            when st_fetch1 =>
                instr_ce <= '0';
                acc_ce <= '0';
                status_ce <= '0' ;
                rx_ce <= '0';
                ram_we <= '0';
                rpc_ce <= '0' ;
                pc_ce <= '0';
                sel_ram_addr <= '0'; --PC_OUT to RAM_ADDR
                state_0 <= st_fetch2;
            when st_fetch2 =>
                instr_ce <= '1';
                acc_ce <= '0';
                status_ce <= '0' ;              
                pc_ce <= '0';
                rpc_ce <= '0';
                rx_ce <= '0';
                ram_we <= '0';
                sel_ram_addr <= '0';
                sel_op1 <= '0';
                sel_rf_din <="00";
                state_0 <= st_decode;
            when st_decode =>
                instr_ce <= '0';
                acc_ce <= '0';
                status_ce <= '0' ;
                pc_ce <= '0';
                rpc_ce <= '0';
                rx_ce <= '0';
                ram_we <= '0';
                sel_ram_addr <= '0';
                if ( instr_op ="0000" or instr_op ="0001" or instr_op ="0010" or instr_op ="0100" or instr_op ="0101" or instr_op ="0110" or instr_op ="0111" or instr_op ="1001" or instr_op ="1011") then 
                    sel_op1 <= '0';
                elsif ( instr_op ="1100" or instr_op ="1101") then sel_op1 <= '1' ;
                end if;
                sel_rf_din <= "00";
                state_0 <= st_exec ;
            when st_exec => 
                  status_ce <= '0' ; 
                if (instr_op ="0000" or instr_op ="0001" or instr_op ="0010" or instr_op ="0100" or instr_op ="0101" or instr_op ="0110" or instr_op ="0111" or  instr_op ="1010" or instr_op ="1011" or instr_op="0011" ) then              
                if ( instr_updt ='1') then
                if( instr_cond ="0001") then
                    status_ce <= '1';
                elsif ( instr_cond = "0010" and status(3)='1' ) then 
                    status_ce <= '1';
                elsif ( instr_cond = "0011" and status(3)='0' ) then 
                    status_ce <= '1';
                elsif ( instr_cond = "0100" and ( status(3)='0' and status(2)='0') ) then 
                    status_ce <= '1';
                elsif ( instr_cond = "0101" and (status(3)='1' or status(2)='1') ) then 
                    status_ce <= '1';
                elsif ( instr_cond = "0110" and status(2)='1' ) then 
                    status_ce <= '1';
                elsif ( instr_cond = "0111" and status(2)='0' ) then 
                    status_ce <= '1';
                elsif ( instr_cond = "1000" and status(1)='1' ) then 
                    status_ce <= '1';
                elsif ( instr_cond = "1001" and status(1)='0' ) then 
                    status_ce <= '1';
                elsif ( instr_cond = "1010" and status(0)='1' ) then 
                    status_ce <= '1';
                elsif ( instr_cond = "1011" and status(0)='0' ) then 
                    status_ce <= '1';
                end if ; 
                end if;
                end if ;
                rpc_ce <='0'; 
                pc_ce<='1';
                if (instr_op="1111") then
                    if( instr_cond ="0001") then
                    rpc_ce <='1';
                    pc_ce <='0';
                elsif ( instr_cond = "0010" and status(3)='1' ) then 
                    rpc_ce <='1';
                    pc_ce <='0';
                elsif ( instr_cond = "0011" and status(3)='0' ) then 
                    rpc_ce <='1';
                    pc_ce <='0';
                elsif ( instr_cond = "0100" and ( status(3)='0' and status(2)='0') ) then 
                    rpc_ce <='1';
                    pc_ce <='0';
                elsif ( instr_cond = "0101" and (status(3)='1' or status(2)='1') ) then 
                    rpc_ce <='1';
                    pc_ce <='0';
                elsif ( instr_cond = "0110" and status(2)='1' ) then 
                    rpc_ce <='1';
                    pc_ce <='0';
                elsif ( instr_cond = "0111" and status(2)='0' ) then 
                    rpc_ce <='1';
                    pc_ce <='0';
                elsif ( instr_cond = "1000" and status(1)='1' ) then 
                    rpc_ce <='1';
                    pc_ce <='0';
                elsif ( instr_cond = "1001" and status(1)='0' ) then 
                    rpc_ce <='1';
                    pc_ce <='0';
                elsif ( instr_cond = "1010" and status(0)='1' ) then 
                    rpc_ce <='1';
                    pc_ce <='0';
                elsif ( instr_cond = "1011" and status(0)='0' ) then 
                    rpc_ce <='1';
                    pc_ce <='0';
                end if;
                end if;
                if ( instr_op="1000" ) then 
                    if( instr_cond ="0001") then
                    sel_ram_addr <= '1' ;
                    ram_we <= '0' ;
                elsif ( instr_cond = "0010" and status(3)='1' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '0' ;
                elsif ( instr_cond = "0011" and status(3)='0' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '0' ;
                elsif ( instr_cond = "0100" and ( status(3)='0' and status(2)='0') ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '0' ;
                elsif ( instr_cond = "0101" and (status(3)='1' or status(2)='1') ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '0' ;
                elsif ( instr_cond = "0110" and status(2)='1' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '0' ;
                elsif ( instr_cond = "0111" and status(2)='0' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '0' ;
                elsif ( instr_cond = "1000" and status(1)='1' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '0' ;
                elsif ( instr_cond = "1001" and status(1)='0' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '0' ;
                elsif ( instr_cond = "1010" and status(0)='1' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '0' ;
                elsif ( instr_cond = "1011" and status(0)='0' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '0' ;
                else 
                    sel_ram_addr <= '0';
                    ram_we <='0' ;
                end if;
                elsif ( instr_op="1001" ) then 
                if( instr_cond ="0001") then
                    sel_ram_addr <= '1' ;
                    ram_we <= '1' ;
                elsif ( instr_cond = "0010" and status(3)='1' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '1' ;
                elsif ( instr_cond = "0011" and status(3)='0' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '1' ;
                elsif ( instr_cond = "0100" and ( status(3)='0' and status(2)='0') ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '1' ;
                elsif ( instr_cond = "0101" and (status(3)='1' or status(2)='1') ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '1' ;
                elsif ( instr_cond = "0110" and status(2)='1' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '1' ;
                elsif ( instr_cond = "0111" and status(2)='0' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '1' ;
                elsif ( instr_cond = "1000" and status(1)='1' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '1' ;
                elsif ( instr_cond = "1001" and status(1)='0' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '1' ;
                elsif ( instr_cond = "1010" and status(0)='1' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '1' ;
                elsif ( instr_cond = "1011" and status(0)='0' ) then 
                    sel_ram_addr <= '1' ;
                    ram_we <= '1' ;
                else 
                    sel_ram_addr <= '0';
                    ram_we <='0' ;
                end if;
                else 
                    sel_ram_addr <= '0';
                    ram_we <='0' ;
                end if ;
                instr_ce <= '0';
                acc_ce <= '0';
                rx_ce <= '0';
                sel_op1 <= '0';
                
                sel_rf_din <= "10";
                state_0 <= st_store ;
            when st_store =>                            
                instr_ce <= '0';
                rpc_ce <= '0';
                status_ce <= '0';
                if ( instr_op ="0000" or instr_op ="0001" or instr_op ="0010" or instr_op="0011" or instr_op ="0100" or instr_op ="0101" or instr_op ="0110" or instr_op ="0111" or instr_op ="1000" or instr_op ="1010") then
                    acc_ce <= '1' ;
                    rx_ce <= '0' ;
                    pc_ce <= '0' ;
                elsif (instr_op ="1011" ) then 
                    acc_ce <= '0' ;
                    rx_ce <= '1' ;
                    pc_ce <= '0' ;
                elsif ( instr_op = "1100" or  instr_op = "1101" or instr_op = "1110" or instr_op = "1111" ) then
                    acc_ce <= '0' ;
                    rx_ce <= '0' ;
                    pc_ce <= '1' ;
                else acc_ce <= '0' ;
                    rx_ce <= '0' ;
                    pc_ce <= '0' ;
                end if ;                       
                ram_we <= '0';
                sel_ram_addr <= '0';
                sel_op1 <= '0';
                if ( instr_op = "1000" ) then 
                    sel_rf_din <= "01";
                else sel_rf_din <= "00";
                end if;
                state_0 <= st_fetch1;
                if( instr_cond ="0001") then
                elsif ( instr_cond = "0010" and status(3)='1' ) then 
  
                elsif ( instr_cond = "0011" and status(3)='0' ) then 
          
                elsif ( instr_cond = "0100" and ( status(3)='0' and status(2)='0') ) then 
              
                elsif ( instr_cond = "0101" and (status(3)='1' or status(2)='1') ) then 
                 
                elsif ( instr_cond = "0110" and status(2)='1' ) then 
               
                elsif ( instr_cond = "0111" and status(2)='0' ) then 
                
                elsif ( instr_cond = "1000" and status(1)='1' ) then 
           
                elsif ( instr_cond = "1001" and status(1)='0' ) then 
                 
                elsif ( instr_cond = "1010" and status(0)='1' ) then 
            
                elsif ( instr_cond = "1011" and status(0)='0' ) then 
                else 
                instr_ce <= '0';
                    rpc_ce <= '0';
                status_ce <= '0';
                acc_ce <= '0' ;
                    rx_ce <= '0' ;
                    pc_ce <= '0' ;
                    ram_we <= '0';
                sel_ram_addr <= '0';
                sel_op1 <= '0';
             
                end if ;
            when others =>
                instr_ce <= '0';
                acc_ce <= '0';
                pc_ce <= '0';
                rpc_ce <= '0';
                rx_ce <= '0';
                ram_we <= '0';
                sel_ram_addr <= '0';
                sel_op1 <= '0';
                sel_rf_din <= "00";
        end case;
    end process;
end Arch ;
