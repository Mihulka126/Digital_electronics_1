-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; -- Definition of "to_unsigned"


entity tb_driver_seg is

end entity tb_driver_seg;

architecture testbench of tb_driver_seg is

  constant c_CLK_100MHZ_PERIOD : time    := 10 ns;
  

  signal sig_clk        : std_logic := '0';
  signal sig_rst        : std_logic := '0';
  signal sig_data0      : std_logic_vector(3 downto 0) := (OTHERS => '0');
  signal sig_data1      : std_logic_vector(3 downto 0) := (OTHERS => '0');
  signal sig_seg        : std_logic_vector(6 downto 0) := (OTHERS => '0');
  signal sig_dig        : std_logic_vector(1 downto 0) := (OTHERS => '0');
  
  -- clock signal
  signal sig_clk_100mhz : std_logic := '0';

  
  begin
  
    uut_driver_Seg : entity work.driver_7seg_2digits

    port map (
      clk => sig_clk,
      data0 => sig_data0,
      data1 => sig_data1,
      seg   => sig_seg,
      dig => sig_dig,
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
	
	wait  for 150 ns;
    sig_data0 <= "0101";
    sig_data1 <= "1100";
    
    wait for 50 ns;
    sig_data0 <= "1111";
    sig_data1 <= "1101";


    report "Stimulus process finished";
    wait;

  end process p_stimulus;
---------------------------------------------------------


end architecture testbench;