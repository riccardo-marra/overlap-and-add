# Overlap-and-Add

## 1. Segmentation:

- Divide the long input sequence, denoted as $x(n)$, into overlapping segments. Each segment has a length equal to N, which is calculated as $2^M$, where M is the length of the filter.

- The overlap between adjacent segments ensures that no information is lost during the convolution process.

## 2. Zero Padding:

- To perform fast convolution using the Fast Fourier Transform (FFT), we need to work with sequences whose lengths are powers of two.

- Zero-pad both the input sequence and the FIR filter to the nearest power of two. Let's denote the zero-padded sequences as $x_{pd}(n)$ and $h_{pd}(n)$.

## 3. Frequency Domain Convolution:

- Compute the FFT of the zero-padded impulse response: $H(k) = \text{FFT}[h_{pd}(n)]$.

- For each segment of the zero-padded input sequence, compute its FFT: $X_i(k) = \text{FFT}[x_{pd,i}(n)]$, where $x_{pd,i}(n)$ represents the i-th segment.

- Multiply the frequency-domain representations: $Y_i(k) = X_i(k) \cdot H(k)$.

## 4. Inverse Transform:

- Apply the inverse FFT to each $Y_i(k)$ to obtain the time-domain sequences: $y_i(n) = \text{IFFT}[Y_i(k)]$.

## 5. Overlap and Accumulate:

- Overlap the last $M-1$ points of $y_i(n)$ with the first $M-1$ points of the next segment. 

- Accumulate the overlapping portions to obtain the final output sequence.

## 6. Repeat for All Segments:

- Repeat the above steps for all segments of the input sequence.

The result is the output sequence $y(n)$, which represents the convolution of $x(n)$ with the FIR filter $h(n)$.
