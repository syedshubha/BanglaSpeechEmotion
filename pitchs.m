function p=pitchs(Sig, fs)

frame_duration=.025;
frame_length=round(fs*frame_duration);
f_number=floor(length(Sig)/frame_length);
temp=0;
frames=zeros(f_number,frame_length);

for i=1:f_number
    frames(i,:)=(Sig((temp+1):(temp+frame_length)));
    temp=temp+frame_length;
    [x,lags]=xcorr(frames(i,:));
    [first_peak_v, first_peak_l]=max(x);
    first_peak=frame_length+1;
    x(first_peak_l-100:first_peak_l+100)=0;
    [second_peak_v, second_peak_l]=max(x);
    pitchs(i)=1/(abs(second_peak_l-first_peak_l)/fs);
end

p=pitchs;
