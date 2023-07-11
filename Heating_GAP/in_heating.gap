#dsfsd

processors      * * 1

units           metal
atom_style      atomic

read_data    	qH.data

replicate	3 3 1

pair_style      quip
pair_coeff      * * ./Carbon_GAP_20.xml "" 6

compute 	msd all msd

thermo_style    custom  atoms step time cpu temp pe ke etotal press pxx pyy pzz lx ly c_msd[4]
thermo          100
thermo_modify  	flush yes

timestep	0.00025


dump		1 all cfg 10000 ./cfg/p2000.*.cfg mass type xs ys zs
dump_modify 	1 element C
dump 		2 all custom 10000  ./pos/c2000.*.pos id type x y z xu yu zu

fix		2 all npt temp 1100 1700 0.01 x 0 0 5 y 0 0 5
run		600000
