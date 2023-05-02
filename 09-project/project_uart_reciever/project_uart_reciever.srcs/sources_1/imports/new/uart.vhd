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

entity uart_rx is
    Port (  
        clk             : in   std_logic;    
        rst             : in   std_logic; 
        data_in         : in   std_logic;
        parity          : out  std_logic;
        data_out_bit0   : out  std_logic;
        data_out_bit1   : out  std_logic;
        data_out_bit2   : out  std_logic;
        data_out_bit3   : out  std_logic;
        data_out_bit4   : out  std_logic;
        data_out_bit5   : out  std_logic;
        data_out_bit6   : out  std_logic;
        data_out_bit7   : out  std_logic;
        data_analyze    : out  std_logic);
        
end uart_rx;

architecture Behavioral of uart_rx is

  -- Internal clock enable
    signal sig_en_104us         : std_logic;
    signal sig_cnt_4bit         : std_logic_vector (3 downto 0);
    signal sig_rst_cnt          : std_logic;
  

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
p_uart_rx : process (clk) is
    variable parity_in            : std_logic := '0';
    variable parity_data          : std_logic := '0';
    variable recieve              : std_logic := '0';
    variable lastState            : std_logic := '0';
    variable sig_data_out         : std_logic_vector(7 downto 0);
  
    begin
    if (rising_edge(clk)) then
        if (rst = '1') then
            sig_data_out := "00000000";
            data_out_bit0 <= '0';
            data_out_bit1 <= '0';
            data_out_bit2 <= '0';
            data_out_bit3 <= '0';
            data_out_bit4 <= '0';
            data_out_bit5 <= '0';
            data_out_bit6 <= '0';
            data_out_bit7 <= '0';
            lastState := '0';
            recieve := '0';
            sig_rst_cnt <= '1';
            parity  <= '0';
        else
            sig_rst_cnt <= '1';
            
            if data_in = '0' and lastState = '0' then
                lastState := '1';
                recieve := '1';
                --data_out <= "00000000"; --default
            end if;
            
            if recieve = '1' then
                sig_rst_cnt <= '0';
                parity  <= '0';

                case sig_cnt_4bit is
                    when "0000" =>          -- start bit
                        sig_data_out := "00000000";
                    when "0001" =>
                        sig_data_out(0) := data_in;
                    when "0010" =>
                        sig_data_out(1) := data_in;
                    when "0011" =>
                        sig_data_out(2) := data_in;
                    when "0100" =>
                        sig_data_out(3) := data_in;
                    when "0101" =>
                        sig_data_out(4) := data_in;
                    when "0110" =>
                        sig_data_out(5) := data_in;
                    when "0111" =>
                        sig_data_out(6) := data_in;
                    when "1000" =>
                        sig_data_out(7) := data_in;
                    when "1001" =>          -- parity
                        parity_in := data_in;
                    when "1010" =>
                            data_out_bit0 <= sig_data_out(0);
                            data_out_bit1 <= sig_data_out(1);
                            data_out_bit2 <= sig_data_out(2);
                            data_out_bit3 <= sig_data_out(3);
                            data_out_bit4 <= sig_data_out(4);
                            data_out_bit5 <= sig_data_out(5);
                            data_out_bit6 <= sig_data_out(6);
                            data_out_bit7 <= sig_data_out(7);      
                    when others =>
                        parity_data := sig_data_out(0) xor sig_data_out(1) xor sig_data_out(2) xor sig_data_out(3) xor sig_data_out(4) xor sig_data_out(5) xor sig_data_out(6) xor sig_data_out(7);
                            if parity_in = parity_data then
                                parity <= '1';
                            end if;
                        recieve := '0';
                        lastState := '0';
                        sig_rst_cnt <= '1';
                end case;       
                
            end if;

        end if;
    end if;
    
  end process p_uart_rx;

end Behavioral;
