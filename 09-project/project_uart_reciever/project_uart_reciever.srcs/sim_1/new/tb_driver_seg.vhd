-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- Definition of "to_unsigned"


entity tb_driver_7seg_2digit is

end entity tb_driver_7seg_2digit;

architecture testbench of tb_driver_7seg_2digit is

  constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
  

  signal sig_rst   : std_logic := '0';
  signal sig_data0   : std_logic_vector(3 downto 0) := (OTHERS => '0');
  signal sig_data1   : std_logic_vector(3 downto 0) := (OTHERS => '0');
  signal sig_seg   : std_logic_vector(6 downto 0) := (OTHERS => '0');
  signal sig_digit   : std_logic_vector(1 downto 0) := (OTHERS => '0');
  -- clock signal
  signal sig_clk_100mhz : std_logic := '0';
  
  begin
  
    uut_driver_7seg_2digit : entity work.driver_7seg_2digit

    port map (
      clk => sig_clk_100mhz,
      data0 => sig_data0,
      data1 => sig_data1,
      seg => sig_seg,
      dig => sig_digit,
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
	
	sig_data0 <= "0000";
    sig_data1 <= "0000";
    
    wait for 350 ns;
    
    sig_data0 <= "1010";
    sig_data1 <= "0101";
    
    wait for 350 ns;	
    
    sig_data0 <= "1011";
    sig_data1 <= "1101";
    
    wait for 150 ns;
	

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