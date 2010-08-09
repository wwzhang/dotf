#pragma rtGlobals=1		// Use modern global access method.
Function ChangeName()
	Wave 'Event Number-0000', 'Current-1-0001 (A)', 'Rise-Time-0002 (s)' , 'Half-Width-0003 (s)', 'Inter-Event Intervals-0004 (s)'
	rename 'Event Number-0000', Eve_Num;
	rename 'Current-1-0001 (A)', Amp;
	rename 'Rise-Time-0002 (s)', Rise;
	rename 'Half-Width-0003 (s)', Half_Width;
	rename 'Inter-Event Intervals-0004 (s)', isi;
	Wave Eve_Num, Amp, Rise, Half_Width, isi;
	Amp = Amp*1E12; //from A to pA
	Rise = Rise *1E3;  //from s to ms
	Half_Width = Half_Width * 1E3;   //from s to ms
	//Frequency
	Duplicate isi Inst_Freq; Inst_Freq = 1/isi;
End

Function MiniAverage()
	Make/O/N=1 eve_nums; 
	Make/O/N=1 amp_ave, amp_SD, amp_Ci1, amp_Ci2;
	Make/O/N=1 rise_ave, rise_SD, rise_Ci1, rise_Ci2;
	Make/O/N=1 half_ave, half_SD, half_Ci1, half_Ci2;
	Make/O/N=1 freq_ave, freq_SD, freq_Ci1, freq_Ci2;
	Make/O/N=1 all_freq;
	
	Wave Eve_Num, Amp, Rise, Half_Width, isi, Inst_Freq;
	
	WaveStats/W Eve_Num; Duplicate M_WaveStats, temp_stats;
	eve_nums = temp_stats[12]; killwaves temp_stats;
	
	WaveStats/W Amp;  Duplicate M_WaveStats, temp_stats;
	
	amp_ave = temp_stats[3]; amp_SD = temp_stats[4]; amp_Ci1 = temp_stats[24]; amp_Ci2 = temp_stats[25]; killwaves temp_stats;
	
	WaveStats/W Rise;  Duplicate M_WaveStats, temp_stats;
	rise_ave = temp_stats[3]; rise_SD = temp_stats[4]; rise_Ci1 = temp_stats[24]; rise_Ci2 = temp_stats[25]; killwaves temp_stats;
	
	WaveStats/W Half_Width; Duplicate M_WaveStats, temp_stats;
	half_ave = temp_stats[3]; half_SD = temp_stats[4]; half_Ci1 = temp_stats[24]; half_Ci2 = temp_stats[25]; killwaves temp_stats;
	
	WaveStats/W Inst_Freq; Duplicate M_WaveStats, temp_stats;
	freq_ave = temp_stats[3]; freq_SD = temp_stats[4]; freq_Ci1 = temp_stats[24]; freq_Ci2 = temp_stats[25]; killwaves temp_stats;
	
       all_freq = eve_nums / 120 //2min sample analysis
       
       edit eve_nums, amp_ave, amp_SD, amp_Ci1, amp_Ci2, rise_ave, rise_SD, rise_Ci1, rise_Ci2, half_ave, half_SD, half_Ci1, half_Ci2, freq_ave, freq_SD, freq_Ci1, freq_Ci2, all_freq as "Averages"; 
End

Function Histo_cal_all()
	//cumulative plot of amp
	Make/N=200/O W_Hist_amp;DelayUpdate;
	Histogram/CUM/B={0,2,200} Amp_all,W_Hist_amp;
	//cumulative plot of isi
	Make/N=400/O W_Hist_isi;DelayUpdate;
	Histogram/CUM/B={0,0.02,400} isi_all,W_Hist_isi;
	duplicate W_Hist_amp, w_per_amp; w_per_amp = w_per_amp/wavemax(W_Hist_amp);
	duplicate W_Hist_isi, w_per_isi; w_per_isi = w_per_isi/wavemax(W_Hist_isi);
	SetScale/P x 0, 2,  w_per_amp; display w_per_amp;
	SetScale/P x 0, 0.02, w_per_isi; display w_per_isi;
End	

Function Histo_per()
	//cumulative plot of amp
	Make/N=200/O W_Hist_amp;DelayUpdate;
	Histogram/CUM/B={0,2,200} Amp,W_Hist_amp;
	//cumulative plot of isi
	Make/N=400/O W_Hist_isi;DelayUpdate;
	Histogram/CUM/B={0,0.02,400} isi,W_Hist_isi;
	duplicate W_Hist_amp, w_per_amp; w_per_amp = w_per_amp/wavemax(W_Hist_amp);
	duplicate W_Hist_isi, w_per_isi; w_per_isi = w_per_isi/wavemax(W_Hist_isi);
	SetScale/P x 0, 2,  w_per_amp; 
	display/N=cumu_amp w_per_amp; Format_figs(); cumu_amp();
	SetScale/P x 0, 0.02, w_per_isi; 
	display/N=cumu_isi w_per_isi; Format_figs(); cumu_isi();
End

Function Format_figs()
	ModifyGraph fSize=18,axThick=3,font="Arial Bold", lsize=2; DelayUpdate;
	ModifyGraph width=432,height=288,gFont="Arial Bold",gfSize=18,gmSize=3; DelayUpdate;
	ModifyGraph mode=2,lsize=3;
	ModifyGraph lblMargin(left)=10;
End	

Function cumu_amp() 
	SetAxis left 0,1
	ModifyGraph manTick(bottom)={0,100,0,0},manMinor(bottom)={1,0};DelayUpdate;
	SetAxis bottom 0,300;
	Label bottom "Amplitude (pA)";
	ModifyGraph manTick(left)={0,0.5,0,1},manMinor(left)={1,0};
	Label left "Cumulative Probability"
End	

Function cumu_isi()
	SetAxis left 0,1
	ModifyGraph manTick(left)={0,0.5,0,1},manMinor(left)={1,0};
	Label left "Cumulative Probability";
	ModifyGraph manTick(bottom)={0,0.4,0,1},manMinor(bottom)={1,0};DelayUpdate;
	SetAxis bottom 0,1.2;
	Label bottom "Inter-Event Interval(s)";
End	

Function formatgroupplot()
	ModifyGraph fSize=18,axThick=3,font="Arial Bold", lsize=2; DelayUpdate;
	ModifyGraph width=144,height=288,gFont="Arial Bold",gfSize=18,gmSize=3; DelayUpdate;
	ModifyGraph mode=3,msize=5, mrkThick=1; DelayUpdate;
	ModifyGraph tick(bottom)=3,noLabel(bottom)=2; SetAxis bottom 0,3;
	
End

Function displaymini()
	Display 'Current-1-0001 (A)'[0,299] vs 'Time-0000 (s)';

End

Function Fitmini()
	CurveFit/M=2/W=0 exp, 'Current-1-0001 (A)'[pcsr(A),pcsr(B)]/X='Time-0000 (s)'[pcsr(A),pcsr(B)]/D;
	Wave W_coef;
	Print "Decay is", 1000/W_coef[2];
End

Function AP()
	Wave 'Event Number-0000', 'Rise-Time-0001 (s)' , 'Half-Width-0002 (s)''Inter-Event Intervals-0003 (s)';
	rename 'Event Number-0000', Eve_Num;
	rename 'Rise-Time-0001 (s)', Rise;
	rename 'Half-Width-0002 (s)', Half_Width;
	rename 'Inter-Event Intervals-0003 (s)', isi;
	Wave Eve_Num, Amp, Rise, Half_Width, isi;
	Duplicate isi Inst_Freq; Inst_Freq = 1/isi;
	Rise = Rise *1E3;  //from s to ms
	Half_Width = Half_Width * 1E3;   //from s to ms
	
	Make/O/N=1 eve_nums; 
	Make/O/N=1 rise_ave, rise_SD, rise_Ci1, rise_Ci2;
	Make/O/N=1 half_ave, half_SD, half_Ci1, half_Ci2;
	Make/O/N=1 freq_ave, freq_SD, freq_Ci1, freq_Ci2;
	Make/O/N=1 all_freq;
//Stats
	WaveStats/W Rise;  Duplicate M_WaveStats, temp_stats;
	rise_ave = temp_stats[3]; rise_SD = temp_stats[4]; rise_Ci1 = temp_stats[24]; rise_Ci2 = temp_stats[25]; killwaves temp_stats;
	
	WaveStats/W Half_Width; Duplicate M_WaveStats, temp_stats;
	half_ave = temp_stats[3]; half_SD = temp_stats[4]; half_Ci1 = temp_stats[24]; half_Ci2 = temp_stats[25]; killwaves temp_stats;

	WaveStats/W Eve_Num; Duplicate M_WaveStats, temp_stats;
	eve_nums = temp_stats[12]; killwaves temp_stats;
	WaveStats/W Inst_Freq; Duplicate M_WaveStats, temp_stats;
	freq_ave = temp_stats[3]; freq_SD = temp_stats[4]; freq_Ci1 = temp_stats[24]; freq_Ci2 = temp_stats[25]; killwaves temp_stats
       
       all_freq = eve_nums / 30 //30S sample analysis
       edit eve_nums,  rise_ave, rise_SD, rise_Ci1, rise_Ci2, half_ave, half_SD, half_Ci1, half_Ci2, freq_ave, freq_SD, freq_Ci1, freq_Ci2, all_freq as "Averages"; 

	//cumulative plot of isi
	Make/N=400/O W_Hist_isi;DelayUpdate;
	Histogram/CUM/B={0,0.02,400} isi,W_Hist_isi;
	duplicate W_Hist_isi, w_per_isi; w_per_isi = w_per_isi/wavemax(W_Hist_isi);
	SetScale/P x 0, 0.02, w_per_isi; 
	display/W=(1,1,0,0)/N=cumu_isi w_per_isi; Format_figs(); ModifyGraph mode=0,lsize=2; cumu_isi();
	ModifyGraph manTick(bottom)={0,0.05,0,2},manMinor(bottom)={1,0};DelayUpdate;
	SetAxis bottom 0,0.25;
End

Menu "Macros"
//	Submenu Mini
//	End
	"ChangeName", ChangeName();
	"MiniAverage", MiniAverage();
	"Cumulative distribution individual", Histo_per();
	"Cumulative Plots All Data", Histo_cal_all();
	"Format Figues", Format_figs();
	"Format Groups Plots", formatgroupplot();
	"AP plot", AP();
	Submenu "Fitting"	
		"Display mini", displaymini();
		"Fit Mini-Events", fitmini();
	End
End