#===============================================================================
# Makefile for AHB UVM Testbench
# Simulator = QuestaSim
# Coverage enabled + Regression coverage merge
#===============================================================================

SIMULATOR = Questa

RTL  = ../rtl/*
WORK = work

SVTB1 = ../tb/top.sv
SVTB2 = ../test/test_pkg.sv

INC = +incdir+../tb \
      +incdir+../test \
      +incdir+../master_top \
      +incdir+../slave_top

#-------------------------------------------------------------------------------
# Questa options
#-------------------------------------------------------------------------------

VSIMOPT = -vopt -voptargs=+acc

# Enable functional/code/assertion coverage
VSIMCOV = -coverage -sva

#-------------------------------------------------------------------------------
# Coverage save commands
#
# Each test gets its own coverage database.
#-------------------------------------------------------------------------------

VSIMBATCH1 = -c -do "log -r /* ; coverage save -onexit ahb_cov1 ; run -all ; exit"
VSIMBATCH2 = -c -do "log -r /* ; coverage save -onexit ahb_cov2 ; run -all ; exit"
VSIMBATCH3 = -c -do "log -r /* ; coverage save -onexit ahb_cov3 ; run -all ; exit"
VSIMBATCH4 = -c -do "log -r /* ; coverage save -onexit ahb_cov4 ; run -all ; exit"
VSIMBATCH5 = -c -do "log -r /* ; coverage save -onexit ahb_cov5 ; run -all ; exit"
VSIMBATCH6 = -c -do "log -r /* ; coverage save -onexit ahb_cov6 ; run -all ; exit"
VSIMBATCH7 = -c -do "log -r /* ; coverage save -onexit ahb_cov7 ; run -all ; exit"
VSIMBATCH8 = -c -do "log -r /* ; coverage save -onexit ahb_cov8 ; run -all ; exit"
VSIMBATCH9 = -c -do "log -r /* ; coverage save -onexit ahb_cov9 ; run -all ; exit"


#===============================================================================
# Help
#===============================================================================


help:
        @echo ============================================================================================================
        @echo "! USAGE          --  make target                                                                                !"
        @echo "!                                                                                                                !"
        @echo "! clean          =>  Clean previous compilation, logs, coverage and waveforms                                   !"
        @echo "! sv_cmp         =>  Compile RTL and Testbench                                                                   !"
        @echo "! run_test       =>  Run base test                                                                               !"
        @echo "! run_test1      =>  Run single_okay_test                                                                        !"
        @echo "! run_test2      =>  Run single_wait_test                                                                        !"
        @echo "! run_test3      =>  Run single_error_test                                                                       !"
        @echo "! run_test4      =>  Run incr_okay_test                                                                          !"
        @echo "! run_test5      =>  Run incr_wait_test                                                                          !"
        @echo "! run_test6      =>  Run incr_error_test                                                                         !"
        @echo "! run_test7      =>  Run wrap_okay_test                                                                          !"
        @echo "! run_test8      =>  Run wrap_wait_test                                                                          !"
        @echo "! run_test9      =>  Run wrap_error_test                                                                         !"
        @echo "!                                                                                                                !"
        @echo "! view_wave1     =>  View waveform of single_okay_test                                                           !"
        @echo "! view_wave2     =>  View waveform of single_wait_test                                                           !"
        @echo "! view_wave3     =>  View waveform of single_error_test                                                          !"
        @echo "! view_wave4     =>  View waveform of incr_okay_test                                                             !"
        @echo "! view_wave5     =>  View waveform of incr_wait_test                                                             !"
        @echo "! view_wave6     =>  View waveform of incr_error_test                                                            !"
        @echo "! view_wave7     =>  View waveform of wrap_okay_test                                                             !"
        @echo "! view_wave8     =>  View waveform of wrap_wait_test                                                             !"
        @echo "! view_wave9     =>  View waveform of wrap_error_test                                                            !"
        @echo "!                                                                                                                !"
        @echo "! regress        =>  Run all 9 tests + merge coverage                                                            !"
        @echo "! report         =>  Merge coverage and generate HTML report                                                     !"
        @echo "! cov            =>  Open merged coverage report                                                                 !"
        @echo ============================================================================================================


#===============================================================================
# Main Targets
#===============================================================================

clean:
        $(MAKE) clean_$(SIMULATOR)

sv_cmp:
        $(MAKE) sv_cmp_$(SIMULATOR)

run_test:
        $(MAKE) run_test_$(SIMULATOR)

run_test1:
        $(MAKE) run_test1_$(SIMULATOR)

run_test2:
        $(MAKE) run_test2_$(SIMULATOR)

run_test3:
        $(MAKE) run_test3_$(SIMULATOR)

run_test4:
        $(MAKE) run_test4_$(SIMULATOR)

run_test5:
        $(MAKE) run_test5_$(SIMULATOR)

run_test6:
        $(MAKE) run_test6_$(SIMULATOR)

run_test7:
        $(MAKE) run_test7_$(SIMULATOR)

run_test8:
        $(MAKE) run_test8_$(SIMULATOR)

run_test9:
        $(MAKE) run_test9_$(SIMULATOR)

view_wave1:
        $(MAKE) view_wave1_$(SIMULATOR)

view_wave2:
        $(MAKE) view_wave2_$(SIMULATOR)
                                                                                                   view_wave3:
        $(MAKE) view_wave3_$(SIMULATOR)

view_wave4:
        $(MAKE) view_wave4_$(SIMULATOR)

view_wave5:
        $(MAKE) view_wave5_$(SIMULATOR)

view_wave6:
        $(MAKE) view_wave6_$(SIMULATOR)

view_wave7:
        $(MAKE) view_wave7_$(SIMULATOR)

view_wave8:
        $(MAKE) view_wave8_$(SIMULATOR)

view_wave9:
        $(MAKE) view_wave9_$(SIMULATOR)

regress:
        $(MAKE) regress_$(SIMULATOR)

report:
        $(MAKE) report_$(SIMULATOR)

cov:
        $(MAKE) cov_$(SIMULATOR)


#===============================================================================
# Questa Compile
#===============================================================================

 sv_cmp_Questa:
        vlib $(WORK)
        vmap work $(WORK)
        vlog -work $(WORK) $(RTL) $(INC) $(SVTB2) $(SVTB1)


#===============================================================================
# Run Tests
#===============================================================================

run_test_Questa: sv_cmp_Questa
        vsim $(VSIMOPT) $(VSIMCOV) \
        $(VSIMBATCH1) \
        -wlf wave_file.wlf \
        -l test.log \
        -sv_seed random \
        work.top +UVM_TESTNAME=test


run_test1_Questa: sv_cmp_Questa
        vsim $(VSIMOPT) $(VSIMCOV) \
        $(VSIMBATCH1) \
        -wlf wave_file1.wlf \
        -l test1.log \
        -sv_seed random \
        work.top +UVM_TESTNAME=single_okay_test

        vcover report -cvg -details -nocompactcrossbins \
        -codeAll -assert -directive -html ahb_cov1


run_test2_Questa: sv_cmp_Questa
        vsim $(VSIMOPT) $(VSIMCOV) \
        $(VSIMBATCH2) \
        -wlf wave_file2.wlf \
        -l test2.log \
        -sv_seed random \
        work.top +UVM_TESTNAME=single_wait_test

        vcover report -cvg -details -nocompactcrossbins \
        -codeAll -assert -directive -html ahb_cov2
                                                           

run_test3_Questa: sv_cmp_Questa
        vsim $(VSIMOPT) $(VSIMCOV) \
        $(VSIMBATCH3) \
        -wlf wave_file3.wlf \
        -l test3.log \
        -sv_seed random \
        work.top +UVM_TESTNAME=single_error_test

        vcover report -cvg -details -nocompactcrossbins \
        -codeAll -assert -directive -html ahb_cov3


run_test4_Questa: sv_cmp_Questa
        vsim $(VSIMOPT) $(VSIMCOV) \
        $(VSIMBATCH4) \
        -wlf wave_file4.wlf \
        -l test4.log \
        -sv_seed random \
        work.top +UVM_TESTNAME=incr_okay_test

        vcover report -cvg -details -nocompactcrossbins \
        -codeAll -assert -directive -html ahb_cov4


run_test5_Questa: sv_cmp_Questa
        vsim $(VSIMOPT) $(VSIMCOV) \
        $(VSIMBATCH5) \
        -wlf wave_file5.wlf \
        -l test5.log \
        -sv_seed random \
        work.top +UVM_TESTNAME=incr_wait_test

        vcover report -cvg -details -nocompactcrossbins \
        -codeAll -assert -directive -html ahb_cov5


run_test6_Questa: sv_cmp_Questa
        vsim $(VSIMOPT) $(VSIMCOV) \
        $(VSIMBATCH6) \
        -wlf wave_file6.wlf \
        -l test6.log \
        -sv_seed random \
        work.top +UVM_TESTNAME=incr_error_test

        vcover report -cvg -details -nocompactcrossbins \
        -codeAll -assert -directive -html ahb_cov6


run_test7_Questa: sv_cmp_Questa
        vsim $(VSIMOPT) $(VSIMCOV) \
        $(VSIMBATCH7) \
        -wlf wave_file7.wlf \
        -l test7.log \
        -sv_seed random \
        work.top +UVM_TESTNAME=wrap_okay_test

        vcover report -cvg -details -nocompactcrossbins \
        -codeAll -assert -directive -html ahb_cov7


run_test8_Questa: sv_cmp_Questa
        vsim $(VSIMOPT) $(VSIMCOV) \
        $(VSIMBATCH8) \
        -wlf wave_file8.wlf \
        -l test8.log \
        -sv_seed random \
        work.top +UVM_TESTNAME=wrap_wait_test

        vcover report -cvg -details -nocompactcrossbins \
        -codeAll -assert -directive -html ahb_cov8


run_test9_Questa: sv_cmp_Questa
        vsim $(VSIMOPT) $(VSIMCOV) \
        $(VSIMBATCH9) \
        -wlf wave_file9.wlf \
        -l test9.log \
        -sv_seed random \
        work.top +UVM_TESTNAME=wrap_error_test

        vcover report -cvg -details -nocompactcrossbins \
        -codeAll -assert -directive -html ahb_cov9


#===============================================================================
# View Waveforms
#===============================================================================

view_wave1_Questa:
        vsim -view wave_file1.wlf

view_wave2_Questa:
        vsim -view wave_file2.wlf

view_wave3_Questa:
        vsim -view wave_file3.wlf

view_wave4_Questa:
        vsim -view wave_file4.wlf

view_wave5_Questa:
        vsim -view wave_file5.wlf

view_wave6_Questa:
        vsim -view wave_file6.wlf

view_wave7_Questa:
        vsim -view wave_file7.wlf

view_wave8_Questa:
        vsim -view wave_file8.wlf

view_wave9_Questa:
        vsim -view wave_file9.wlf


#===============================================================================
# Regression
#===============================================================================

regress_Questa:
        $(MAKE) clean_Questa
        $(MAKE) run_test1_Questa
        $(MAKE) run_test2_Questa
        $(MAKE) run_test3_Questa
        $(MAKE) run_test4_Questa
        $(MAKE) run_test5_Questa
        $(MAKE) run_test6_Questa
        $(MAKE) run_test7_Questa
        $(MAKE) run_test8_Questa
        $(MAKE) run_test9_Questa
        $(MAKE) report_Questa


#===============================================================================
# Coverage Merge + HTML Report
#===============================================================================

report_Questa:
        vcover merge ahb_cov \
                ahb_cov1 \
                ahb_cov2 \
                ahb_cov3 \
                ahb_cov4 \
                ahb_cov5 \
                ahb_cov6 \
                ahb_cov7 \
                ahb_cov8 \
                ahb_cov9

        vcover report -cvg -details -nocompactcrossbins \
                -codeAll -assert -directive -html ahb_cov

                                                               

#===============================================================================
# Open Coverage Report
#===============================================================================

cov_Questa:
        firefox covhtmlreport/index.html &


#===============================================================================
# Clean
#===============================================================================

clean_Questa:
        rm -rf transcript* \
               *.log \
               fcover* \
               covhtml* \
               ahb_cov* \
               *.wlf \
               modelsim.ini \
               $(WORK)
        clear
                      
