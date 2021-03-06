//rim.scad contains all of the funtions for making the parametric rim.
include <rim.scad>
//buil_specifications.scad contains all of the parameters for this build of the ring rap.
include <Build_specifications.scad>
//Utility_Functions.scad contains some handy generic funcitons, like nuts, bolts, and others
include <Utility_Functions.scad>
carrage_z_offset=overall_rim_thickness/2+distance_between_rods/2+mount_wall_thickness+cross_carriage_bearings[2]/2+gantry_end_bearing[1]/2-gantry_end_bearing[2]/2+extra_space_for_belt;//computes the gantry center height

module rod_length(){
	echo("This build requires 2 linear rods at with a length of ",2*(sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness),"mm");
	echo("This build requires 4 linear rods a t with a length of ",(sin(45)*iso_rim_size*1.1),"mm");
}
slider();

module slider(Z_angle=0,x_angle=0){

	rotate([0,0,Z_angle])translate([0,sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,carrage_z_offset]){
		rotate([0,x_angle,0])difference(){
			union(){
				hull(){
					translate([0,0,distance_between_rods/2-Sled_bearings[1]*.2/2-mount_wall_thickness/2])cube([Sled_bearings[0],Sled_bearings[1]+mount_wall_thickness*2,Sled_bearings[1]*.8+mount_wall_thickness],center=true);
					translate([0,0,-distance_between_rods/2-Sled_bearings[2]-mount_wall_thickness/2])cube([Sled_bearings[1],Sled_bearings[1]+mount_wall_thickness*2,.1],center=true);
				}
				translate([-Sled_bearings[1]/2,-Sled_bearings[1]/2-mount_wall_thickness,-distance_between_rods/2-Sled_bearings[2]-mount_wall_thickness/2+belt_type[4]]){
					cube([Sled_bearings[1],Sled_bearings[1]+mount_wall_thickness*2+belt_type[3]+1,Sled_bearings[2]*2+mount_wall_thickness-belt_type[4]*2]);
					translate([0,Sled_bearings[1]+mount_wall_thickness*2+belt_type[3]/2,0])rotate([180,0,0])belt_teeth(belt_type,num_teeth_on_slider);
					translate([0,Sled_bearings[1]+mount_wall_thickness*2+belt_type[3],-belt_type[4]])cube([Sled_bearings[1],mount_wall_thickness,Sled_bearings[2]*2+mount_wall_thickness]);
					translate([0,Sled_bearings[1]+mount_wall_thickness*2+belt_type[3]/2,Sled_bearings[2]*2+mount_wall_thickness-belt_type[4]*2])rotate([0,0,0])belt_teeth(belt_type,num_teeth_on_slider);
				}
			}
			
			translate([0,Sled_bearings[1]/2+mount_wall_thickness+belt_type[3]/2,-cross_carriage_bearings[1]/2])cube([999,belt_type[3],belt_type[4]],center=true);
			translate([0,0,cross_carriage_bearings[1]/2])rotate([0,90,0])cylinder(r=Sled_bearings[1]/2,h=Sled_bearings[0]*2,center=true);
			translate([0,0,-distance_between_rods/2])rotate([90,0,0])cylinder(r=cross_carriage_bearings[2]/2,h=Sled_bearings[1]*2+belt_type[3]*2+mount_wall_thickness*2,center=true);
		}
	}
}
module slider_bearing(Z_angle=0,x_angle=0){

	rotate([0,0,Z_angle])translate([0,sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,carrage_z_offset]){
		rotate([0,x_angle,0])difference(){
			translate([0,0,Sled_bearings[1]/2])rotate([0,90,0])cylinder(r=Sled_bearings[1]/2,h=Sled_bearings[0]+1,center=true);
			translate([0,0,Sled_bearings[1]/2])rotate([0,90,0])cylinder(r=Sled_bearings[2]/2,h=Sled_bearings[0]*2,center=true);
		}
	}
}

module assembled_gantry(){
	slider();
	slider(90,180);
	slider(180);
	slider(270,180);
	slider_bearing();
	slider_bearing(90,180);
	slider_bearing(180);
	slider_bearing(270,180);
	carriage_rim_mount(45,true);
	carriage_rim_mount(135);
	carriage_rim_mount(225,true);
	carriage_rim_mount(315);
	translate([0,0,carrage_z_offset]){
		translate([0,0,distance_between_rods/2])rotate([0,90,0])cylinder(r=cross_carriage_bearings[2]/2,h=sin(45)*iso_rim_size,center=true);
		translate([0,0,-distance_between_rods/2])rotate([0,90,90])cylinder(r=cross_carriage_bearings[2]/2,h=sin(45)*iso_rim_size,center=true);
		assembled_cross_carrage();
	}
	rim(iso_rim_size,number_of_spokes,rim_shape=cur_rim_shape,spoke_hole_diam=spoke_hole_diameter,number_of_segments=120);
	rods();
	ganntry_pillar_set();
	ganntry_pillar_bushings_set();
}
module ganntry_pillar_set(){
if(number_of_pillars==2){
		pillar_bushing(0);
		pillar_bushing(180);
	}
	if(number_of_pillars==3){
		pillar_bushing(0);
		pillar_bushing(180);
		pillar_bushing(90);
	}
	if(number_of_pillars==4){
		pillar_bushing(0);
		pillar_bushing(180);
		pillar_bushing(90);
		pillar_bushing(270);
	}
}
module ganntry_pillar_bushings_set(){
if(number_of_pillars==2){
		pillar_bushing_only(0);
		pillar_bushing_only(180);
	}
	if(number_of_pillars==3){
		pillar_bushing_only(0);
		pillar_bushing_only(180);
		pillar_bushing_only(90);
	}
	if(number_of_pillars==4){
		pillar_bushing_only(0);
		pillar_bushing_only(180);
		pillar_bushing_only(90);
		pillar_bushing_only(270);
	}
}

module assembled_cross_carrage(){
	cross_carrage();
	translate([0,cross_carriage_bearings[0]/2+cross_carriage_bearings[1]/2+.5,-distance_between_rods/2])rotate([0,0,90])linear_bearing(cross_carriage_bearings);
		translate([cross_carriage_bearings[0]/2+cross_carriage_bearings[1]/2+.5,0,distance_between_rods/2])rotate([0,0,0])linear_bearing(cross_carriage_bearings);
}


module cross_carrage(){
	difference(){
		hull(){
			translate([0,cross_carriage_bearings[0]/2+cross_carriage_bearings[1]/2,-distance_between_rods/2+(gantry_wall_thickness/2+cross_carriage_bearings[1]*.1)])rotate([0,0,90])cube([cross_carriage_bearings[0]-.4,cross_carriage_bearings[1]+2*gantry_wall_thickness,cross_carriage_bearings[1]*.8+gantry_wall_thickness],center=true);
			rotate([0,0,-90])translate([0,cross_carriage_bearings[0]/2+cross_carriage_bearings[1]/2,distance_between_rods/2-(gantry_wall_thickness/2+cross_carriage_bearings[1]*.1)])rotate([0,0,90])cube([cross_carriage_bearings[0]-.02,cross_carriage_bearings[1]+gantry_wall_thickness*2,cross_carriage_bearings[1]*.8+gantry_wall_thickness],center=true);
				rotate([0,0,-90])translate([0,cross_carriage_bearings[0]/2+cross_carriage_bearings[1]/2,(gantry_wall_thickness/2+cross_carriage_bearings[1]*.1)-distance_between_rods/2])rotate([0,0,90])cube([cross_carriage_bearings[0]-.02,cross_carriage_bearings[1],cross_carriage_bearings[1]*.8+gantry_wall_thickness],center=true);
				translate([0,cross_carriage_bearings[0]/2+cross_carriage_bearings[1]/2,distance_between_rods/2-(gantry_wall_thickness/2+cross_carriage_bearings[1]*.1)])rotate([0,0,90])cube([cross_carriage_bearings[0]-.02,cross_carriage_bearings[1],cross_carriage_bearings[1]*.8+gantry_wall_thickness],center=true);
			}	
		translate([0,cross_carriage_bearings[0]/2+cross_carriage_bearings[1]/2,-distance_between_rods/2])rotate([0,90,90])cylinder(r=cross_carriage_bearings[1]/2,h=cross_carriage_bearings[0],center=true);
		translate([cross_carriage_bearings[0]/2+cross_carriage_bearings[1]/2,0,distance_between_rods/2])rotate([0,90,0])cylinder(r=cross_carriage_bearings[1]/2,h=cross_carriage_bearings[0],center=true);
		translate([cross_carriage_bearings[0]+gantry_wall_thickness,cross_carriage_bearings[0]+gantry_wall_thickness,0])cylinder(r=hot_end_cut_out_radius/2,h=cross_carriage_bearings[1]+distance_between_rods+2*gantry_wall_thickness,center=true);
		hull(){
			translate([-1000,00,0])cube([cross_carriage_bearings[1]+1,cross_carriage_bearings[1]+1,(cross_carriage_bearings[1]+distance_between_rods)*2],center=true);
			translate([00,-1000,0])cube([cross_carriage_bearings[1]+1,cross_carriage_bearings[1]+1,(cross_carriage_bearings[1]+distance_between_rods)*2],center=true);
			cube([cross_carriage_bearings[1]+1,cross_carriage_bearings[1]+1,(cross_carriage_bearings[1]+distance_between_rods)*2],center=true);
		}
		translate([cross_carriage_bearings[0]-hot_end_cut_out_radius/2+gantry_wall_thickness,cross_carriage_bearings[0]-hot_end_cut_out_radius/2+gantry_wall_thickness,0])rotate([180,0,0])cylinder(r=mount_screw_diam/2,h=(cross_carriage_bearings[1]+gantry_wall_thickness+distance_between_rods)*2,center=true);

	}
	
}


module carriage_rim_mount(location_angle,motor_mount=false){
	intersection(){
		difference(){
			union(){
				hull(){
					rotate([0,0,90-location_angle])translate([iso_rim_size/2+sqrt(corner_size*corner_size+corner_size*corner_size)/2,0,overall_rim_thickness/2+mount_wall_thickness/2])rotate([0,0,135])cube(mount_wall_thickness);
					rotate([0,0,90-location_angle])translate([iso_rim_size/2,-sqrt(corner_size*corner_size+corner_size*corner_size)/2,overall_rim_thickness/2+mount_wall_thickness/2])rotate([0,0,45])cube(mount_wall_thickness);
					rotate([0,0,90-location_angle])translate([iso_rim_size/2,sqrt(corner_size*corner_size+corner_size*corner_size)/2,overall_rim_thickness/2+mount_wall_thickness/2])rotate([0,0,135])cube(mount_wall_thickness);
				}
				hull(){
					rim_segment(iso_rim_size-mount_wall_thickness, number_of_spokes, location_angle-7.5,location_angle+7.5,number_of_segments=5,spoke_hole_diam=2,rim_shape=cur_rim_shape,$fn=15);
					translate([0,0,-mount_wall_thickness])rim_segment(iso_rim_size, number_of_spokes, location_angle-7.5,location_angle+7.5,number_of_segments=5,spoke_hole_diam=2,rim_shape=cur_rim_shape,$fn=15);
				translate([0,0,mount_wall_thickness])rim_segment(iso_rim_size, number_of_spokes, location_angle-7.5,location_angle+7.5,number_of_segments=5,spoke_hole_diam=2,rim_shape=cur_rim_shape,$fn=15);
				}
			
				rotate([0,0,90-location_angle])translate([iso_rim_size/2+sqrt(corner_size*corner_size+corner_size*corner_size)/2,0,overall_rim_thickness/2+mount_wall_thickness/2])rotate([0,0,135])cube([corner_size+mount_wall_thickness,mount_wall_thickness+gantry_end_bearing[0],mount_wall_thickness*2+gantry_end_bearing[1]+distance_between_rods]);
				rotate([0,0,90-location_angle])translate([iso_rim_size/2+sqrt(corner_size*corner_size+corner_size*corner_size)/2,0,overall_rim_thickness/2+mount_wall_thickness/2])rotate([0,0,225])mirror([0,1,0])cube([corner_size,mount_wall_thickness+gantry_end_bearing[0],mount_wall_thickness*2+gantry_end_bearing[1]+distance_between_rods]);
				if(motor_mount){
					rotate([0,0,90-location_angle])translate([iso_rim_size/2+sqrt(corner_size*corner_size+corner_size*corner_size)/2,0,overall_rim_thickness/2+mount_wall_thickness/2+mount_wall_thickness*2+gantry_end_bearing[1]+distance_between_rods])rotate([0,0,135])cube([corner_size+mount_wall_thickness,corner_size,mount_wall_thickness]);
				}
			}
			rim_segment_spoked(iso_rim_size, number_of_spokes, location_angle-8,location_angle+15,number_of_segments=5,spoke_hole_diam=2,rim_shape=cur_rim_shape,$fn=15);
			hull(){
				rim_segment(iso_rim_size+rim_distance_from_bead_to_inner_circle/2, number_of_spokes, location_angle-7.5,location_angle+7.5,number_of_segments=5,spoke_hole_diam=2,rim_shape=cur_rim_shape,$fn=15);
				rim_segment(iso_rim_size+rim_distance_from_bead_to_inner_circle/2+2*mount_wall_thickness, number_of_spokes, location_angle-7.5,location_angle+7.5,number_of_segments=5,spoke_hole_diam=2,rim_shape=cur_rim_shape,$fn=15);
			}
			rods_difference();
		}
		rotate([0,0,90-location_angle])translate([iso_rim_size/2+sqrt(corner_size*corner_size+corner_size*corner_size)/2,0,-overall_rim_thickness])rotate([0,0,135])cube([corner_size*2+mount_wall_thickness,corner_size*2,mount_wall_thickness+overall_rim_thickness+mount_wall_thickness/2+mount_wall_thickness*+gantry_end_bearing[1]*2+distance_between_rods*5]);
	}
}

module rods(){
	translate([sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,carrage_z_offset-distance_between_rods/2])rotate([90,0,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
	translate([sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,carrage_z_offset+distance_between_rods/2])rotate([0,-90,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
	mirror([1,0,0]){
		translate([sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,carrage_z_offset-distance_between_rods/2])rotate([90,0,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
	translate([sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,carrage_z_offset+distance_between_rods/2])rotate([0,-90,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
	}
	mirror([0,1,0]){
		translate([sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,carrage_z_offset-distance_between_rods/2])rotate([90,0,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
	translate([sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,carrage_z_offset+distance_between_rods/2])rotate([0,-90,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
		mirror([1,0,0]){
			translate([sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,carrage_z_offset-distance_between_rods/2])rotate([90,0,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
	translate([sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,carrage_z_offset+distance_between_rods/2])rotate([0,-90,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
		}
	}
	translate([0,sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,carrage_z_offset]){
		translate([0,0,distance_between_rods/2])rotate([0,90,0])cylinder(r=cross_carriage_bearings[2]*.5,h=sin(45)*iso_rim_size*1.25,center=true);
	}
	translate([0,corner_size/2-gantry_end_bearing[1]/2-mount_wall_thickness-sin(45)*iso_rim_size/2,carrage_z_offset]){
		translate([0,0,distance_between_rods/2])rotate([0,90,0])cylinder(r=cross_carriage_bearings[2]*.5,h=sin(45)*iso_rim_size*1.25,center=true);
	}

	translate([sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,0,carrage_z_offset]){
		translate([0,0,-distance_between_rods/2])rotate([90,0,0])cylinder(r=cross_carriage_bearings[2]*.5,h=sin(45)*iso_rim_size*1.25,center=true);
	}
	translate([corner_size/2-gantry_end_bearing[1]/2-mount_wall_thickness-sin(45)*iso_rim_size/2,0,carrage_z_offset]){
		translate([0,0,-distance_between_rods/2])rotate([90,0,0])cylinder(r=cross_carriage_bearings[2]*.5,h=sin(45)*iso_rim_size*1.25,center=true);
	}
}

module rods_difference(){
	translate([sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,carrage_z_offset-distance_between_rods/2])rotate([90,0,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
	translate([sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,carrage_z_offset+distance_between_rods/2])rotate([0,-90,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
	mirror([1,0,0]){
		translate([sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,carrage_z_offset-distance_between_rods/2])rotate([90,0,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
	translate([sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,carrage_z_offset+distance_between_rods/2])rotate([0,-90,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
	}
	mirror([0,1,0]){
		translate([sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,carrage_z_offset-distance_between_rods/2])rotate([90,0,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
	translate([sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,carrage_z_offset+distance_between_rods/2])rotate([0,-90,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
		mirror([1,0,0]){
			translate([sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,carrage_z_offset-distance_between_rods/2])rotate([90,0,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
	translate([sin(45)*iso_rim_size/2+corner_size/2-mount_wall_thickness,sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,carrage_z_offset+distance_between_rods/2])rotate([0,-90,0])cylinder(r=gantry_end_bearing[1]/2,h=gantry_end_bearing[0]+.1);
		}
	}
	translate([0,sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,carrage_z_offset]){
		translate([0,0,distance_between_rods/2])rotate([0,90,0])cylinder(r=cross_carriage_bearings[2]*.75,h=sin(45)*iso_rim_size*1.25,center=true);
	}
	translate([0,corner_size/2-gantry_end_bearing[1]/2-mount_wall_thickness-sin(45)*iso_rim_size/2,carrage_z_offset]){
		translate([0,0,distance_between_rods/2])rotate([0,90,0])cylinder(r=cross_carriage_bearings[2]*.75,h=sin(45)*iso_rim_size*1.25,center=true);
	}

	translate([sin(45)*iso_rim_size/2-corner_size/2+gantry_end_bearing[1]/2+mount_wall_thickness,0,carrage_z_offset]){
		translate([0,0,-distance_between_rods/2])rotate([90,0,0])cylinder(r=cross_carriage_bearings[2]*.75,h=sin(45)*iso_rim_size*1.25,center=true);
	}
	translate([corner_size/2-gantry_end_bearing[1]/2-mount_wall_thickness-sin(45)*iso_rim_size/2,0,carrage_z_offset]){
		translate([0,0,-distance_between_rods/2])rotate([90,0,0])cylinder(r=cross_carriage_bearings[2]*.75,h=sin(45)*iso_rim_size*1.25,center=true);
	}
}
module pillar_bushing_only(location_angle){
	difference(){
		rotate([0,0,90-location_angle])translate([iso_rim_size/2-rim_distance_from_bead_to_inner_circle-pillar_support_wall_thickness-pillar_rod_diameter/2,0,0]){
			translate([0,0,pillar_support_wall_thickness])cylinder(r=gantry_bearings[1]/2, h=gantry_bearings[0]+.5,center=true);
			}
		rotate([0,0,90-location_angle])translate([iso_rim_size/2-rim_distance_from_bead_to_inner_circle-pillar_support_wall_thickness-pillar_rod_diameter/2,0,0]){
			translate([0,0,pillar_support_wall_thickness])cylinder(r=gantry_bearings[2]/2, h=gantry_bearings[0]*2,center=true);
			}
	}
}

//This module is the piller slides
module pillar_bushing(location_angle,bevel_radius=5){
	difference(){
		union(){
			hull(){
				rim_segment(iso_rim_size-mount_wall_thickness, number_of_spokes, location_angle-7.5,location_angle+7.5,number_of_segments=5,spoke_hole_diam=2,rim_shape=cur_rim_shape,$fn=15);
				translate([0,0,-z_screw_mount_thickness])rim_segment(iso_rim_size, number_of_spokes, location_angle-7.5,location_angle+7.5,number_of_segments=5,spoke_hole_diam=2,rim_shape=cur_rim_shape,$fn=15);
				translate([0,0,mount_wall_thickness])rim_segment(iso_rim_size, number_of_spokes, location_angle-7.5,location_angle+7.5,number_of_segments=5,spoke_hole_diam=2,rim_shape=cur_rim_shape,$fn=15);
				rotate([0,0,90-location_angle])translate([iso_rim_size/2-rim_distance_from_bead_to_inner_circle-pillar_support_wall_thickness-pillar_rod_diameter/2,0,0]){
					translate([0,0,z_screw_mount_thickness-z_screw_mount_thickness-overall_rim_thickness])cylinder(r=gantry_bearings[1]/2+wall_thickness, h=gantry_bearings[0]);
				}
		}
		hull(){
			translate([0,0,-z_screw_mount_thickness])rim_segment(iso_rim_size, number_of_spokes, location_angle-7.5,location_angle+7.5,number_of_segments=5,spoke_hole_diam=2,rim_shape=cur_rim_shape,$fn=15);
			rotate([0,0,90-location_angle-7.5])translate([iso_rim_size/2,0,pillar_support_wall_thickness-z_screw_mount_thickness-overall_rim_thickness])cylinder(r=bevel_radius,h=z_screw_mount_thickness);
			rotate([0,0,90-location_angle])translate([iso_rim_size/2-rim_distance_from_bead_to_inner_circle-pillar_support_wall_thickness-pillar_rod_diameter/2,0,0])translate([0,0,pillar_support_wall_thickness-z_screw_mount_thickness-overall_rim_thickness])cylinder(r=gantry_bearings[1]/2+wall_thickness, h=z_screw_mount_thickness );
			
		}
		hull(){
			rotate([0,0,90-location_angle-7.5])translate([iso_rim_size/2,0,pillar_support_wall_thickness-z_screw_mount_thickness-overall_rim_thickness])cylinder(r=bevel_radius,h=z_screw_mount_thickness);
			rotate([0,0,90-location_angle+7.5])translate([iso_rim_size/2,0,pillar_support_wall_thickness-z_screw_mount_thickness-overall_rim_thickness])cylinder(r=bevel_radius,h=z_screw_mount_thickness);
			rotate([0,0,90-location_angle])translate([iso_rim_size/2-rim_distance_from_bead_to_inner_circle-pillar_support_wall_thickness-pillar_rod_diameter/2,0,0])translate([0,0,pillar_support_wall_thickness-z_screw_mount_thickness-overall_rim_thickness])cylinder(r=gantry_bearings[1]/2, h=z_screw_mount_thickness );
			rotate([0,0,90-location_angle])translate([iso_rim_size/2-rim_distance_from_bead_to_inner_circle-pillar_support_wall_thickness-pillar_rod_diameter/2,0,0])translate([2*pillar_support_wall_thickness+bevel_radius+overall_rim_thickness+nema_motor_box_size/2,0,pillar_support_wall_thickness-z_screw_mount_thickness-overall_rim_thickness])cylinder(r=Z_screw_nut[2]/2+wall_thickness, h=z_screw_mount_thickness );
		}
		}
		rotate([0,0,90-location_angle])translate([iso_rim_size/2-rim_distance_from_bead_to_inner_circle-pillar_support_wall_thickness-pillar_rod_diameter/2,0,0]){
			translate([0,0,pillar_support_wall_thickness-z_screw_mount_thickness-overall_rim_thickness-.5])cylinder(r=gantry_bearings[1]/2, h=gantry_bearings[0]*2 );
			
			}
		hull(){
			rim_segment(iso_rim_size+rim_distance_from_bead_to_inner_circle/2, number_of_spokes, location_angle-7.5,location_angle+7.5,number_of_segments=5,spoke_hole_diam=2,rim_shape=cur_rim_shape,$fn=15);
			rim_segment(iso_rim_size+rim_distance_from_bead_to_inner_circle/2+2*mount_wall_thickness, number_of_spokes, location_angle-7.5,location_angle+7.5,number_of_segments=5,spoke_hole_diam=2,rim_shape=cur_rim_shape,$fn=15);
		}
		rotate([0,0,90-location_angle])translate([iso_rim_size/2-rim_distance_from_bead_to_inner_circle-pillar_support_wall_thickness-pillar_rod_diameter/2,0,0])translate([2*pillar_support_wall_thickness+bevel_radius+overall_rim_thickness+nema_motor_box_size/2,0,pillar_support_wall_thickness-z_screw_mount_thickness-overall_rim_thickness-.005])cylinder(r=Z_screw_nut[2]/2, h=Z_screw_nut[1] ,$fn=Z_screw_nut[0]);
		rotate([0,0,90-location_angle])translate([iso_rim_size/2-rim_distance_from_bead_to_inner_circle-pillar_support_wall_thickness-pillar_rod_diameter/2,0,0])translate([2*pillar_support_wall_thickness+bevel_radius+overall_rim_thickness+nema_motor_box_size/2,0,pillar_support_wall_thickness-z_screw_mount_thickness-overall_rim_thickness-.005])cylinder(r=Z_screw_nut[3]*.55, h=z_screw_mount_thickness*2);
		rim_spoked(iso_rim_size, number_of_spokes,spoke_hole_diam=spoke_hole_diameter,rim_shape=cur_rim_shape, number_of_segments=70);
	}
	
}
