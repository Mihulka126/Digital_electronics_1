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
After data, there is a parity bit and then two stop bits. If the parity bit is a 1 (even parity), the 1 or logic-high bit in the data frame should total to an odd number. The stop bits raise the level back to high and the transfer is complete. 

## Hardware description of demo application

Transmitter:
Input data word is selected by switches SW 0 (LSB) to SW 7 (MSB) and displayed on 7-seg display in hexadecimal. Right button starts transmission. It transmitts at 9600 bauds and at the end the even parity is added. Transission is ended with two stop bits.
Central button is for reset. Data are transmitted by pin `JA`. 
<p align="center">
  Block diagram of our transmitter designed in VHDL:
  <img src="https://raw.githubusercontent.com/Mihulka126/Digital_electronics_1/742a08a8e7f6dd4f39d0ba7d6153a25b6802d88f/09-project/images/uart_tx.svg" width="900">

Reciever:
Data is recieved at pin `JA` and displayed on 7-seg display in hexadecimal. Central button is for reset. 9600 baud rate is expected.
<p align="center">
  Block diagram of our receiver designed in VHDL:
  <img src="https://raw.githubusercontent.com/Mihulka126/Digital_electronics_1/742a08a8e7f6dd4f39d0ba7d6153a25b6802d88f/09-project/images/uart_rx.svg" width="900">

  
## Software description

#### UART TRANSMITTER:
- **7seg displey driver**:
For displaying are used three entities. `elk_en0` ensures the right timing for switching between two digits of 2 digit 7seg display. The time, each digit is on, is set to 8 ms (assuming 10 MHz clock). The internal enable signal `sig_en_8ms`, whitch is pulses in 8 ms period, is connected to `cnt` netity. Its purpous is to take track of whitch digit should be on and whitch should be off. This is represented by binary output in internal signal `sig_cnt_1bit`, gaining binary value "01" or "10". This signal is then used in process `p_mux`. It sends input data to coresponding digits of 7seg display. `mux_7seg` decodes input hex value to signal, whitch drives each segment of the display. Note, that input data from switches are split into two grups by 4 bits, so 8bit word is displayed as two-digit hex number. Whole component can be reseted by reset button.

Simplified flowchart of `p_mux` process in driver_7seg_2digits component for better understanding:
<p align="center">
<img src="https://github.com/vaclav-kubes/Digital_electronics_1-copy/blob/main/09-project/images/p_mux_flchrt.png?raw=true" width="250">

- **uart**: Right timing for transmission is ensured by `clk_en1`. Constant g_MAX is set to 10417, whitch means, that internal signal `sig_en_104us` will pulse with 104 us period (assuming 10 MHz clock). If counting of `bin_cnt1` is enabled by `sig_cnt_rst` (set in p_uart_tx process), each puls means counter go up by one until it is 12. This binary represented number is through `sig_cnt_4bit` connected to `p_uart_tx`. In `p_uart_tx` we check, if the send button si pressed. If so, the transsision process begins by sending start bit and then each bit of `data_in` is transmitted. The even parity of `data_in` is evaluated also in `p_uart_t` and are sent with two stop bits as UART protocol requires. To ensure, that the data is sent only ones per button press, we use auxiliary variable `lastButtonState`. The counting of counter is enebaled via `sig_cnt_rst only`, when there is instruction to send the data, otherwise the counter is stopped.  Whole component can be resetted by reset button. 
  
Simplified flowchart of `p_uart_tx` process in uart transmitter component for better understanding:
<p align="center">
<img src="https://github.com/vaclav-kubes/Digital_electronics_1-copy/blob/main/09-project/images/p_uart_tx_flchrt.png?raw=true" width="850">
  
#### UART RECEIVER:
- **7seg displey driver**:
The same display driver receiver is used as in UART. For explanation see above.

- **uart**: Right timing for reception is ensured by `clk_en0`. Constant g_MAX is set to 10417, whitch means, that internal signal `sig_en_104us` will pulse with 104 us period (assuming 10 MHz clock). If counting of `bin_cnt0` is enabled by `sig_cnt_rst` (set in p_uart_rx process), each puls means counter go up by one until it is 9.
This binary represented number is connected through `sig_cnt_4bit` to `p_uart_rx`. In `p_uart_rx` we check, if start bit occurs at our `data_in` (connected to `JA` pin in top), in other words, there is zero, while the last state of `data_in` is 1. If so, we enable receiving. If the receiving is enabled, the counter starts to count form 0 to 9. Every 104 us one is added, whitch coresponds to baud rate at the transmitter. Each time we asign current value form `data_in` to coresponding position in 8bit `sig_data_out` vector. At the 9th tick we read the even parity from the `data_in`. After that, we reset/stop counter, evaluate even parity from received data writen to `sig_data_out` and check, if it coresponds with received parity. If they are the same, we set parity to 1, whitch will signalize trouble-free data reception, otherwise parity is set to 0, and user can see that there was problem throught the transmittion and/or reception process. At the end auxiliary variables for incoming data detection are reseted. Whole component can be resetted by reset button.

Simplified flowchart of `p_uart_rx` process in uart transmitter component for better understanding:
<p align="center">
<img src="https://github.com/Mihulka126/Digital_electronics_1/blob/main/09-project/images/p_uart_rx_flchrt.png?raw=true" width="850">

  ### Component(s) simulation

Write descriptive text and simulation screenshots of your components.

## Instructions
To send data:
  1) Connect the GND of transmitter to GND of receiver and TX line at `JA` pin form transmitter to RX pin of receiver.
  2) Set required binary combination on switches (the first eight of them from right side). The hexadecimal representation should be shown on the 7seg display. 
  3) Press and release right button.
  4) Data has been sent!
  5) To reset whole transmitter press and release the central button.  

To recieve data:
  1) Connect the GND of receiver to GND of transmitter and RX line at `JA` pin form receiver to TX pin of transmitter.
  2) Wait until data has been sent, received and processed.
  3) After receiving, the received 8bit data should be shown in hexadecimal at 7seg display.
  4) To reset whole transmitter press and release the central button.  

  The control is very simple and intuitive. Here is picture with transmitter and receiver connected. There are labels in the picture so you can orientate easily.
  
  ![photo of uart tx and rx with labels](images/rx-tx-popsano.jpg)
## References

1. Put here the literature references you used.
2. ...
