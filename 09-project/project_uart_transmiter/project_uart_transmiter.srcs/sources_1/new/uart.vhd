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
        clk      : in   std_logic;    
        rst      : in   std_logic; 
        data_in  : in   std_logic_vector (7 downto 0);
        btn_send : in   std_logic;
        data_out : out  std_logic);
end uart;

architecture Behavioral of uart is

  -- Internal clock enable
  signal sig_en_104us   : std_logic;
  signal parity         : std_logic;


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
    
    
  --------------------------------------------------------
  -- p_mux:
  -- A sequential process that implements a multiplexer for
  -- selecting data for a single digit, a decimal point,
  -- and switches the common anodes of each display.
  --------------------------------------------------------
  p_uart : process (clk) is
  variable parity_v : std_logic := '0';
  begin

    if (rising_edge(clk)) then
      if (rst = '1') then
        data_out <= '1';
      else

        if (btn_send = '1') then
            data_out <= '1'; --default
                for i in data_in'range loop
                    parity_v := parity_v xor data_in(i);
                end loop;
                parity <= parity_v;
            
            if (sig_en_104us = '1') then
                data_out <= '0';
            end if;
            if (sig_en_104us = '1') then
                data_out <= data_in(0);
            end if;
            if (sig_en_104us = '1') then
                data_out <= data_in(1);
            end if;
            if (sig_en_104us = '1') then
                data_out <= data_in(2);
            end if;
            if (sig_en_104us = '1') then
                data_out <= data_in(3);
            end if;
            if (sig_en_104us = '1') then
                data_out <= data_in(4);
            end if;
            if (sig_en_104us = '1') then
                data_out <= data_in(5);
            end if;
            if (sig_en_104us = '1') then
                data_out <= data_in(6);
            end if;
            if (sig_en_104us = '1') then
                data_out <= data_in(7);
            end if;
            if (sig_en_104us = '1') then
                data_out <= parity;
            end if;
            
            if (sig_en_104us = '1') then
                data_out <= '1';
            end if;
            if (sig_en_104us = '1') then
                data_out <= '1';
            end if;  
        else
            data_out <= '1';
        end if;
      end if;
    end if;

  end process p_uart;

end Behavioral;
