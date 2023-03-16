------------------------------------------------------------
--
--! @title One-digit led decoder
--! @author Tomas Fryza
--! Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
--!
--! @copyright (c) 2018 Tomas Fryza
--! This work is licensed under the terms of the MIT license
--!
--! Decoder for one-digit Seven-segment display, Common Anode
--! (active-low). Decoder defines 16 hexadecimal symbols: 0, 1,
--! ..., 9, A, b, C, d, E, F. All segments are turn off when
--! "blank" is high. Decimal Point is not implemented.
--
-- Hardware: Nexys A7-50T, xc7a50ticsg324-1L
-- Software: TerosHDL, Vivado 2020.2

library ieee;
  use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Entity declaration for seven7-segment display decoder
------------------------------------------------------------

entity hex_led is
  port (
    blank : in    std_logic;                    --! Display is clear if blank = 1
    hex   : in    std_logic_vector(11 downto 0); --! Binary representation of one hexadecimal symbol
    led   : out   std_logic_vector(11 downto 0)
  );
end entity hex_led;

------------------------------------------------------------
-- Architecture body for led decoder
------------------------------------------------------------

architecture behavioral of hex_led is

begin

  --------------------------------------------------------
  -- p_led_decoder:
  --------------------------------------------------------

  p_led_decoder : process (blank, hex) is

  begin
    if (blank = '1') then
      led <= "000000000000";     -- LEDs turned off
    else
      if (hex(0) = '1') then led(0) <= '1';
      else led(0) <= '0';
      end if;
      
      if (hex(1) = '1') then led(1) <= '1';
      else led(1) <= '0';
      end if;
      
      if (hex(2) = '1') then led(2) <= '1';
      else led(2) <= '0';
      end if;
      
      if (hex(3) = '1') then led(3) <= '1';
      else led(3) <= '0';
      end if;
      
      if (hex(4) = '1') then led(4) <= '1';
      else led(4) <= '0';
      end if;
      
      if (hex(5) = '1') then led(5) <= '1';
      else led(5) <= '0';
      end if;
      
      if (hex(6) = '1') then led(6) <= '1';
      else led(6) <= '0';
      end if;
      
      if (hex(7) = '1') then led(7) <= '1';
      else led(7) <= '0';
      end if;
      
      if (hex(8) = '1') then led(8) <= '1';
      else led(8) <= '0';
      end if;
      
      if (hex(9) = '1') then led(9) <= '1';
      else led(9) <= '0';
      end if;
      
      if (hex(10) = '1') then led(10) <= '1';
      else led(10) <= '0';
      end if;
      
      if (hex(11) = '1') then led(11) <= '1';
      else led(11) <= '0';
      end if;
    end if;
    
  end process p_led_decoder;
end architecture behavioral;
