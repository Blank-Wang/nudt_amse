function MP3_to_STFT(path,s,Fs,plot_num)
     window = 256;
     laps = 128;
     h_fig=figure;
    spectrogram(s,window,laps,1024,Fs);
    xlim([0 8000]);
    set(h_fig,'visible','off');
    set(gca,'Position',[0,0,1,1]);
    set(gcf,'PaperUnits','inches','PaperPosition',[0,0,256.0/150.0,256.0/150.0]);
    saveas(h_fig,[path,'\',plot_num],'tiff');
    close(h_fig);
    
