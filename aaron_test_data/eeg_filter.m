%before deploying, make sure to specify the file you are working with
filtered_file = [];
raw_file = csvread('RAW_eeg_ecg_data_only(ecg_isolated).txt')';
for i = 1:length(raw_file(1:end,1))
    channel = raw_file(i,1:end-1);
    fs = 250;             %#sampling rate
    f0 = 60;                %#notch frequency
    fn = fs/2;              %#Nyquist frequency
    freqRatio = f0/fn;      %#ratio of notch freq. to Nyquist freq.

    notchWidth = 0.1;       %#width of the notch

    %Compute zeros
    notchZeros = [exp( sqrt(-1)*pi*freqRatio ), exp( -sqrt(-1)*pi*freqRatio )];

    %#Compute poles
    notchPoles = (1-notchWidth) * notchZeros;

    b = poly( notchZeros ); %# Get moving average filter coefficients
    a = poly( notchPoles ); %# Get autoregressive filter coefficients

    %notch signal x
    y = filter(b,a,channel);
 
    %bandpass
    cutoff = [1 50];
    order = 2;
    
    [b,a] = butter(order, cutoff/fn, 'bandpass');
    y = filter(b,a,y);
    filtered_file = [filtered_file;y];
    
end

filtered_file = filtered_file';
csvwrite('RAW_eeg_ecg_data_only(ecg_isolated)_FILTERED.csv',filtered_file);