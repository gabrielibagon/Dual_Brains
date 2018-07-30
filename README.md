# 🧠 Dual Brains 🧠

Real-time visual performance driven by the brain data of two performers.  
https://artahack.io/projects/dual-brains/

![Eva and Aaron at the Spring/Break Art Show 2018, NYC](./Dual_Brains/images/SpringBreak-Art-Show-180308-web.png)
Photo credit: © Kevin Barry - ThoughtWorks

## Running Dual_Brains_Visualization

 - Download and install [Processing](https://processing.org/)
 - Install 2 Processing libraries (Tools->Add Tool->Libraries) : ControlP5 and UDP ( hypermedia's Processing library). Hypermedia's lib can also be gotten at [hypermedia](https://ubaa.net/shared/processing/udp/)
 - Open `Dual_Brains_Visualization/Dual_Brains_Visualization.pde` in Processing and press ▶️.

## Sending data from OpenBCI to Dual_Brains_Visualization

- You will need to have Python 2.7 installed (locally or in a virtual env) and some dependencies:
  - serial
  - pyserial
  - numpy
  - scipy
  - pip

- You will also need to be sure that OpenBCI drivers are properly installed and configured. See [Driver Setup from OpenBCI](http://docs.openbci.com/OpenBCI%20Software/01-OpenBCI_GUI#the-openbci-gui-hardwaredriver-setup-for-openbci_gui-and-openbcihub) for more info.

- Assuming you have pip installed, run this command to install all dependencies at once:

  ```pip install -r requirements.txt```

- If you have an OpenBCI connected to the computer, you can stream the data to the visualization like this:

  ```python python/data_buffer.py --serial-port /path/to/the/serial/port```

- If you don't an OpenBCI connected, you can stream pre-recorded test data to the visualization like this:

  ```python python/data_buffer.py --test-file /path/to/test/file.txt```

  *Different test files are provided in the `aaron_test_data` folder*
  
## Dual Brains Performance Notes
  
### Set up before:

- Confirm Mac USB port names for Dual brains connection. Example of port name: /dev/tty.PL2303-xxx
- To list all ports (long listing): 
 ```ls -l /dev/tty.*```
 
### To run the program:

- Start Processing and open Dual_Brain_Visualization from the folder Documents/Dual_Brains. Make sure you've selected which monitor to use for display and change the settings method accordingly:
  - If you have a second screen
  ```fullScreen(P3D, 2);```
  - If you have only one screen
  ```fullScreen(P3D);```


- To Start the connection with the OpenBCI using the Python script from the Documents/Dual_Brains folder, type:
```python python/data_buffer.py --serial-port /dev/tty.usbserial-DQ007RRX (or whatever the serial port name is)```

- If you want to run the Python script with test data instead:
 ```python python/data_buffer.py --test-file aaron_test_data/OpenBCI-RAW-aaron+eva.txt ```

## Contributors
 - [Eva Lee](http://www.evaleestudio.com/), Artist & Experimental Filmmaker
 - [Gabriel Ibagon](https://github.com/gabrielibagon), Programmer & Artist
 - [Gal Nissim](https://www.galnissim.com/), ScienArtist
 - [Pat Shiu](http://patshiu.com/), Visual Artist
 - [Aaron Trocola](http://threeformfashion.com/), 3D Fashion Designer
 - [Julien Deswaef](https://xuv.be), Artist & Technologist
