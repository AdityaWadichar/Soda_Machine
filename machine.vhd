--Soda Machine using Behavioural Model in VHDL

--necessary libraries imported
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity machine is
    port
    (
        clk      : in std_logic; -- clock input
    
        qua 	 : in std_logic; --Quarter, Dime and Nickel coins input
        dim 	 : in std_logic;
        nic 	 : in std_logic;
        
        reset    : in std_logic; --reset and enable inputs
        enable   : in std_logic;
        
        soda_out : out std_logic := '0'; --Soda output
        
        qua_counter    : buffer std_logic_vector(1 downto 0) := "00"; --Quarter, Dime and Money Coins Counters where Nickel count can be obtained using these 3 counters
        dim_counter    : buffer std_logic_vector(2 downto 0) := "000";
        money_counter  : buffer std_logic_vector(3 downto 0) := "0000";
        
        qua_ret        : out std_logic_vector(1 downto 0) := "00"; --Change of coins returned  
        dim_ret        : out std_logic_vector(2 downto 0) := "000";
        nic_ret		   : out std_logic_vector(3 downto 0) := "0000"

    );
end entity;


architecture machine_arch of machine is
begin
	
	process(clk)
	
	variable money_var: std_logic_vector(3 downto 0) := money_counter; -- used for intermediate calculations in money_counter 
	
	begin
		if(clk'event and clk = '1') then
		
			if(enable = '1') then
				
				if( reset = '0') then -- enable=1 and reset=0
					qua_ret <= "00"; -- if reset is 0, no change is returned
					dim_ret <= "000";
					nic_ret <= "0000";
					
					if(qua = '1') then
						qua_counter  <= qua_counter + "01";
						
						if(money_var < "1010") then -- money count increased by 5 units
							money_var := money_var+ "0101";
						else 
							money_var := "1111"; -- 4 bit money counter max count
						end if;
						
					end if;

					if(dim = '1') then 
						dim_counter  <= dim_counter + "01";
						
						if(money_var < "1101") then -- money count increased by 2 units
							money_var := money_var + "0010";
						else
							money_var := "1111";
						end if;

					end if;
					
					if(nic = '1') then 
						money_var := money_var + "0001"; -- money_counter increased by 1 unit
					end if;
					
					if(money_var >= "1111") then -- 75 cents or more received, a soda is released and all counters are resetted
						soda_out <= '1';
						money_var := "0000";
						qua_counter <= "00";
						dim_counter <= "000";
					else
						soda_out <= '0';
					end if;
				
				else -- enable=1 and reset=1
				
					qua_ret <= qua_counter+qua; --return the money if stored in counter OR user inputs money after reset is 1
					dim_ret <= dim_counter+dim;
					
					for i in 0 to 4 loop -- subtract Quarter and Dime count from total money to get Nickel count 
						money_var := money_var - qua_counter;
					end loop;
					for i in 0 to 1 loop
						money_var := money_var - dim_counter;
					end loop;
					
					nic_ret <= money_var + nic;
					
					qua_counter <= "00";
					dim_counter <= "000";
					money_var :=  "0000";
				
				end if;
				
			else -- enable=0, reset is Don't Care
				qua_ret <= "00";
				dim_ret <= "000";
				nic_ret <= "0000";
				soda_out <= '0';
			end if;
		end if;
	money_counter <= money_var;
	
	end process;
end machine_arch;
