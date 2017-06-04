function [FMatrix,f]=CalcFFT(s,Fs,Tf,Ts)
%
%Fs:            Sampling freequency
% n=256;              %Number of FFT points 512| 256
%Tf=0.025;           %Frame duration in seconds 0.025| 0.025
N=floor(Fs*Tf);            %Number of samples per frame
l=length(s);        %total number of samples in speech
FrameStep=floor(Fs*Ts);    %Frame step in samples
noFrames=floor(l/FrameStep);    %Maximum no of frames in speech sample
FMatrix=zeros(noFrames-2, N/2+1); %Matrix to hold amplicate
f = Fs/2*linspace(0,1,N/2+1);

for i=1:noFrames-ceil(N/FrameStep)
    frame=s((i-1)*FrameStep+1:(i-1)*FrameStep+N);  %每段数据为N个点，相邻两端数据起点间隔Framestep
    F=frame.*hamming(N);                                         %multiplies each frame with hamming window
    FFTo=fft(F,N);                                                       %computes the fft
    oup=2*abs(FFTo(1:N/2+1));
    FMatrix(i, :)=oup';
end

