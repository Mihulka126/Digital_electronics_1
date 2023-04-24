----------------------------------------------------------
-- DRIVER FOR TWO DIGIT 7SEG DISPLAY
-- VER 1.0
----------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

----------------------------------------------------------
-- Entity declaration for display driver
--
--             +-------------------+
--        -----|> clk              |
--        -----| rst               | 
--             |          seg(6:0) |--/--
--        --/--| data0(3:0)        |  7
--        --/--| data1(3:0)        |
--          4  |           dig(1:0)|--/--
--             |                   |  2
--             +-------------------+
--
-- Inputs:
--   clk          -- Main clock
--   rst          -- Synchronous reset
--   data0(3:0)   -- Data values for first digit
--   data1(7:4)   -- Data values for second digit

-- Outputs:
--   seg(1:0)     -- Cathode values for individual segments
--   dig(7:0)     -- Common anode signals to individual digits
--
----------------------------------------------------------

entity driver_7seg_2digits is
  port (
    clk     : in    std_logic;
    rst     : in    std_logic;
    data0   : in    std_logic_vector(3 downto 0);
    data1   : in    std_logic_vector(3 downto 0);
    seg     : out   std_logic_vector(6 downto 0);
    dig     : out   std_logic_vector(1 downto 0)
  );
end entity driver_7seg_2digits;

----------------------------------------------------------
-- Architecture declaration for display driver
----------------------------------------------------------

architecture behavioral of driver_7seg_2digits is

  -- Internal clock enable
  signal sig_en_4ms : std_logic;
  -- Internal 1-bit counter for multiplexing 2 digits
  signal sig_cnt_1bit : std_logic;
  -- Internal 4-bit value for 7-segment decoder
  signal sig_hex : std_logic_vector(3 downto 0);

begin

  --------------------------------------------------------
  -- Instance (copy) of clock_enable entity generates
  -- an enable pulse every 8 ms
  --------------------------------------------------------
  clk_en0 : entity work.clock_enable
    generic map (
      g_max => 800000
    )
    port map (
      clk => clk,
      rst => rst,
      ce  => sig_en_8ms
    );

  --------------------------------------------------------
  -- Instance (copy) of cnt_up_down entity performs
  -- a 2-bit down counter
  --------------------------------------------------------
  cnt : entity work.cnt_up
    port map (
      clk => clk,
      rst => rst,
      en => sig_en_8ms,
      cnt_up => '0',
      cnt => sig_cnt_1bit
    );

  --------------------------------------------------------
  -- Instance (copy) of hex_7seg entity performs
  -- a 7-segment display decoder
  --------------------------------------------------------
  hex_7seg : entity work.hex_7seg
    port map (
      blank => rst,
      hex   => sig_hex,
      seg   => seg
    );

  --------------------------------------------------------
  -- p_mux:
  -- A sequential process that implements a multiplexer for
  -- selecting data for a single digit
  -- and switches the common anodes of each display.
  --------------------------------------------------------
  p_mux : process (clk) is
  begin

    if (rising_edge(clk)) then
      if (rst = '1') then
        sig_hex <= data0;
        dig     <= "10";
      else

        case sig_cnt_1bit is
            
          when '1' =>
            sig_hex <= data1;
            dig     <= "01";
            
          when others =>
            sig_hex <= data0;
            dig     <= "10";
            
        end case;

      end if;
    end if;

  end process p_mux;

end architecture behavioral;
