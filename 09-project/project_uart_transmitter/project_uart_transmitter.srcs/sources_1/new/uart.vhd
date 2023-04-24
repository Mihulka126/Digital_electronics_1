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
  signal sig_cnt_4bit   : std_logic_vector (3 downto 0);
  signal sig_rst_cnt    : std_logic;


begin
  --------------------------------------------------------
  -- Instance (copy) of clock_enable entity generates
  -- an enable pulse every 4 ms
  --------------------------------------------------------
  clk_en : entity work.clock_enable
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
  -- Instance (copy) of cnt_up_down entity
  --------------------------------------------------------
  bin_cnt0 : entity work.cnt_up_down_uart
     generic map(
          g_CNT_WIDTH => 4
      )
      port map(
          clk => clk,
          rst => sig_rst_cnt,
          en => sig_en_104us,
          cnt_up => '1',
          cnt => sig_cnt_4bit
      );
    
  --------------------------------------------------------
  -- p_mux:
  -- A sequential process that implements a multiplexer for
  -- selecting data for a single digit, a decimal point,
  -- and switches the common anodes of each display.
  --------------------------------------------------------
  p_uart : process (clk) is
  variable send                 : std_logic := '0';
  variable lastButtonState      : std_logic := '0';
  
  begin
    
    if (rising_edge(clk)) then
      if (rst = '1') then
        data_out <= '1';
        lastButtonState := '0';
        send := '0';
        sig_rst_cnt <= '1';
      else
        
        sig_rst_cnt <= '1';
        if btn_send = '1' and lastButtonState = '0' then
            lastButtonState := btn_send;
            send := '1';
            data_out <= '1'; --default
            parity <= data_in(0) xor data_in(1) xor data_in(2) xor data_in(3) xor data_in(4) xor data_in(5) xor data_in(6) xor data_in(7);          
        end if;
        
        if send = '1' then
            sig_rst_cnt <= '0';
            case sig_cnt_4bit is
                when "0000" =>
                    data_out <= '1';
                when "0001" =>
                    data_out <= '0'; -- start bit
                when "0010" =>
                    data_out <= data_in(0);
                when "0011" =>
                    data_out <= data_in(1);
                when "0100" =>
                    data_out <= data_in(2);
                when "0101" =>
                    data_out <= data_in(3);
                when "0110" =>
                    data_out <= data_in(4);
                when "0111" =>
                    data_out <= data_in(5);
                when "1000" =>
                    data_out <= data_in(6);
                when "1001" =>
                    data_out <= data_in(7);
                when "1010" =>
                    data_out <= parity;
                when "1011" =>
                    data_out <= '1';
                when "1100" =>
                    data_out <= '1';
                    send := '0';
                    sig_rst_cnt <= '1';
                    lastButtonState := btn_send;
                when others =>
                    data_out <= '1';
          
            end case;
            
        else
            data_out <= '1';
        end if;
        
        if btn_send = '0' and lastButtonState = '1' then
            lastButtonState := btn_send;
        end if;
      end if;
    end if;

  end process p_uart;

end Behavioral;
