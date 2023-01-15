include <Config.inc>
include <Constants.inc>

use <MirrorCopy.scad>

CaseAndBack(50);

module CaseAndBack(
    width,
    part,
    is_printable
) {
    assert(!is_undef(width));
    if (part == "case") {
        Case(
            width        = width, 
            is_printable = is_printable
        ) {
            children();
        }
    } else if (part == "back") {
        Back(
            width        = width, 
            is_printable = is_printable
        );
    } else {
        CaseAndBack(
            width        = width,
            part         = "case",
            is_printable = false
        ) {
            children();
        };
        CaseAndBack(
            width        = width,
            part         = "back",
            is_printable = false
        );
    }

    module Case(
        width = 50,
        is_printable
    ) {
        if (!is_undef(is_printable) && is_printable) {
            rotate(-90, VEC_Y) Part() children();
        } else {
            Part() children();
        }
        module Part() {
            difference() {
                BasisShape3d(width, radius);
                translate([-(top + panel_height)/2 - BIAS,0, width/2]) {
                    cube([top + panel_height+2*BIAS,
                          max(height,width) + 2*BIAS,
                          width + 2*BIAS], true);
                }
                difference() {
                    BasisShape3d(width, radius,-thickness);
                    Hook();
                    BottomHook();
                }
                translate([top - tan(45+asin(panel_height / height)/2), 0, height])
                rotate(asin(panel_height / height), VEC_Y) {
                    translate([panel_height/ 2,0]) rotate(90) children();
                }
                Screw();
            }
            translate([top,0]) rotate(-acos(panel_height / height), [0,1,0]) {
                translate([15,width/2 - thickness,1]) rotate(180) Pcb();
            }
            
            module BasisShape3d(width,r,o=0) {
                rotate(90, VEC_X) {
                   
                    minkowski() {
                        linear_extrude(width - 2*r, center = true) {
                            offset(-r) BasisShape2dRough();
                        }
                        sphere(r=r+o);
                    }
                }
                
                module BasisShape2dRough(){
                    difference() {
                        translate([-top-panel_height,0 ]) {
                            square([2*(top + panel_height), height]);
                        }
                        translate([top, height]) rotate(-asin(panel_height / height)) {
                            square(height+panel_height);
                        }
                        translate([top, 0]) rotate(-90 + acos(panel_height / height)) {
                            square(height+panel_height);
                        }
                    }
                }
            }
            
            module Pcb() {
                linear_extrude(4) mirror_copy(VEC_X) translate([7/2*2.54, 0]) difference() {
                    union() {
                        translate([0,7])circle(d=3+6*NOZZLE);
                        translate([-1.5-3*NOZZLE,0]) square([3+6*NOZZLE, 7]);
                    }
                    translate([0,7])circle(d=3);
                }
            }
        }
    }

    module Back(
        width = 50,
        is_printable
    ) {
        if (!is_undef(is_printable) && is_printable) {
            rotate(-90, VEC_Y) Part();
        } else {
            Part();
        }
        module Part() {
            difference() {
                rotate(90, VEC_Y) difference() {
                    intersection() {
                        linear_extrude(top-thickness) translate([-height / 2, 0])minkowski() {
                            square([height - 2*radius, width - 2*radius], true);
                            circle(r=radius- thickness-clearance);
                        }
                        union() {
                            cube([2*height, width, 2*bottom_thickness], true);
                            difference() {
                                cube([20,10,20], true);
                                rotate(-25, VEC_Y)translate([8.2,0]) cube([20,20,25], true);
                            }
                        }
                    }
                }
                
                q = width / 2 -12.5; 
                for (p=[[0,15], [-q,38],[q,38]]) translate([-1.5, p[0], p[1]]) {
                    rotate(90, VEC_Y) cylinder(d1=1, d2=1+bottom_thickness*3, h=bottom_thickness+2);
                }
                for (p=[[-15,15], [15,15]]) translate([0, p[0], p[1]]) {
                    rotate(90, VEC_Y) rotate_extrude() {
                        difference() {
                            translate([0,-1.5*bottom_thickness]) {
                                square([hole/2+bottom_thickness, 3*bottom_thickness]);
                            }
                            translate([hole/2+bottom_thickness,0]) circle(r=bottom_thickness);
                        }
                    }
                }
                translate([0,0,-clearance]) Hook();
                translate([0,0, clearance]) BottomHook();
                Screw();
            }
        }
    }

    module Hook() {
        hull() {
            translate([0,0,height]) {
                cube([2*hook_thickness_1, width, 2*hook_height], true);
            }
            translate([0,0,height+hook_height/2]) {
                cube([2*hook_thickness_2, width, hook_height], true);
            }
        }
    }
    
    module BottomHook() {
        cube([2*top, width, 2*screw_thickness], true);
    }
    
    module Screw() {
        translate([(top - tan(45+acos(panel_height / height)/2))/2,0]) {
            rotate_extrude() {
                translate([0,-.1])hull() {
                    square([2.8, 1]);
                    square([0.8, 3]);
                }
                translate([0,3.2])square([2,4]);
            }
            cylinder(d=3.2,h=15*2, center=true);
        }
    }
}