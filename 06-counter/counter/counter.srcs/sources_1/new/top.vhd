----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2023 11:59:10 AM
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
    Port ( CLK100MHZ : in STD_LOGIC;                    -- Main clock
           SW : in STD_LOGIC;                           -- Counter direction
           CA : out STD_LOGIC;                          -- Cathod A
           CB : out STD_LOGIC;                          -- Cathod B
           CC : out STD_LOGIC;                          -- Cathod C
           CD : out STD_LOGIC;                          -- Cathod D
           CE : out STD_LOGIC;                          -- Cathod E
           CF : out STD_LOGIC;                          -- Cathod F
           CG : out STD_LOGIC;                          -- Cathod G
           AN : out STD_LOGIC_VECTOR (7 downto 0);      -- Common anode signals to individual displays
           BTNC : in STD_LOGIC;                         -- Synchronous reset
           LED : out STD_LOGIC_VECTOR (11 downto 0));   -- LED output
end top;

----------------------------------------------------------
-- Architecture body for top level
----------------------------------------------------------

architecture behavioral of top is

  -- 4-bit counter @ 250 ms
  signal sig_en_250ms : std_logic;                    --! Clock enable signal for Counter0
  signal sig_cnt_4bit : std_logic_vector(3 downto 0); --! Counter0

  -- 12-bit counter @ 10 ms
  signal sig_en_10ms : std_logic;                    --! Clock enable signal for Counter1
  signal sig_cnt_12bit : std_logic_vector(11 downto 0); --! Counter1
  
begin

  --------------------------------------------------------
  -- Instance (copy) of clock_enable entity (0)
  --------------------------------------------------------
  clk_en0 : entity work.clock_enable
      generic map(
          g_MAX => 25000000
      )
      port map(
          clk => CLK100MHZ,
          rst => BTNC,
          ce  => sig_en_250ms
      );

  --------------------------------------------------------
  -- Instance (copy) of clock_enable entity (1)
  --------------------------------------------------------
  clk_en1 : entity work.clock_enable
      generic map(
          g_MAX => 1000000
      )
      port map(
          clk => CLK100MHZ,
          rst => BTNC,
          ce  => sig_en_10ms
      );


  --------------------------------------------------------
  -- Instance (copy) of cnt_up_down entity (0)
  --------------------------------------------------------
  bin_cnt0 : entity work.cnt_up_down
     generic map(
          g_CNT_WIDTH => 4
      )
      port map(
          clk    => CLK100MHZ,
          rst    => BTNC,
          en     => sig_en_250ms,
          cnt_up => SW,
          cnt    => sig_cnt_4bit
      );

  --------------------------------------------------------
  -- Instance (copy) of cnt_up_down entity (1)
  --------------------------------------------------------
  bin_cnt1 : entity work.cnt_up_down
     generic map(
          g_CNT_WIDTH => 12
      )
      port map(
          clk    => CLK100MHZ,
          rst    => BTNC,
          en     => sig_en_10ms,
          cnt_up => SW,
          cnt    => sig_cnt_12bit
      );

  --------------------------------------------------------
  -- Instance (copy) of hex_7seg entity (0)
  --------------------------------------------------------
  hex2seg : entity work.hex_7seg
      port map(
          blank  => BTNC,
          hex    => sig_cnt_4bit,
          seg(6) => CA,
          seg(5) => CB,
          seg(4) => CC,
          seg(3) => CD,
          seg(2) => CE,
          seg(1) => CF,
          seg(0) => CG
      );

  --------------------------------------------------------
  -- Instance (copy) of hex_7seg entity (1)
  --------------------------------------------------------
  hex2led : entity work.hex_led
      port map(
          blank  => BTNC,
          hex    => sig_cnt_12bit,
          led    => LED(11 downto 0)
      );
  --------------------------------------------------------
  -- Other settings
  --------------------------------------------------------
  -- Connect one common anode to 3.3V
  AN <= b"1111_1110";

end architecture behavioral;