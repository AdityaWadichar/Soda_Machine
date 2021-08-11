library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_machine is
end tb_machine;

architecture arch_tb of tb_machine is
	
	component machine 
		Port (         
			clk      : in std_logic;
			qua 	 : in std_logic;
			dim 	 : in std_logic;
			nic 	 : in std_logic;
			reset    : in std_logic;
			enable   : in std_logic;
			
			soda_out 	   : out std_logic ;
			qua_counter    : buffer std_logic_vector(1 downto 0) ;
			dim_counter    : buffer std_logic_vector(2 downto 0) ;
			money_counter  : buffer std_logic_vector(3 downto 0) ;
			qua_ret        : out std_logic_vector(1 downto 0) ;
			dim_ret        : out std_logic_vector(2 downto 0) ;
			nic_ret		   : out std_logic_vector(3 downto 0)

		 );
	end component;

	signal reset,clk, enable, qua,dim,nic,soda_out: std_logic; --signals for respective inputs and outputs
	signal qua_counter,qua_ret:std_logic_vector(1 downto 0);
	signal dim_counter,dim_ret:std_logic_vector(2 downto 0);
	signal nic_ret,money_counter:std_logic_vector(3 downto 0);

	begin
	dut: machine port map (clk => clk, reset=>reset, enable => enable, qua=> qua, dim => dim, nic => nic, soda_out => soda_out, 
								qua_counter => qua_counter, dim_counter => dim_counter,
								money_counter => money_counter, qua_ret => qua_ret,dim_ret => dim_ret,nic_ret => nic_ret); --port mapping

	clk_pro :process
	begin
		 clk <= '0';
		 wait for 50 ps;
		 clk <= '1';
		 wait for 50 ps;
	end process;

	machine_pro: process
	begin       

	-- Test Case 1: enable=1, reset=0
	   reset <= '0';
	   enable <= '1';
	   qua <= '0';
	   dim <=  '0';
	   nic <= '0';
	   wait for 100 ps;
	   for i in 0 to 2 loop 
		   reset <= '0';
		   enable <= '1';
		   qua <= '1';
		   dim <=  '0';
		   nic <= '0';
		   wait for 100 ps;
		end loop;    
	   reset <= '0';
	   enable <= '1';
	   qua <= '0';
	   dim <=  '0';
	   nic <= '0';
	   wait for 100 ps;
-----------------------------------------------------------------------
	-- Test Case 2: enable=1, reset=0
	   reset <= '0';
	   enable <= '1';
	   qua <= '1';
	   dim <=  '1';
	   nic <= '0';
	   wait for 100 ps;
	   reset <= '0';
	   enable <= '1';
	   qua <= '1';
	   dim <=  '1';
	   nic <= '1';
	   wait for 100 ps;
----------------------------------------------------------------------- 
	-- Test Case 3: enable=1, reset=0 initially, after adding some money reset=1
	   reset <= '0';
	   enable <= '1';
	   qua <= '1';
	   dim <=  '0';
	   nic <= '1';
	   wait for 100 ps;
	   reset <= '1';
	   enable <= '1';
	   qua <= '0';
	   dim <=  '0';
	   nic <= '0';
	   wait for 100 ps;
-----------------------------------------------------------------------
	-- Test Case 4: enable=1. reset=1 already, yet money is inserted
	   reset <= '1';
	   enable <= '1';
	   qua <= '1';
	   dim <=  '1';
	   nic <= '1';
	   wait for 100 ps;
-----------------------------------------------------------------------
	-- Test Case 5: enable =0 reset=0
	   reset <= '0';
	   enable <= '0';
	   qua <= '1';
	   dim <=  '0';
	   nic <= '0';
	   wait for 100 ps;
-----------------------------------------------------------------------
	-- Test Case 6: enable=0 reset=1
	   reset <= '1';
	   enable <= '0';
	   qua <= '1';
	   dim <=  '0';
	   nic <= '0';
	   wait for 100 ps;

	   wait;
	end process;
	
end arch_tb;
