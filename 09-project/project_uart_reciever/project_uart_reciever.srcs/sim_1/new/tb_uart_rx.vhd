-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- Definition of "to_unsigned"


entity tb_uart_rx is

end entity tb_uart_rx;

architecture testbench of tb_uart_rx is

  constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
  

  signal sig_rst   : std_logic := '0';
  signal sig_data_in   : std_logic := '1';
  signal sig_data_out  : std_logic_vector(7 downto 0);
  
  -- clock signal
  signal sig_clk_100mhz : std_logic := '0';
  
  begin
  
    uut_uart_rx : entity work.uart_rx

    port map (
      clk => sig_clk_100mhz,
      data_in => sig_data_in,
      data_out   => sig_data_out,
      rst => sig_rst
    );


-----------------------------------------
--Clock generation process
-----------------------------------------
 p_clk_gen : process is
  begin

    while now < 4000 us loop             

      sig_clk_100mhz <= '0';
      wait for c_CLK_100MHZ_PERIOD / 2;
      sig_clk_100mhz <= '1';
      wait for c_CLK_100MHZ_PERIOD / 2;

    end loop;
    wait;                               -- Process is suspended forever

  end process p_clk_gen;
----------------------------------------------------


-----------------------------------------
 --Reset generation process
----------------------------------------
 p_reset_gen : process is
  begin

	sig_rst <= '0';
	wait for 60 us;
    sig_rst <= '1';
    wait for 50 us;
    sig_rst <= '0';
    

 wait;

 end process p_reset_gen;
---------------------------------------------------------


  --------------------------------------------------------
  -- Data generation process
  --------------------------------------------------------
  p_stimulus : process is
  begin

    report "Stimulus process started";
	
    sig_data_in <= '1';
    wait for 152 us;
    
    sig_data_in <= '0';
    wait for 104 us;
    
    sig_data_in <= '1';
    wait for 104 us;
    sig_data_in <= '0';
    wait for 104 us;
    sig_data_in <= '0';
    wait for 104 us;
    sig_data_in <= '1';
    wait for 104 us;
    sig_data_in <= '1';
    wait for 104 us;
    sig_data_in <= '0';
    wait for 104 us;
    sig_data_in <= '1';
    wait for 104 us;
    sig_data_in <= '1';
    wait for 104 us;
    
    sig_data_in <= '1';
    wait for 104 us;
    
    
    
    
    sig_data_in <= '1';
    wait for 157 us;
    
    sig_data_in <= '0';
    wait for 104 us;
    
    sig_data_in <= '1';
    wait for 104 us;
    sig_data_in <= '1';
    wait for 104 us;
    sig_data_in <= '0';
    wait for 104 us;
    sig_data_in <= '1';
    wait for 104 us;
    sig_data_in <= '1';
    wait for 104 us;
    sig_data_in <= '1';
    wait for 104 us;
    sig_data_in <= '1';
    wait for 104 us;
    sig_data_in <= '1';
    wait for 104 us;
    
    sig_data_in <= '1';
    wait for 104 us;
      


    report "Stimulus process finished";
    wait;

  end process p_stimulus;
---------------------------------------------------------


end architecture testbench;