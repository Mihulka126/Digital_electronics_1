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
        clk         : in   std_logic;    
        rst         : in   std_logic; 
        data_in     : in   std_logic;
        parity      : out  std_logic;
        seg         : out   std_logic_vector(6 downto 0);
        dig         : out   std_logic_vector(1 downto 0));
        
end uart;

architecture Behavioral of uart is

  -- Internal clock enable
    signal sig_en_104us         : std_logic;
    signal sig_cnt_4bit         : std_logic_vector (3 downto 0);
    signal sig_rst_cnt          : std_logic;
  
    shared variable data_out    : std_logic_vector (7 downto 0);


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
 
    drive_7seg_2digits : entity work.driver_7seg_2digit
        port map(
            clk => clk,
            rst => rst,
            seg => seg,
            dig => dig,
            data0 => data_out(3 downto 0),
            data1 => data_out(7 downto 4)

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
p_uart : process (clk) is
    variable parity_in            : std_logic := '0';
    variable parity_data          : std_logic := '0';
    variable send                 : std_logic := '0';
    variable lastButtonState      : std_logic := '0';
  
    begin
    
        if (rst = '1') then
            data_out := "00000000";
            lastButtonState := '0';
            send := '0';
            sig_rst_cnt <= '0';
        else
            sig_rst_cnt <= '1';
            
            if data_in = '0' and lastButtonState = '0' then
                lastButtonState := '1';
                send := '1';
                data_out := "00000000"; --default
            end if;
        
            if send = '1' then
                sig_rst_cnt <= '0';
                case sig_cnt_4bit is
                    when "0000" =>          -- start bit
                        data_out := "00000000";
                    when "0001" =>
                        data_out(0) := data_in;
                        parity_data := parity_data xor data_in;
                    when "0010" =>
                        data_out(1) := data_in;
                        parity_data := parity_data xor data_in;
                    when "0011" =>
                        data_out(2) := data_in;
                        parity_data := parity_data xor data_in;
                    when "0100" =>
                        data_out(3) := data_in;
                        parity_data := parity_data xor data_in;
                    when "0101" =>
                        data_out(4) := data_in;
                        parity_data := parity_data xor data_in;
                    when "0110" =>
                        data_out(5) := data_in;
                        parity_data := parity_data xor data_in;
                    when "0111" =>
                        data_out(6) := data_in;
                        parity_data := parity_data xor data_in;
                    when "1000" =>
                        data_out(7) := data_in;
                        parity_data := parity_data xor data_in;
                    when others =>          -- parity
                        parity_in := data_in;
                        send := '0';
                        lastButtonState := '0';
                        if parity_in = parity_data then
                            parity <= '1';
                        end if;
                end case;       
            else
                data_out := "00000000";
            end if;
        end if;

  end process p_uart;

end Behavioral;
