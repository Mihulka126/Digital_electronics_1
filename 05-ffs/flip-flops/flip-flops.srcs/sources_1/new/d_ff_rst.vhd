----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2023 17:30:49
-- Design Name: 
-- Module Name: d_ff_rst - Behavioral
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

entity d_ff_rst is
    Port ( clk : in STD_LOGIC; -- Clock
           rst : in STD_LOGIC; -- High-active synchronous reset
           d : in STD_LOGIC; -- Data input
           q : out STD_LOGIC; -- Main output
           q_bar : out STD_LOGIC); -- Complementary output
end d_ff_rst;

architecture Behavioral of d_ff_rst is
begin
    --------------------------------------------------------
    -- p_d_ff_rst:
    -- D type flip-flop with a high-active sync reset,
    -- rising-edge clk.
    -- q(n+1) = d
    --------------------------------------------------------
    p_d_ff_rst : process(clk)
    begin
        if rising_edge(clk) then  -- Synchronous process
           if (rst = '1') then
                q <= '0';
                q_bar <= '1';
           else
                q     <= d;
                q_bar <= not d;
           end if;
        end if;
    end process p_d_ff_rst;
end Behavioral;
