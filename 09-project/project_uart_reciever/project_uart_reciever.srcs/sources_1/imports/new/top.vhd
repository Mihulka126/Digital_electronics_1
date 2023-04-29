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
           JB : out std_logic;
           LEDP : out std_logic);
           --LED : out STD_LOGIC_VECTOR (15 downto 8));
end top;

------------------------------------------------------------
-- Architecture body for top level
------------------------------------------------------------
architecture Behavioral of top is

signal sig_bit0             : std_logic;
signal sig_bit1             : std_logic;
signal sig_bit2             : std_logic;
signal sig_bit3             : std_logic;
signal sig_bit4             : std_logic;
signal sig_bit5             : std_logic;
signal sig_bit6             : std_logic;
signal sig_bit7             : std_logic;


begin
  --------------------------------------------------------
  -- Instance (copy) of driver_7seg_2digits entity
  driver_seg : entity work.driver_7seg_2digit
      port map(
          clk       => CLK100MHZ,
          rst       => BTNC,
          
          data0(0)     => sig_bit0,
          data0(1)     => sig_bit1,
          data0(2)     => sig_bit2,
          data0(3)     => sig_bit3,
          data1(0)     => sig_bit4,
          data1(1)     => sig_bit5,
          data1(2)     => sig_bit6,
          data1(3)     => sig_bit7,

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
        data_analyze => JB,
        data_out_bit0 => sig_bit0,
        data_out_bit1 => sig_bit1,
        data_out_bit2 => sig_bit2,
        data_out_bit3 => sig_bit3,
        data_out_bit4 => sig_bit4,
        data_out_bit5 => sig_bit5,
        data_out_bit6 => sig_bit6,
        data_out_bit7 => sig_bit7
    );

  -- Disconnect the top four digits of the 7-segment display
  AN(7 downto 2) <= b"111111";
  DP <= '1';
  
end architecture Behavioral;
