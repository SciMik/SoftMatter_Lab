#dsfsd

units           metal
atom_style      atomic
boundary	p p p

read_data    	qH_gap.data

pair_style      quip
pair_coeff      * * ./Carbon_GAP_20.xml "" 6

thermo_style    custom  atoms step time cpu temp pe ke etotal press pxx pyy pzz lx ly
thermo          10
thermo_modify  	flush yes #lost ignore

timestep	0.0001

fix             relax all box/relax x 0.0 y 0.0
minimize        1.0e-16 1.0e-10 15000 30000
unfix           relax


comm_style     	brick
fix            	4 all balance 1000 1.05 shift xyz 5 1.05

label loop
reset_timestep 0
variable        d loop 60

variable      	step equal 0.005 
variable 	mult equal (1+${step}*($d))/(1+${step}*($d-1))
variable	actual_mult equal (1+${step}*($d-1))

dump		1 all cfg 1000 ./cfg/p2000.*.$d.cfg mass type xs ys zs
dump_modify 	1 element C
dump 		2 all custom 500  ./pos/c2000.*.pos id type x y z xu yu zu

min_style 	cg
min_modify      line quadratic
minimize 	1.0e-10 1.0e-12 100000 100000

variable	px equal pxx
variable	l equal lx

print 		"${l} ${actual_mult}  ${px}" append str_strain_x_gap.dat
change_box all 	y scale ${mult} remap

undump		1
undump		2

next d
jump in_young.gap loop
