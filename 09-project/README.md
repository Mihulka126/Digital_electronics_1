# VHDL project

### UART (Universal Asynchronous Receiver/Transmitter) vysílač a přijímač. 

### Team members

* Martin Mihulka
* Michal Papaj
* Václav Kubeš
* Filip Leikep

## Theoretical description and explanation

UART is asynchronous serial bus. Only two wires are needed - data and ground, there is no clock signal. The transfer speed is fixed and must be the same on
both devices. Default state of data is high, for example +3,3V. When the wires are broken, we know that an error has occurred.
Transmission starts with start-bit - data wire is pulled down to 0V for one period and then data bits. Our devices send and recive eight bits of data. 
After data there is a parity bit and then two stop bits. If the parity bit is a 1 (even parity), the 1 or logic-high bit in the data frame should total to an 
odd number. The stop bits raise the level back to high and the transfer is complete. 

## Hardware description of demo application

Transmitter:
Input data word is selected by switches SW 0 (LSB) to SW 7 (MSB) and displayed on 7-seg display in hexadecimal. Right button starts transmission. 
Central button is for reset. Data are transmitted by pin "číslo pinu". 
![uart transmitter block digram] (images/uart_tx.svg)

Reciever:
Data is recieved by pin "číslo" and displayed on 7-seg display in hexadecimal. Central button is for reset. 

## Software description

#### UART TRANSMITTER:
- **7seg displey driver**:
For displaying are used three entities. `elk_en0` ensures the right timing for switching between two digits of 2 digit 7seg display. The time, each digit is on, is set to 8 ms (assuming 10 MHz clock). The internal enable signal `sig_en_8ms`, whitch is pulses in 8 ms period, is connected to `cnt` netity. Its purpous is to take track of whitch digit should be on and whitch should be off. This is represented by binary output in internal signal `sig_cnt_1bit`, gaining binary value "01" or "10". This signal is then used in process `p_mux`. It sends input data to coresponding digits of 7seg display. `mux_7seg` decodes input hex value to signal, whitch drives each segment of the display. Note, that input data from switches are split into two grups by 4 bits, so 8bit word is displayed as two-digit hex number. Whole component can be reseted by reset button.

Simplified flowchart of `p_mux` process in driver_7seg_2digits component:
![flowchart of p_mux process in driver_7seg_2digits] (images/p_mux_flchrt.png)

- **uart**: Right timing for transmission is ensured by `clk_en1`. Constant g_MAX is set to 10417, whitch means, that internal signal `sig_en_104us` will pulse with 104 us period (assuming 10 MHz clock). If counting of `bin_cnt1` is enabled by `sig_cnt_rst` (set in p_uart_tx process), each puls means counter go up by one until it is 12. This binary represented number is through `sig_cnt_4bit` connected to `p_uart_tx`. In `p_uart_tx` we check, if the send button si pressed. If so, the transsision process begins by sending start bit and then each bit of `data_in` is transmitted. The even parity of `data_in` is evaluated also in `p_uart_t` and are sent with two stop bits as UART protocol requires. To ensure, that the data is sent only ones per button press, we use auxiliary variable `lastButtonState`. The counting of counter is enebaled via `sig_cnt_rst only`, when there is instruction to send the data, otherwise the counter is stopped.  Whole component can be resetted by reset button. 
  
Simplified flowchart of `p_uart_tx` process in uart transmitter component:
![flowchart of p_uart_tx process in uart transmitter] (images/p_uart_tx_flchrt.png)

Put flowchats/state diagrams of your algorithm(s) and direct links to source/testbench files in `src` and `sim` folders. 

### Component(s) simulation

Write descriptive text and simulation screenshots of your components.

## Instructions

Write an instruction manual for your application, including photos or a link to a video.

## References

1. Put here the literature references you used.
2. ...
