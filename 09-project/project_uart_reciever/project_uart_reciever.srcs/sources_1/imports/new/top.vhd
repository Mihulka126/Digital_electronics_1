----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2023 11:44:46 AM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
    Port ( CLK100MHZ : in STD_LOGIC;
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out std_logic;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           BTNC : in STD_LOGIC;
           JA : in STD_LOGIC;
           LEDP : out std_logic);
           --LED : out STD_LOGIC_VECTOR (15 downto 8));
end top;

------------------------------------------------------------
-- Architecture body for top level
------------------------------------------------------------
architecture Behavioral of top is

signal sig_data_out         : std_logic_vector (7 downto 0);

begin
  --------------------------------------------------------
  -- Instance (copy) of driver_7seg_2digits entity
  driver_seg : entity work.driver_7seg_2digit
      port map(
          clk       => CLK100MHZ,
          rst       => BTNC,
          
          data0     => sig_data_out(3 downto 0),
          data1     => sig_data_out(7 downto 4),

          seg(6)    => CA,
          seg(5)    => CB,
          seg(4)    => CC,
          seg(3)    => CD,
          seg(2)    => CE,
          seg(1)    => CF,
          seg(0)    => CG,

          dig(1 downto 0) => AN(1 downto 0)
      );
      
      
uart_rx : entity work.uart_rx
    port map(
        clk         => CLK100MHZ,
        rst         => BTNC,
        data_in     => JA,
        parity      => LEDP,
        --data_out    => LED
        data_out    => sig_data_out
    );

  -- Disconnect the top four digits of the 7-segment display
  AN(7 downto 2) <= b"111111";
  DP <= '1';
  
end architecture Behavioral;
