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
           SW : in STD_LOGIC_VECTOR (7 downto 0);
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out std_logic;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           BTNR : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           JA : out STD_LOGIC);
end top;

------------------------------------------------------------
-- Architecture body for top level
------------------------------------------------------------
architecture Behavioral of top is
  -- No internal signals are needed today:)
begin

  --------------------------------------------------------
  -- Instance (copy) of driver_7seg_4digits entity
  driver_seg_8 : entity work.driver_7seg_2digits
      port map(
          clk       => CLK100MHZ,
          rst       => BTNC,
          
          data0(3)  => SW(3),
          data0(2)  => SW(2),
          data0(1)  => SW(1),
          data0(0)  => SW(0),
          
          data1(3)  => SW(7),
          data1(2)  => SW(6),
          data1(1)  => SW(5),
          data1(0)  => SW(4),   

          seg(6)    => CA,
          seg(5)    => CB,
          seg(4)    => CC,
          seg(3)    => CD,
          seg(2)    => CE,
          seg(1)    => CF,
          seg(0)    => CG,

          dig(1 downto 0) => AN(1 downto 0)
      );
      
      
      
uart : entity work.uart
    port map(
        clk         => CLK100MHZ,
        rst         => BTNC,
        btn_send    => BTNR,
        data_in(0)  => SW(0),
        data_in(1)  => SW(1),
        data_in(2)  => SW(2),
        data_in(3)  => SW(3),
        data_in(4)  => SW(4),
        data_in(5)  => SW(5),
        data_in(6)  => SW(6),
        data_in(7)  => SW(7),
        data_out    => JA
    );

  -- Disconnect the top four digits of the 7-segment display
  AN(7 downto 2) <= b"111111";
  DP <= '1';

end architecture Behavioral;
