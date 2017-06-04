function FMatrix=CalcFFT(num,s,Fs,Tf,Ts,fn)
%Syntax:        M=CalcMfcc(num,s, Fs);| M=CalcMfcc(15,y,8000)
%Fs:            Sampling freequency
%Computes and returns the mfcc coefficients for a speech signal s
%where num is the required number of MFCC coefficients. It utilises the 
%function 'melbankm' from the toolbox Voicebox by Mike Brooks copyright(c)
%1997 (GNU General Public License), freely available on the internet, 
%to implement the triangular mel filter bank
n=256;              %Number of FFT points 512| 256
%Tf=0.025;           %Frame duration in seconds 0.025| 0.025
N=floor(Fs*Tf);            %Number of samples per frame
% fn=40;              %Number of mel filters 24 | 40
l=length(s);        %total number of samples in speech
%Ts=0.01;            %Frame step in seconds
FrameStep=floor(Fs*Ts);    %Frame step in samples

noFrames=floor(l/FrameStep);    %Maximum no of frames in speech sample
FMatrix=zeros(noFrames-2, num); %Matrix to hold cepstral coefficients
lifter=1:num;                   %Lifter vector index
lifter=1+floor((num)/2)*(sin(lifter*pi/num));%raised sine lifter version

if mean(abs(s)) > 0.01
    s=s/max(s);                     %Normalises to compensate for mic vol differences
end

%Segment the signal into overlapping frames and compute MFCC coefficients
for i=1:noFrames-ceil(N/FrameStep)
    frame=s((i-1)*FrameStep+1:(i-1)*FrameStep+N);  %Holds individual frames
    Ce1=sum(frame.^2);          %Frame energy
    Ce2=max(Ce1,2e-22);         %floors to 2 X 10 raised to power -22, kick out the small values
    Ce=log(Ce2);
    F=frame.*hamming(N);        %multiplies each frame with hamming window
    FFTo=fft(F,N);              %computes the fft
    melf=melbankm(fn,n,Fs);     %creates 24 filter, mel filter bank
    halfn=1+floor(n/2);    
    spectr1=log10(melf*abs(FFTo(1:halfn)).^2);%result is mel-scale filtered
    spectr=max(spectr1(:),1e-22);
    c=dct(spectr);              %obtains DCT, changes to cepstral domain
    c(1)=Ce;                    %replaces first coefficient
    coeffs=c(1:num);            %retains first num coefficients
    ncoeffs=coeffs.*lifter';    %Multiplies coefficients by lifter value
    FMatrix(i, :)=ncoeffs';     %assigns mfcc coeffs to succesive rows 
end

