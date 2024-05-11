%This script sweeps the FnGen frequency from 1Hz to 15MHz, and measures the
%pk-pk voltages on oscilloscope CH1 & CH2, and finally store the results
%onto a spreadsheet located the same directory as Matlab workspace

%Before running this script, please make sure the instruments are turned on
%and connected to the computer through COM4(oscilloscope) and COM5(FnGn)

%Clear matlab workspace
clear

%Establish connections to serialport object fgen and set up the amplitude
fgen = serialport('COM5',19200)
writeline(fgen,'*RST')
pause(1)
writeline(fgen,'AMPL:VOLT 5')

pause(1)

%Establish connections to visa object uv
%(visa is a legacy command in matlab future releases, updates will be required)
uv = visa('rs','ASRL4::INSTR')
fopen(uv)
fprintf(uv, '*RST')
pause(1)
%Setup the scope display and settings
fprintf(uv, 'CHAN1:STAT ON');fprintf(uv, 'CHAN2:STAT ON');fprintf(uv, 'AUT')
pause(1)
fprintf(uv, 'PROB1:SET:ATT:MAN 10'); fprintf(uv, 'PROB2:SET:ATT:MAN 10')

fprintf(uv, 'MEAS1 ON'); fprintf(uv, 'MEAS1:SOUR CH1'); fprintf(uv, 'MEAS1:MAIN PEAK')
fprintf(uv, 'MEAS2 ON'); fprintf(uv, 'MEAS2:SOUR CH1'); fprintf(uv, 'MEAS2:MAIN FREQ')
fprintf(uv, 'MEAS3 ON'); fprintf(uv, 'MEAS3:SOUR CH2'); fprintf(uv, 'MEAS3:MAIN PEAK')
fprintf(uv, 'MEAS4 ON'); fprintf(uv, 'MEAS4:SOUR CH2'); fprintf(uv, 'MEAS4:MAIN FREQ')

%generate 50 logarithmically spaced values (1Hz to 15MHz)
freq_values = logspace(log10(10),log10(10e6),50); %changed here to make 2e6 ***********
freq_values = round(freq_values,2);
freq_values = freq_values';

%pre-allocate 4x50 array for storing scope measurements
scope_volt_measurements = zeros(50,4);
scope_volt_measurements(:,1) = freq_values;

%sweeping the FnGen from 1Hz to 15MHz and record the measurments
for i = 1:50
    freq_current = num2str(freq_values(i));
    freq_setting = ['FREQ', ' ', freq_current];
    writeline(fgen, freq_setting);
    
    pause(2)
    fprintf(uv, 'AUT')
    fprintf(uv, 'CHAN1:POS 0') 
    fprintf(uv, 'CHAN2:POS 0')
    pause(3)
    
    if freq_values(i) < 5
        fprintf(uv, 'TIM:SCAL 200e-3')
        pause(5)
    elseif freq_values(i) >= 5 & freq_values(i) < 200
        pause(2)
    else
        
    end
    

    scope_volt_measurements(i,2) = str2double(query(uv,'MEAS1:RES?PEAK'));
    pause(1)
    scope_volt_measurements(i,3) = str2double(query(uv,'MEAS3:RES?PEAK'));
    pause(1)

end

fclose(uv)

scope_volt_measurements(:,4) = scope_volt_measurements(:,3)./scope_volt_measurements(:,2);

time_now = string(datetime('now','Format','yyyy-MM-dd''T''HHmmss'));
filename = strcat('Scope_volt_measurement_',time_now,'.xls');

T = array2table(scope_volt_measurements);
T.Properties.VariableNames(1:4) = {'Frequency (Hz)','CH1 Reading (V)','CH2 Reading (V)','CH2/CH1'};
writetable(T,filename);


