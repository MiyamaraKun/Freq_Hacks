# MATLAB Frequency Sweep and Measurement Script

This MATLAB script sweeps the function generator frequency from 1Hz to 15MHz, measures the peak-to-peak voltages on oscilloscope channels CH1 and CH2, and stores the results in a spreadsheet.

## Instructions
1. **Setup**: Before running this script, ensure that the instruments are turned on and connected to the computer through COM4 (oscilloscope) and COM5 (function generator).

2. **Running the Script**:
   - Open the script in MATLAB.
   - Connect to the function generator and oscilloscope using the specified COM ports.
   - Run the script to perform the frequency sweep and measurements.

3. **Results**:
   - The script will generate 50 logarithmically spaced frequency values from 1Hz to 15MHz.
   - For each frequency value, it will measure the peak-to-peak voltages on channels CH1 and CH2.
   - The results will be stored in a spreadsheet named `Scope_volt_measurement_<timestamp>.xls`.

4. **File Naming**: The spreadsheet containing the measurement results is named with a timestamp to ensure uniqueness.

5. **Notes**:
   - Adjust the time delays (`pause` commands) in the script as needed based on your instrument response times.
   - Update the COM port numbers in the script if your instruments are connected to different ports.

6. **Dependencies**: This script requires the Instrument Control Toolbox in MATLAB for communication with the function generator and oscilloscope.

7. **Author**: [MiyamaraKun]
