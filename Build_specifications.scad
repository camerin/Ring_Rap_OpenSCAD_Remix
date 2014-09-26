//general Build Info
number_of_pillars=3;//2,3,4 are the current options

//rim sizes
iso_rim_size=559;
number_of_spokes=36;
spoke_hole_diameter=4;
rim_width=20;
cur_rim_shape="Nucleon_Front";
rim_distance_from_bead_to_inner_circle=15;
overall_rim_thickness=18.6;

//feet sizeing
base_leg_footprint=80;
base_leg_height=50;
bed_leveling_nut_trap_wrench_width=5.5;
bed_leveling_bolt_size=3.3;
bed_leveling_nut_trap_depth=2;
bed_leveling_bolt_offset=15;

//pillar sizes
pillar_rod_diameter=25;
length_of_pillar_support=60;
pillar_support_wall_thickness=6;
nema_motor_box_size=43.5;
pillar_y=90;
pillar_h=1000;

//plate sizing
base_plate_space_around_bolt=7;
bed_thickness=5;
space_for_leveling=10;

//bearing or bussing size sizes [ length OD ID]; 
LM10UU = [29, 19, 10];
LM8UU  = [24, 15,  8];
LM6UU  = [19, 12,  6];
LM4UU  = [12,  8,  4];
guess_at_tower_bushings=[70,29,25];

//Gantry Sizing
cross_carriage_bearings=LM8UU;
distance_between_rods=15;
gantry_wall_thickness=4;
hot_end_cut_out_radius=30;
mount_screw_diam=4;
mount_screw_depth=10;

//gantry brackets
mount_wall_thickness=3;
Sled_bearings=LM8UU;
motor_x=45;
motor_y=47;
rim_bevel_radius=3;

//gantry slides
gantry_bearings=guess_at_tower_bushings;
wall_thickness=3;

//top parameters
length_of_top_support=40;

//logo and text info for default text sizes.
name_of_printer="RingRap";
font="ShowCard Gothic";//check the installed fonts in the help menue. You can use any of them.
size=10;//height in mm
//linear_extrude(2)text(name_of_printer,size,font);//test module.

