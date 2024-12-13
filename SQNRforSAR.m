num_bits = 6;

% upload the appropriate csv file and uncomment the required 
% file path data table and corresponding input frequency 
% to get the spectrum accordingly

% uncomment the below two lines for 6 bit low freq spectrum
% data = SARlowfreqdata.Dec_OutputY;
% fin = (9/1024)*1000000;    % input low frequency

% uncomment the below two lines for 6 bit high freq spectrum
% data = SARhighfreqdata.Dec_OutputY;
% fin = (503/1024)*1000000;    % input high frequency

fs = 1000000;
t = 0:1/fs:1;         
A = 1.8;    

num_levels = 2^num_bits;
step_size = (2 * A) / num_levels;

% plot(data)                                 % uncomment to get output plot
data = (data-32)*step_size + step_size/2;    % mid-rise quantization

N = 1024;
ft = fft(data, N);
PSD = (2/N^2)*(abs(ft(1:N/2)).^2);
signal_bin = round(N*fin/fs)+1;
signal_power = PSD(signal_bin);
noise_power = sum(PSD) - signal_power;

sqnr = 10*log10(signal_power/noise_power);
enob = (sqnr - 1.76)/6;

t = 1024*fin*t/(signal_bin-1);
PSD_db = 10*log10(PSD);                     % plot spectrum in dB
figure;
plot(t(1:N/2), PSD_db);
xlabel("N");
ylabel("Power (dB)");

disp(['SQNR = ', num2str(sqnr), ' dB']);
disp(['ENOB = ', num2str(enob)]);
 
