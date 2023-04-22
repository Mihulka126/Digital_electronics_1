-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- Definition of "to_unsigned"


entity tb_uart is

end entity tb_uart;

architecture testbench of tb_uart is

  constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
  

  signal sig_rst   : std_logic := '0';
  signal sig_data_in   : std_logic_vector(7 downto 0) := (OTHERS => '0');
  signal sig_btn_send   : std_logic := '0';
  signal sig_data_out  : std_logic := '0';
  
  -- clock signal
  signal sig_clk_100mhz : std_logic := '0';
  
  begin
  
    uut_uart : entity work.uart

    port map (
      clk => sig_clk_100mhz,
      data_in => sig_data_in,
      btn_send   => sig_btn_send,
      data_out   => sig_data_out,
      rst => sig_rst
    );


-----------------------------------------
--Clock generation process
-----------------------------------------
 p_clk_gen : process is
  begin

    while now < 1000 ns loop             

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
	wait for 60 ns;
    sig_rst <= '1';
    wait for 50 ns;
    sig_rst <= '0';
    
--    wait for 5 us;
--
--    -- Reset activated
--    sig_btnc <= '1';
--    wait for 1 ms;
 -- Reset deactivated
-- sig_btnc <= '0';
-- --wait for 200 ns;

-- -- Reset activated
-- --sig_rst <= '1';
---- wait for 70 ns;

-- -- Reset deactivated
-- --sig_rst <= '0';

 wait;

 end process p_reset_gen;
---------------------------------------------------------


  --------------------------------------------------------
  -- Data generation process
  --------------------------------------------------------
  p_stimulus : process is
  begin

    report "Stimulus process started";
	
	
	
	
    sig_btn_send <= '0';
    wait for 20 ns;
    sig_data_in <= "10101001";
    wait for 10 ns;
	sig_btn_send <= '1';
    wait for 20 ns;
	sig_btn_send <= '0';
    
    wait for 100 ns;
    sig_data_in <= "10101110";
    wait for 57 ns;
	sig_btn_send <= '1';
    wait for 20 ns;
	sig_btn_send <= '0';
    
    wait for 400 ns;
    sig_data_in <= "01000100";
    wait for 3 ns;
	sig_btn_send <= '1';
    wait for 15 ns;
	sig_btn_send <= '0';

--      sig_data_in <= "00000000";
--      sig_btn_send <= '0';
--      wait for 5 ns;
--      
--      sig_btnr <= '1';
--      wait for 2 ms;
--      
--      sig_sw <= "00001011";
--	  wait for 5 ns;
--	  sig_btnr <= '1';
--      wait for 2 ms;
      


    report "Stimulus process finished";
    wait;

  end process p_stimulus;
---------------------------------------------------------


end architecture testbench;