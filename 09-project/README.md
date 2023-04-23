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

Reciever:
Data is recieved by pin "číslo" and displayed on 7-seg display in hexadecimal. Central button is for reset. 

## Software description

Put flowchats/state diagrams of your algorithm(s) and direct links to source/testbench files in `src` and `sim` folders. 

### Component(s) simulation

Write descriptive text and simulation screenshots of your components.

## Instructions

Write an instruction manual for your application, including photos or a link to a video.

## References

1. Put here the literature references you used.
2. ...
