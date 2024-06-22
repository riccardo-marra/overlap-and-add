% Clear 
clc;
clear;

% Declaration of sequences
x = [2,-2,8,-2,-2,-3,-2,1,-1,9,1,3];
h = [1,1,1];

% Computation of lengths
Ls = length(x); % Length of the input sequence
M = length(h); % Length of the impulse response

N = 2^M; % Ideal length of the subsequences (so padding included)
L = N-M+1; % Length of the subsequences (padding excluded)
n_subarrays = ceil(Ls/L); % Use of ceil function, round the number to the next integer, so if there's a subsequence
                          % that has a length less than L, it's considered
                         

% Creation of cells which will then contain the various subarrays, therefore containing the various subsequences
x_cell = cell(1, n_subarrays);


% Division of the input sequence x, into subsequences
for i = 1:n_subarrays
    % Calculation of the start and end point of each subsequence by manipulating the input sequence x
    startL = (i - 1) * L + 1;
    endL = min(i * L, Ls);  % The min is needed for the last segment, because otherwise endL would go beyond Ls, and give an error
    x_cell{i} = x(startL:endL); % Creation of a cell for each subsequence, dynamically so I can use every input sequence, without having limitations
end

% Zeropadding of sequences
h_pd = horzcat(h(1:end), zeros(1, N-M)); % zeropad of impulse response
for i = 1:n_subarrays
    len = length(x_cell{i}); % Counting how big the subsequence i is, which is the current one in the cycle,
                             % so I know how many zeros I'll need to add for padding
  
    x_cell{i} = [x_cell{i}, zeros(1, N - len)]; % zeropadding the subsequence i, the current one in the loop, of N-subsequence_length
end


% Computation of transform and inverse transform of each subsequence
h_trans = fft(h_pd); % Computation of the FFT(h_pd) outside the for loop, so it won't be calculated it every cycle
for i = 1:n_subarrays
    x_cell_trans{i} = fft(x_cell{i});
    y_cell_trans{i} = x_cell_trans{i} .* h_trans;
    y_cell{i} = ifft(y_cell_trans{i});
end



% I do the ADD operation between the M-1 numbers of the subsequences
numzeros = M - 1; % number of overlapped elements in the subsequences
                        
for i = 1:n_subarrays-1   % The for loop ends in n_subarrays-1, because otherwise it would exceed the index, so it gives an error            
        y_cell{i}(end-numzeros+1:end) = y_cell{i}(end-numzeros+1:end) + y_cell{i+1}(1:numzeros); % Summing the last M-1 elements of the i subarray with the first M-1 elements
                                                                                                 % of the i+1 subarray
        y_cell{i+1}(1:numzeros) = []; % It sets the numbers from 1:numzeros, then the first M-1 numbers as empty values, so they're not printed
                                      
end

% Concatenation of all the cells containing the iffts into a single sequence
y_final = horzcat(y_cell{:}); 

% Displaying the values of y(n) on the command window, so after applying the ADD operation and after joining the various iffts of the subsequences togheter
disp(y_final);


% ------------------- %

% Plotting of y_final
figure(1);
stem(y_final);

y_final_len = length(y_final); % Computation of the length, so the horizontal scaling of the plot is well set
grid on;
xlabel('n'); ylabel('y(n)');
title('Long Sequence: Overlap & Add');

% Axis scaling (Xmin Xmax Ymin Ymax)
% Calculation of max and min values just for scaling the axis in a proper way
y_final_max = max(y_final);
y_final_min = min(y_final);

axis([0 y_final_len+1 y_final_min-1 y_final_max+1]);

