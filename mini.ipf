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

Function All_para()
	Make/O/N=1 eve_nums; 
	//Make/O/N=1 amp_ave, amp_SD, amp_Ci1, amp_Ci2;
	Make/O/N=1 amp_ave, amp_SD, amp_SE; 
	//Make/O/N=1 rise_ave, rise_SD, rise_Ci1, rise_Ci2;
	Make/O/N=1 rise_ave, rise_SD, rise_SE;
	//Make/O/N=1 half_ave, half_SD, half_Ci1, half_Ci2;
	Make/O/N=1 half_ave, half_SD, half_SE;
	//Make/O/N=1 freq_ave, freq_SD, freq_Ci1, freq_Ci2;
	Make/O/N=1 freq_ave, freq_SD, freq_SE;
	Make/O/N=1 all_freq;

	edit eve_nums, amp_ave, amp_SD, amp_SE, rise_ave, rise_SD, rise_SE, half_ave, half_SD, half_SE, freq_ave, freq_SD, freq_SE, all_freq as "Averages"; 
END

Function name_mini_paras()
	String group
	Prompt group, "Enter genotype group name: " // Set prompt for x param
	DoPrompt "Enter genotype", group
	if (V_Flag)
		return -1	// User canceled 
	endif
	Make/O/N=1 $(group+"_eve_nums") /wave=eve_nums; 
	//Make/O/N=1 amp_ave, amp_SD, amp_Ci1, amp_Ci2;
	Make/O/N=1 $(group+"_amp_ave") /wave=amp_ave; 
	//Make/O/N=1 $(group+"_amp_SD") /wave=amp_SD;
	Make/O/N=1 $(group+"_amp_SE") /wave=amp_SE; 
	//Make/O/N=1 rise_ave, rise_SD, rise_Ci1, rise_Ci2;
	Make/O/N=1 $(group+"_rise_ave") /wave=rise_ave; 
	//Make/O/N=1 $(group+"_rise_SD") /wave=rise_SD; 
	Make/O/N=1 $(group+"_rise_SE") /wave=rise_SE;
	//Make/O/N=1 half_ave, half_SD, half_Ci1, half_Ci2;
	Make/O/N=1 $(group+"_half_ave") /wave=half_ave; 
	//Make/O/N=1 $(group+"_half_SD") /wave=half_SD; 
	Make/O/N=1 $(group+"_half_SE") /wave=half_SE;
	//Make/O/N=1 freq_ave, freq_SD, freq_Ci1, freq_Ci2;
	Make/O/N=1 $(group+"_freq_ave") /wave=freq_ave; 
	//Make/O/N=1 $(group+"_freq_SD") /wave=freq_SD;
	Make/O/N=1 $(group+"_freq_SE") /wave=freq_SE;
	Make/O/N=1 $(group+"_all_freq") /wave=all_freq;
	Make/O/N=1 $(group+"_decay") /wave=decay;
	edit $(group+"_eve_nums"), $(group+"_amp_ave"), $(group+"_amp_SE"), $(group+"_rise_ave"), $(group+"_rise_SE"), $(group+"_half_ave"), $(group+"_half_SE"), $(group+"_freq_ave"), $(group+"_freq_SE"), $(group+"_all_freq"), $(group+"_decay") as "$group"
END	

Function name_evoked_paras()
	String group
	Prompt group, "Enter genotype group name: " // Set prompt for x param
	DoPrompt "Enter genotype", group
	if (V_Flag)
		return -1	// User canceled 
	endif
	Make/O/N=1 $(group+"_amp_ave") /wave=amp_ave;
	Make/O/N=1 $(group+"_decay") /wave=decay;
	Make/O/N=1 $(group+"_PP50") /wave=PP50;
	Make/O/N=1 $(group+"_PP100") /wave=PP100;
	Make/O/N=1 $(group+"_PP200") /wave=PP200;
	Make/O/N=1 $(group+"_PP500") /wave=PP500;
	edit $(group+"_amp_ave"), $(group+"_decay"), $(group+"_PP50"), $(group+"_PP100"), $(group+"_PP200"), $(group+"_PP500")
END	

Function MiniAverage()	
	Wave Eve_Num, Amp, Rise, Half_Width, isi, Inst_Freq;
	All_para()
	Wave eve_nums, amp_ave, amp_SE, rise_ave, rise_SE, half_ave, half_SE, freq_ave, freq_SE, all_freq
	
	WaveStats/W/Q Eve_Num; Duplicate M_WaveStats, temp_stats;
	eve_nums = temp_stats[12]; killwaves temp_stats;
	
	WaveStats/W/Q Amp;  Duplicate M_WaveStats, temp_stats;
	amp_ave = temp_stats[3]; amp_SE = temp_stats[4]/sqrt(eve_num); //amp_Ci1 = temp_stats[24]; amp_Ci2 = temp_stats[25]; 
	killwaves temp_stats;
	
	WaveStats/W/Q Rise;  Duplicate M_WaveStats, temp_stats;
	rise_ave = temp_stats[3]; rise_SE = temp_stats[4]/sqrt(eve_num); //rise_Ci1 = temp_stats[24]; rise_Ci2 = temp_stats[25]; 
	killwaves temp_stats;
	
	WaveStats/W/Q Half_Width; Duplicate M_WaveStats, temp_stats;
	half_ave = temp_stats[3]; half_SE = temp_stats[4]/sqrt(eve_num); //half_Ci1 = temp_stats[24]; half_Ci2 = temp_stats[25]; 
	killwaves temp_stats;
	
	WaveStats/W/Q Inst_Freq; Duplicate M_WaveStats, temp_stats;
	freq_ave = temp_stats[3]; freq_SE = temp_stats[4]/sqrt(eve_num); //freq_Ci1 = temp_stats[24]; freq_Ci2 = temp_stats[25]; 
	killwaves temp_stats;
	
  all_freq = eve_nums / 120 //2min sample analysis
	//Wave amp_SD, rise_SD, half_SD,  freq_SD,
End

Function amp_histo_plot()
	Make/N=200/O Amp_Histo;DelayUpdate;
	Histogram/B={0,2,200} Amp,Amp_Histo;
	display Amp_Histo; DelayUpdate; ModifyGraph mode=6;
End

Function half_histo_plot()
	Make/N=100/O half_Histo;DelayUpdate;
	Histogram/B={0,0.1,100} half_width,half_Histo;
	display half_Histo; DelayUpdate; ModifyGraph mode=6;
End


Function Histo_cal_all()
	//cumulative plot of amp
	Make/N=200/O W_Hist_amp;DelayUpdate;
	Histogram/CUM/B={0,2,200} Amp_all,W_Hist_amp; //this is 2pA bin, 2*200 pA max
	//cumulative plot of isi
	Make/N=400/O W_Hist_isi;DelayUpdate;
	Histogram/CUM/B={0,0.02,400} isi_all,W_Hist_isi;
	duplicate W_Hist_amp, w_per_amp; w_per_amp = w_per_amp/wavemax(W_Hist_amp);
	duplicate W_Hist_isi, w_per_isi; w_per_isi = w_per_isi/wavemax(W_Hist_isi);
	SetScale/P x 0, 2,  w_per_amp; display /N=cumu_amp w_per_amp;
	ModifyGraph mode=0,lsize=1;
	ModifyGraph lblMargin(left)=10;
	ModifyGraph fSize=14,axThick=3,font="Arial Bold"; DelayUpdate;
	ModifyGraph gFont="Arial Bold",gfSize=14,gmSize=3; DelayUpdate;
	SetAxis left 0,1; DelayUpdate;
	ModifyGraph manTick(left)={0,0.5,0,1},manMinor(left)={1,0}; DelayUpdate;
	Label left "Cumulative Probability"; DelayUpdate;
	SetAxis bottom 0,250; DelayUpdate;
	ModifyGraph manTick(bottom)={0,50,0,0},manMinor(bottom)={1,0}; DelayUpdate;
	label bottom "Amplitude (pA)"; DelayUpdate;
	ModifyGraph width=216,height=144
	SetScale/P x 0, 0.02, w_per_isi; display /N=cumu_isi w_per_isi;
	ModifyGraph mode=0,lsize=1;
	ModifyGraph lblMargin(left)=10;
	ModifyGraph fSize=14,axThick=3,font="Arial Bold"; DelayUpdate;
	ModifyGraph gFont="Arial Bold",gfSize=14,gmSize=3; DelayUpdate;
	SetAxis left 0,1; DelayUpdate;
	ModifyGraph manTick(left)={0,0.5,0,1},manMinor(left)={1,0}; DelayUpdate;
	Label left "Cumulative Probability"; DelayUpdate;
	SetAxis bottom 0,2.5; DelayUpdate;
	ModifyGraph manTick(bottom)={0,0.5,0,1},manMinor(bottom)={1,0}; DelayUpdate;
	Label bottom "Inter-Event Interval (s)"; DelayUpdate;
	ModifyGraph width=216,height=144
End	

Function Histo_per()
	//cumulative plot of amp
	Make/N=400/O W_Hist_amp;DelayUpdate;
	Histogram/CUM/B={0,1,400} Amp,W_Hist_amp;
	//cumulative plot of isi
	Make/N=400/O W_Hist_isi;DelayUpdate;
	Histogram/CUM/B={0,0.01,400} isi,W_Hist_isi;
	duplicate W_Hist_amp, w_per_amp; w_per_amp = w_per_amp/wavemax(W_Hist_amp);
	duplicate W_Hist_isi, w_per_isi; w_per_isi = w_per_isi/wavemax(W_Hist_isi);
	SetScale/P x 0, 1,  w_per_amp; 
	display/N=cumu_amp w_per_amp; Format_figs(); cumu_amp();
	SetScale/P x 0, 0.01, w_per_isi; 
	display/N=cumu_isi w_per_isi; Format_figs(); cumu_isi();
End

Function Histo_per_mini()
	//cumulative plot of amp
	Make/O/N=400 W_Hist_amp;DelayUpdate;
	Histogram/CUM/B={0,1,400} Amp,W_Hist_amp;
	//cumulative plot of isi
	Make/O/N=400 W_Hist_isi;DelayUpdate;
	Histogram/CUM/B={0,0.01,400} isi,W_Hist_isi;
	duplicate W_Hist_amp, w_per_amp; w_per_amp = w_per_amp/wavemax(W_Hist_amp);
	duplicate W_Hist_isi, w_per_isi; w_per_isi = w_per_isi/wavemax(W_Hist_isi);
	SetScale/P x 0, 1,  w_per_amp; 
	display/N=cumu_amp w_per_amp; Format_figs(); cumu_amp(); ModifyGraph manTick(bottom)={0,50,0,0},manMinor(bottom)={1,0}; SetAxis bottom 0,200; ModifyGraph fSize=14,axThick=3,font="Arial Bold", lsize=2; DelayUpdate;
	ModifyGraph gFont="Arial Bold",gfSize=14,gmSize=3; DelayUpdate; Format_figs()
	SetScale/P x 0, 0.01, w_per_isi; 
	display/N=cumu_isi w_per_isi; Format_figs(); cumu_isi(); SetAxis bottom 0,1.0; ModifyGraph manTick(bottom)={0,0.25,0,1},manMinor(bottom)={1,0}; ModifyGraph fSize=14,axThick=3,font="Arial Bold", lsize=2; DelayUpdate;
	ModifyGraph gFont="Arial Bold",gfSize=14,gmSize=3; DelayUpdate; Format_figs()
	edit w_per_amp, w_per_isi as "Cumu_Percent";
End

Function cumu_amp() 
	SetAxis left 0,1
	ModifyGraph manTick(bottom)={0,100,0,0},manMinor(bottom)={1,0};DelayUpdate;
	ModifyGraph mode=0,lsize=1;
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
	ModifyGraph mode=0,lsize=1;
	SetAxis bottom 0,1.2;
	Label bottom "Inter-Event Interval(s)";
End	

Function pool_mini_cumu()
	//cumulative plot of amp
	Make/O/N=400 W_Hist_amp;DelayUpdate;
	Histogram/CUM/B={0,1,400} pool_amp,W_Hist_amp;
	//cumulative plot of isi
	Make/O/N=400 W_Hist_isi;DelayUpdate;
	Histogram/CUM/B={0,0.01,400} pool_isi,W_Hist_isi;
	duplicate W_Hist_amp, w_per_amp; w_per_amp = w_per_amp/wavemax(W_Hist_amp);
	duplicate W_Hist_isi, w_per_isi; w_per_isi = w_per_isi/wavemax(W_Hist_isi);
	SetScale/P x 0, 1,  w_per_amp; 
	display/N=cumu_amp w_per_amp as "pool_amp"; Format_figs(); cumu_amp(); ModifyGraph manTick(bottom)={0,50,0,0},manMinor(bottom)={1,0}; SetAxis bottom 0,200; ModifyGraph fSize=14,axThick=3,font="Arial Bold", lsize=2; DelayUpdate;
	ModifyGraph gFont="Arial Bold",gfSize=14,gmSize=3; DelayUpdate; Format_figs(); ModifyGraph mode=0,lsize=1
	SetScale/P x 0, 0.01, w_per_isi; 
	display/N=cumu_isi w_per_isi as "pool_isi"; Format_figs(); cumu_isi(); SetAxis bottom 0,1.0; ModifyGraph manTick(bottom)={0,0.25,0,1},manMinor(bottom)={1,0}; ModifyGraph fSize=14,axThick=3,font="Arial Bold", lsize=2; DelayUpdate;
	ModifyGraph gFont="Arial Bold",gfSize=14,gmSize=3; DelayUpdate; Format_figs(); ModifyGraph mode=0,lsize=1
	edit w_per_amp, w_per_isi as "Cumu_Percent";
End

Function displaymini()
	Wave 'Current-1-0001 (A)', 'Time-0000 (s)';
	'Current-1-0001 (A)' = 'Current-1-0001 (A)' * 1E12; //from A to pA
	'Time-0000 (s)' = 'Time-0000 (s)' *1E3
	Display 'Current-1-0001 (A)' vs 'Time-0000 (s)';
	Label left "Amplitude (pA)"; DelayUpdate; Label bottom "Time (ms)"
	//showinfo;
	
	Wavestats/W 'Current-1-0001 (A)';
	Wave M_WaveStats;
	Variable cursor_A_pos; 

//Pop-up box	
	Variable polarity
	Prompt polarity,"Peak Polarity",popup,"Positive;Negative"
	DoPrompt "Peak Polarity",polarity 
		if( V_Flag )
			return 0	// user canceled 
		endif
		if (polarity == 1) 
			cursor_A_pos = M_WaveStats[17];
		elseif(polarity == 2) 
			cursor_A_pos = M_WaveStats[13];
		endif
//Pop-up box	
	killwaves M_WaveStats; 
	Cursor/P A, 'Current-1-0001 (A)', cursor_A_pos;
	Cursor/P B, 'Current-1-0001 (A)',numpnts('Current-1-0001 (A)')-1
	
	//showtools/A arrow;
	CurveFit/M=2/W=0 exp, 'Current-1-0001 (A)'[pcsr(A),pcsr(B)]/X='Time-0000 (s)'[pcsr(A),pcsr(B)]/D;
	ModifyGraph rgb('fit_Current-1-0001 (A)')=(1,16019,65535)
	Wave W_coef;
	Print "Decay is", 1/W_coef[2];

End

Function Fitmini()
	CurveFit/M=2/W=0 exp, 'Current-1-0001 (A)'[pcsr(A),pcsr(B)]/X='Time-0000 (s)'[pcsr(A),pcsr(B)]/D;
	Wave W_coef;
	Print "Decay is", 1/W_coef[2];
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

Function AP_stats()
	Make/O/N=1 eve_nums; 
	Make/O/N=1 rise_ave, rise_SD, rise_Ci1, rise_Ci2;
	Make/O/N=1 half_ave, half_SD, half_Ci1, half_Ci2;
	Make/O/N=1 freq_ave, freq_SD, freq_Ci1, freq_Ci2;
	Make/O/N=1 all_freq;
	make/T/N=1 fn;
	
	edit eve_nums, rise_ave, rise_SD, rise_Ci1, rise_Ci2, half_ave, half_SD, half_Ci1, half_Ci2, freq_ave, freq_SD, freq_Ci1, freq_Ci2, all_freq, fn as "averages";
End

/////////////////////////////////////////////Figures//////////////////////////////////////////////////
Function plotting_re()
	Variable min_l=0, max_l=1, interval_l=0.1
	Variable min_b=0, max_b=1, interval_b=0.1
	String label_l="Left", label_b="Bottom"
	String anno_1="", anno_2=""
	
	Prompt min_l, "Left min";
	Prompt max_l, "Left max";
 	Prompt interval_l, "Left Interval";
 	Prompt label_l, "Left Label";
 	
 	Prompt min_b, "Bottom min";
	Prompt max_b, "Bottom max";
 	Prompt interval_b, "Bottom Interval";
 	Prompt label_b, "Bottom Label";
 	Prompt anno_1, "Annotation";
 	Prompt anno_2, "Annotation";
	DoPrompt "Modify Axis", min_l, max_l, interval_l, label_l, min_b, max_b, interval_b, label_b, anno_1, anno_2
	    
	if (V_Flag)
		return -1	// User canceled 
	endif
	ModifyGraph fSize=14,axThick=3,font="Arial Bold", lsize=2; DelayUpdate;
	ModifyGraph gFont="Arial Bold",gfSize=14,gmSize=3; DelayUpdate;

	SetAxis left min_l,max_l; DelayUpdate;
	ModifyGraph manTick(left)={0,interval_l,0,1},manMinor(left)={1,0}; DelayUpdate;
	Label left label_l; DelayUpdate;
	SetAxis bottom min_b,max_b; DelayUpdate;
	ModifyGraph manTick(bottom)={0,interval_b,0,1},manMinor(bottom)={1,0}; DelayUpdate;
	Label bottom label_b; DelayUpdate;
	TextBox/B=1/A=LB/F=0 anno_1; DelayUpdate;
	TextBox/B=1/A=RB/F=0 anno_2; 
	
	Variable GraphType=2
	Prompt GraphType,"Graph Type",popup,"group;normal"
	DoPrompt "Graph Type",GraphType
	if (GraphType == 1)
		formatgroupplot()
	elseif (GraphType == 2)
		Format_figs()
	endif	
END	

Function Format_figs()
	ModifyGraph mode=2,lsize=3;
	ModifyGraph lblMargin(left)=10;
	//ModifyGraph height={Aspect, 0.75}
	ModifyGraph width=216,height=144;
End	

Function formatgroupplot()
	ModifyGraph mode=3,msize=5, mrkThick=1; DelayUpdate;
	ModifyGraph tick(bottom)=3,noLabel(bottom)=2; SetAxis bottom 0,3;
  ModifyGraph width=72,height=144; //height={Aspect, 2}	
End

Function category_plot()
  ModifyGraph tick=3,fSize=36,font="Arial Bold", axThick=3,hbFill=0,rgb=(0,0,0), noLabel(bottom)=2, lsize=3,  width=100,height=300
  
END

//////Figure styles/////////////////////////////////////////////////////////
Function Style_group() : GraphStyle
	PauseUpdate; Silent 1		// modifying window...
	ModifyGraph/Z gFont="Arial Bold",gfSize=14,gmSize=3,width=72,height=144
	ModifyGraph/Z mode=3
	ModifyGraph/Z marker[0]=8,marker[1]=6
	ModifyGraph/Z lSize=2
	ModifyGraph/Z rgb[1]=(0,0,65535)
	ModifyGraph/Z msize=5
	ModifyGraph/Z mrkThick=1
	ModifyGraph/Z tick(bottom)=3
	ModifyGraph/Z font="Arial Bold"
	ModifyGraph/Z noLabel(bottom)=1
	ModifyGraph/Z fSize=14
	ModifyGraph/Z standoff(bottom)=0
	ModifyGraph/Z axThick=3
	SetAxis/Z bottom 0.9,2.1
End
Function style_cumu_isi()
	Silent 1	
	ModifyGraph mode=0,lsize=1, lStyle[1]=8; 
	ModifyGraph/Z rgb[1]=(0,0,65535)
	ModifyGraph lblMargin(left)=10;
	ModifyGraph fSize=14,axThick=3,font="Arial Bold"; DelayUpdate;
	ModifyGraph gFont="Arial Bold",gfSize=14,gmSize=3; DelayUpdate;
	SetAxis left 0,1; DelayUpdate;
	ModifyGraph manTick(left)={0,0.5,0,1},manMinor(left)={1,0}; DelayUpdate;
	Label left "Cumulative Probability"; DelayUpdate;
	SetAxis bottom 0,2.5; DelayUpdate;
	ModifyGraph manTick(bottom)={0,0.5,0,1},manMinor(bottom)={1,0}; DelayUpdate;
	Label bottom "Inter-Event Interval (s)"; DelayUpdate;
	ModifyGraph width=216,height=144
End
Function Style_cumu_amp() 
	Silent 1	
	ModifyGraph mode=0,lsize=1, lStyle[1]=8; 
	ModifyGraph/Z rgb[1]=(0,0,65535)
	ModifyGraph lblMargin(left)=10;
	ModifyGraph fSize=14,axThick=3,font="Arial Bold"; DelayUpdate;
	ModifyGraph gFont="Arial Bold",gfSize=14,gmSize=3; DelayUpdate;
	SetAxis left 0,1; DelayUpdate;
	ModifyGraph manTick(left)={0,0.5,0,1},manMinor(left)={1,0}; DelayUpdate;
	Label left "Cumulative Probability"; DelayUpdate;
	SetAxis bottom 0,250; DelayUpdate;
	ModifyGraph manTick(bottom)={0,50,0,0},manMinor(bottom)={1,0}; DelayUpdate;
	label bottom "Amplitude (pA)"; DelayUpdate;
	ModifyGraph width=216,height=144
END
//////EOF //////Figure styles/////////////////////////////////////////////////////////

/////////////////////////////////////////////END of Figures//////////////////////////////////////////////////

////////////Miniature menu///////////////// 
////////////////////////////////////////////Decay of minis///////////////////////////////////////////////////
function minis_decay()
//IPSC or EPSC
Variable cursorA_po, cursorA_id
Prompt cursorA_po,"Polarity",popup,"Negative;Positive"
DoPrompt "Peak Polarity",cursorA_po
if( V_Flag )
	return 0	// user canceled 
endif
if (cursorA_po == 1) 
	cursorA_id = 13
elseif(cursorA_po == 2) 
	cursorA_id = 17
endif
//END
string matchstring = "Current-1-" + "*"
string matchlist = WaveList(matchstring,";","")
//print matchlist
//display $matchlist
make/o/N=(ItemsInList(matchlist, ";")) decay_minis
String theWave 
Variable index=0
make/o/N= (numpnts('Current-1-0001 (A)')) AveMe_t, AveMe//for avrage waves

	do
		theWave = StringFromList(index, matchlist)
		if (strlen(theWave) == 0) 
			break
		endif 
		if (index == 0)
			Smooth/B 5, $theWave
			Display $theWave vs 'Time-0000 (s)' as "events"
		else
			Smooth/B 5, $theWave
			AppendToGraph $theWave vs 'Time-0000 (s)' 
		endif
		Wavestats/W/Q /R=[80, 160] $theWave; //change the point from different traces
		Wave M_WaveStats;
		Variable cursor_A_pos
		cursor_A_pos = M_WaveStats[cursorA_id];
		killwaves M_WaveStats; 
		Cursor/P A, $theWave, cursor_A_pos;
		Cursor/P B, $theWave,numpnts($theWave)-80
	
	//showtools/A arrow;
		make/O/N=(numpnts('Current-1-0001 (A)')) fit_minis
		Wave fit_minis
		CurveFit/Q/M=2/W=0 exp, $theWave[pcsr(A),pcsr(B)]/X='Time-0000 (s)'[pcsr(A),pcsr(B)]/D=fit_minis;
		//CurveFit/Q/M=2/W=0 exp, $theWave[pcsr(A)]/X='Time-0000 (s)'[pcsr(A)]/D=fit_minis;
		killwaves fit_minis
		Wave W_coef;
	
	//Print "Decay is", 1/W_coef[2]; 
		decay_minis[index] = 1/W_coef[2] * 1000
		cursor/K A; cursor/K B
		Wave AveMe_t = $theWave
		AveMe = AveMe + AveMe_t
		index += 1
	while (1)
	
	ModifyGraph rgb=(34952,34952,34952)
	//HideTools/A
	AveMe = AveMe/index
	AppendToGraph AveMe vs 'Time-0000 (s)'
	
	print index
END
//////////////////////////END of decay of minis///////

#include <Waves Average>
Function ave_traces()
	fWaveAverage(WaveList("Current-1-*", ";", ""), "", 0, 0, "NAve", "")
END

Function PSC_raw_datas()
	//////Auto individual PSC event measurements merged into one file//////
setdatafolder root:
Makelist()
WAVE/T lista=root:lista
variable list_pnts, cumu_index=0, cumu_pnts=0
list_pnts=numpnts(lista)-1
Make/O/N=(list_pnts) eve_nums, amp_ave, amp_SE, rise_ave, rise_SE, half_ave, half_SE, freq_ave, freq_SE, all_freq;
edit eve_nums, amp_ave, amp_SE, rise_ave, rise_SE, half_ave, half_SE, freq_ave, freq_SE, all_freq as "Averages"; 
make/o/n=(200*(list_pnts)) amp_all, isi_all

///copy individual cell data to combined///
variable i
String/G nombre	
i=1
do
	if (i > list_pnts)
	break
	endif
	nombre = lista[i]
	nombre = "root:"+ nombre
	setdatafolder $nombre
	ChangeName()
	
	Wave Eve_Num, Amp, Rise, Half_Width, isi, Inst_Freq;
	//setdatafolder root:;
	eve_nums[i-1]=numpnts(Eve_Num)
	WaveStats/W/Q Amp; wave M_WaveStats; amp_ave[i-1]=M_WaveStats[3]; amp_SE[i-1]=M_wavestats[4]/sqrt(eve_nums[i-1])
	WaveStats/W/Q Rise; rise_ave[i-1]=M_WaveStats[3]; rise_SE[i-1]=M_wavestats[4]/sqrt(eve_nums[i-1])
	WaveStats/W/Q Half_Width; half_ave[i-1]=M_WaveStats[3]; half_SE[i-1]=M_wavestats[4]/sqrt(eve_nums[i-1])
	WaveStats/W/Q Inst_Freq; freq_ave[i-1]=M_WaveStats[3]; freq_SE[i-1]=M_wavestats[4]/sqrt(eve_nums[i-1])
	all_freq[i-1] = numpnts(Eve_num) / 120 //2mins traces
	cumu_index=(i-1)*200
	cumu_pnts=trunc(numpnts(Eve_Num)/100)*100-200-cumu_index
	root:amp_all[cumu_index, cumu_index+199]=Amp[p + cumu_pnts]
	root:isi_all[cumu_index, cumu_index+199]=isi[p + cumu_pnts]
	i+=1
while(1)
setdatafolder root:	

End

Function PSC_quik_figs()
	String group_1="root:folder1", group_2="root:folder2"
	String x_1="m1", x_2="m2"
	Prompt group_1, "Group 1 Name";
	Prompt group_2, "Group 2 Name";
	Prompt x_1, "xwave1";
	Prompt x_2, "xwave2";

	DoPrompt "Generate figures", group_1, x_1, group_2, x_2
	    
		if (V_Flag)
			return -1	// User canceled 
		endif

	setdatafolder $group_1; display /N=amp amp_ave vs root:$x_1;  
	setdatafolder $group_2; appendtograph amp_ave vs root:$x_2; 
	TextBox/B=1/A=LB/F=0 "$group_1"; TextBox/B=1/A=RB/F=0 "$group_2"; Label left "Amplitude (pA)"; Style_group() 

	setdatafolder $group_1; display /N =frequency freq_ave vs root:$x_1; 
	setdatafolder $group_2; appendtograph freq_ave vs root:$x_2; 
	TextBox/B=1/A=LB/F=0 "$group_1"; TextBox/B=1/A=RB/F=0 "$group_2"; Label left "Frequency (Hz)"; Style_group()


	setdatafolder $group_1; display /N=rise rise_ave vs root:$x_1; 
	setdatafolder $group_2; appendtograph rise_ave vs root:$x_2; 
	TextBox/B=1/A=LB/F=0 "$group_1"; TextBox/B=1/A=RB/F=0 "$group_2"; Label left "Rise Time (ms)"; Style_group()

	setdatafolder $group_1; display /N=half_width half_ave vs root:$x_1; 
	setdatafolder $group_2; appendtograph half_ave vs root:$x_2; 
	TextBox/B=1/A=LB/F=0 "$group_1"; TextBox/B=1/A=RB/F=0 "$group_2"; Label left "Half-Width (ms)"; Style_group()
	
	setdatafolder $group_1;
	Make/N=200/O W_Hist_amp;DelayUpdate;
	Histogram/CUM/B={0,2,200} Amp_all,W_Hist_amp; //this is 2pA bin, 2*200 pA max
	//cumulative plot of isi
	Make/N=400/O W_Hist_isi;DelayUpdate;
	Histogram/CUM/B={0,0.02,400} isi_all,W_Hist_isi;
	duplicate W_Hist_amp, w_per_amp; w_per_amp = w_per_amp/wavemax(W_Hist_amp);
	duplicate W_Hist_isi, w_per_isi; w_per_isi = w_per_isi/wavemax(W_Hist_isi);
	SetScale/P x 0, 2,  w_per_amp; 
	SetScale/P x 0, 0.02, w_per_isi;
	display /N=cumu_amp w_per_amp;
	display /N=cumu_isi w_per_isi;
	
	setdatafolder $group_2;
	Make/N=200/O W_Hist_amp;DelayUpdate;
	Histogram/CUM/B={0,2,200} Amp_all,W_Hist_amp; //this is 2pA bin, 2*200 pA max
	//cumulative plot of isi
	Make/N=400/O W_Hist_isi;DelayUpdate;
	Histogram/CUM/B={0,0.02,400} isi_all,W_Hist_isi;
	duplicate W_Hist_amp, w_per_amp; w_per_amp = w_per_amp/wavemax(W_Hist_amp);
	duplicate W_Hist_isi, w_per_isi; w_per_isi = w_per_isi/wavemax(W_Hist_isi);
	SetScale/P x 0, 2,  w_per_amp; 
	SetScale/P x 0, 0.02, w_per_isi;
	appendtograph /W=cumu_amp w_per_amp; style_cumu_amp(); Legend;
	appendtograph /W=cumu_isi w_per_isi; style_cumu_isi(); Legend;
	
	NewLayout /N=fig_PSC 
	AppendLayoutObject /W=fig_PSC /F=0 /T=1 graph cumu_amp
	AppendLayoutObject /W=fig_PSC /F=0 /T=1 graph cumu_isi 
	AppendLayoutObject /W=fig_PSC /F=0 /T=1 graph amp 
	AppendLayoutObject /W=fig_PSC /F=0 /T=1 graph frequency
	AppendLayoutObject /W=fig_PSC /F=0 /T=1 graph rise
	AppendLayoutObject /W=fig_PSC /F=0 /T=1 graph half_width
End


Menu "Miniature"
	"1. Process raw datas after merge", PSC_raw_datas()
	"2. Display Parameter figs", PSC_quik_figs()
	"Decay of Events", minis_decay()
	"Average of traces", ave_traces()
	"half width histo plot", half_histo_plot()
END
///////////END of Miniature Menu//////////////////////////////////////


///////////////////////////////////Utility///////////////////////
function kill_graphs_and_tables()
	string object_name
	variable string_length
	do
		object_name = WinName(0,3)			// name of top graph or table  (see III-441)
		string_length = strlen(object_name)	        // returns "" if no graph/table is present	
		if (string_length == 0)
			break
		endif
		DoWindow /K $object_name			// kill top graph or table; keep going till all done
	while (1)                                                            // loop forever until break		
end

Function MakePanel()
 
	// make a sample panel
	// ... (use your own values here)
 
	NewPanel/W=(10,10,50,50)
 
	// ..
	// strings for popup menu
 
	string theTopFldr = StringFromList(0,ListofRootDataFolders())
	string fldrList = "ListofRootDataFolders()"
 
	// popup menu location, size, and title (change these as you desire)
 
	PopupMenu FolderList,pos={5,13},size={84,20},title="root:"
 
	// popup menu mode, popvalue, value, and procedure
        // do not change these
 
	PopupMenu FolderList, mode=1, popvalue=theTopFldr
        PopupMenu FolderList, value=#fldrList, proc=ChangeFolder
 
	// ..
 
	return 0
end
 
// function to return list of root data folders
 
Function/S ListofRootDataFolders()
 
	string LoFldrs="New;\M1-;", theOne
	variable ic = 0
	do
		theOne = GetIndexedObjName("root:",4,ic)
		if (strlen(theOne)==0)
			break
		endif
		LoFldrs +=  theOne + ";"
		ic += 1
	while(1)
 
	LoFldrs = RemoveFromList("Packages",LoFldrs)
 
	if (strlen(LoFldrs)==0)
		LoFldrs = "-- none --"
	endif
 
	return LoFldrs
end
 
// function to change the data folder
 
Function ChangeFolder(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa
 
	string theFldr = ""
 
	switch( pa.eventCode )
		case 2: // mouse up
	              switch(pa.popNum)
			case 1:		// selection is "New"
			        prompt theFldr, "New folder name?"
				DoPrompt "New Folder", theFldr
				if (V_flag==1)
					break
				endif
				if (strlen(theFldr)==0)
					break
				endif
 
                                // create the new folder (but do not go there)
 
				NewDatafolder/O $theFldr
				PopupMenu FolderList, mode=(ItemsInList(ListofRootDatafolders()))
				break
 
			// put your other cases here for different folders
			// case ....
 
		     endswitch
		     ControlUpdate FolderList
 
                    // put code here to do something when a folder is selected
                    // ....
 
                    // ....
 
		    break
	endswitch
 
	return 0
end

// Window Recreation
Window Folder_Selector() : Panel
	Makelist()
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(434,276,689,553) as "Folder Selector"
	SetDrawLayer UserBack
	DrawText 19,34,"Double click on the folder to set as active"
	ListBox list0,pos={19,52},size={75,132},proc=ListBox_G,frame=0
	ListBox list0,listWave=root:lista,mode= 2,selRow= 0
EndMacro
 
// List Box Control
Function ListBox_G(ctrlName,row,col,event) : ListBoxControl
	String ctrlName
	Variable row
	Variable col
	Variable event	//1=mouse down, 2=up, 3=dbl click, 4=cell select with mouse or keys
					//5=cell select with shift key, 6=begin edit, 7=end
 
	WAVE lista=root:lista
 
if (event == 3)
	String/G nombre			//name of the current Folder
	string cmd
	sprintf cmd," nombre = root:lista[%g]", row
	execute cmd
	if (cmpstr (nombre,"root:") == 0)
		setdatafolder root:
	else
		nombre = "root:"+ nombre
		setdatafolder $nombre
	endif
	print nombre
	setdatafolder $nombre
endif
	return 0
End
 
// Folders List Function
Function Makelist()
string objName
variable n,i
i=0
n = CountObjects(":",4)
Make/O /T /N=(n+1) lista
lista[0] = "root:"
do
	objName = GetIndexedObjName(":", 4, i)
		if (strlen(objName) == 0)
		break
		endif
	lista[i+1]=objName
	i=i+1
	print i
while(1)
end

//////////////////////////////////////////////////////////////////
///Yichang
function yichang() //calculate static-state current
make/o/n=12 ave
string matchstring = "Current-1-" + "*"
string matchlist = WaveList(matchstring,";","")
String theWave 
Variable index=0
do
		theWave = StringFromList(index, matchlist)
		if (strlen(theWave) == 0) 
			break
		endif 
	SetScale/I x 0,1,$theWave //x axis is time, which should be 1 sec.
	ave[index]=mean($theWave, 0.5, 0.51) 
index += 1
while(1)
edit ave
end
///



////////////////////////////////Quick mini/////////
Function quick_mini_data()
	ChangeName()
	MiniAverage()
	Histo_per_mini()
END
/////////////////////////////////////////////////

Menu "Macros"
//	Submenu Mini
//	End
	"ChangeName", ChangeName();
	Submenu "Parameters Table"
		"sIPSC", mini_paras();
		//All_para();
		"Evoked", evoked_paras();
	END	
	"MiniAverage", MiniAverage();
	"Cumulative plots of mEPSC", Histo_per_mini();
	"Cumulative distribution individual", Histo_per();
	
	"Show me the Amp Distribution", amp_histo_plot();
	"Cumulative Plots of _all", Histo_cal_all();
	"Label graphs", plotting_re()
	//"Format Figues", Format_figs();
	//"Format Groups Plots", formatgroupplot();
	"AP plot", AP();
	"AP stats names", AP_stats();
	Submenu "Fitting"	
		"Display Trace", displaymini();
		"Single exponential Fit", fitmini();
	End
	Submenu "Make waves"
		"PSCs", name_mini_paras();
		"evoked", name_evoked_paras();
	END	
	"Yichang", yichang()
End

Menu "Utility"
	"Kill graph and table", kill_graphs_and_tables()
	"Make Panel", MakePanel()
	"Folder list panel (wave lista)", Folder_Selector()
END	
