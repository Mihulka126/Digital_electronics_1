----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2023 11:32:19 AM
-- Design Name: 
-- Module Name: uart - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart is
    Port (  
        clk      : in    std_logic;
        
        rst      : in    std_logic; 
        data_in  : in STD_LOGIC_VECTOR (7 downto 0);
        btn_send : in STD_LOGIC;
        data_out : out STD_LOGIC);
end uart;

architecture Behavioral of uart is

  -- Internal clock enable
  signal sig_en_104us : std_logic;

begin
  --------------------------------------------------------
  -- Instance (copy) of clock_enable entity generates
  -- an enable pulse every 4 ms
  --------------------------------------------------------
  clk_en0 : entity work.clock_enable
    generic map (
      -- FOR SIMULATION, KEEP THIS VALUE TO 2
      -- FOR IMPLEMENTATION, CHANGE THIS VALUE TO 200,000
      -- 2      @ 2 ns
      -- 200000 @ 2 ms
      g_max => 10417
    )
    port map (
      clk => clk,
      rst => rst,
      ce  => sig_en_104us
    );


end Behavioral;
