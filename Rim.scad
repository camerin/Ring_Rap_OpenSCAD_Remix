include <constants.scad>



module rim_spoked(ISO_rim_diameter, number_of_spokes,spoke_hole_diam=2,rim_shape="Nucleon_Front", number_of_segments=70){
	rotate([0,90,0])union(){
		for (seg_num=[1:number_of_segments]){
			rotate([seg_num*360/number_of_segments,0,0])translate([0,ISO_rim_diameter/2,-.5*pi*ISO_rim_diameter/number_of_segments])linear_extrude(pi*ISO_rim_diameter/number_of_segments)import(file = "Rim_cross_section.dxf",layer=rim_shape);
		}
		for (spoke_num=[1:number_of_spokes]){
			rotate([spoke_num*360/number_of_spokes,0,0])translate([0,ISO_rim_diameter/2,0])rotate([90,0,0])cylinder(r=spoke_hole_diam/2,h=ISO_rim_diameter/8);
		}
	}
}
module rim(ISO_rim_diameter, number_of_spokes,spoke_hole_diam=2,rim_shape="Nucleon_Front", number_of_segments=70){
	rotate([0,90,0])difference(){
		union(){
			for (seg_num=[1:number_of_segments]){
				rotate([seg_num*360/number_of_segments,0,0])translate([0,ISO_rim_diameter/2,-.5*pi*ISO_rim_diameter/number_of_segments])linear_extrude(pi*ISO_rim_diameter/number_of_segments)import(file = "Rim_cross_section.dxf",layer=rim_shape);
			}
		}
		for (spoke_num=[1:number_of_spokes]){
			rotate([spoke_num*360/number_of_spokes,0,0])translate([0,ISO_rim_diameter/4,0])rotate([270,0,0])cylinder(r=spoke_hole_diam/2,h=ISO_rim_diameter/2);
		}
	}
}



module rim_segment_spoked(ISO_rim_diameter, number_of_spokes, start_angle,stop_angle,number_of_segments=5,spoke_hole_diam=2,rim_shape="Nucleon_Front",$fn=15){
	arc_length=(stop_angle-start_angle);
	rotate([0,90,0])union(){
		for (cur_ang=[start_angle:arc_length/number_of_segments:stop_angle]){
			rotate([cur_ang,0,0])translate([0,ISO_rim_diameter/2,-.5*(arc_length/360)*pi*ISO_rim_diameter/number_of_segments])linear_extrude(pi*ISO_rim_diameter*(arc_length/360)/number_of_segments)import(file = "Rim_cross_section.dxf",layer=rim_shape);
		}
		for (spoke_num=[1:number_of_spokes]){
			if(spoke_num*360/number_of_spokes>start_angle){
				if(spoke_num*360/number_of_spokes<stop_angle){
					rotate([spoke_num*360/number_of_spokes,0,0])translate([0,ISO_rim_diameter/2,0])rotate([90,0,0])cylinder(r=spoke_hole_diam/2,h=ISO_rim_diameter/8,$fn=15);
				}
			}
		}
	}
}

