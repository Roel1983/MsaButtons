$fn=64;

part(
    // "one-button", "two-buttons-one-led"
    "one-button",
    // "back", "case"
    "case");

height = 50;
panel_height = 30;
top = 10;
radius = 5;
thickness = 2;

hook_height      = 3.5;
hook_thickness_1 = 1.0;
hook_thickness_2 = 3.0;

screw_thickness = 3.0;

bottom_thickness= 2.5;
hole = 5.2;

clearance = 0.2;

BIAS=0.1;
X_AXIS=[1,0,0];
Y_AXIS=[0,1,0];

NOZZLE = 0.4;

module part(model, part) {
    if (model == "one-button") {
        width = 50;
        if (part == "case") {
            case(width) {
                button();
            }
        } else if (part == "back") {
            back(width);
        }
    } else if (model == "two-buttons-one-led") {
        width = 70;
        if (part == "case") {
            case(width) {
                translate([-17,0]) button();
                translate([ 17,0]) button();
                translate([0, 5]) led_5mm();
            }
        } else if (part == "back") {
            back(width);
        }
    }
}

module button() {
    linear_extrude(36, center=true) intersection() {
        circle(d=16.5);
        square([16.5,15], true);
    }
}

module led_5mm() {
    cylinder(d=6.6, h=10, center=true);
}

module back(width) {
    difference() {
        rotate(90, Y_AXIS) difference() {
            intersection() {
                linear_extrude(top-thickness) translate([-height / 2, 0])minkowski() {
                    square([height - 2*radius, width - 2*radius], true);
                    circle(r=radius- thickness-clearance);
                }
                union() {
                    cube([2*height, width, 2*bottom_thickness], true);
                    difference() {
                        cube([20,10,20], true);
                        rotate(-25, Y_AXIS)translate([8.2,0]) cube([20,20,25], true);
                    }
                }
            }
        }
        
        q = width / 2 -12.5; 
        for (p=[[0,15], [-q,38],[q,38]]) translate([-1.5, p[0], p[1]]) {
            rotate(90, Y_AXIS) cylinder(d1=1, d2=1+bottom_thickness*3, h=bottom_thickness+2);
        }
        for (p=[[-15,15], [15,15]]) translate([0, p[0], p[1]]) {
            rotate(90, Y_AXIS) rotate_extrude() {
                difference() {
                    translate([0,-1.5*bottom_thickness]) {
                        square([hole/2+bottom_thickness, 3*bottom_thickness]);
                    }
                    translate([hole/2+bottom_thickness,0]) circle(r=bottom_thickness);
                }
            }
        }
        translate([0,0,-clearance]) hook(width);
        translate([0,0, clearance]) bottom_hook(width);
        screw();
    }
}

module case(width) {
    difference() {
        basis_shape_3d(width, radius);
        translate([-(top + panel_height)/2 - BIAS,0, width/2]) {
            cube([top + panel_height+2*BIAS,
                  max(height,width) + 2*BIAS,
                  width + 2*BIAS], true);
        }
        difference() {
            basis_shape_3d(width, radius,-thickness);
            hook(width);
            bottom_hook(width);
        }
        translate([top - tan(45+asin(panel_height / height)/2), 0, height])
        rotate(asin(panel_height / height), Y_AXIS) {
            translate([panel_height/ 2,0]) rotate(90) children();
        }
        screw();
    }
    translate([top,0]) rotate(-acos(panel_height / height), [0,1,0]) {
        translate([15,width/2 - thickness,1]) rotate(180) pcb();
    }
}

module pcb() {
    linear_extrude(4) mirror_copy() translate([7/2*2.54, 0]) difference() {
        union() {
            translate([0,7])circle(d=3+6*NOZZLE);
            translate([-1.5-3*NOZZLE,0]) square([3+6*NOZZLE, 7]);
        }
        translate([0,7])circle(d=3);
    }
}

module mirror_copy(vec=undef) {
    children();
    mirror(vec) children();
}

module hook(width) {
    hull() {
        translate([0,0,height]) {
            cube([2*hook_thickness_1, width, 2*hook_height], true);
        }
        translate([0,0,height+hook_height/2]) {
            cube([2*hook_thickness_2, width, hook_height], true);
        }
    }
}

module bottom_hook(width) {
    cube([2*top, width, 2*screw_thickness], true);
}


module screw() {
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

module basis_shape_3d(width,r,o=0) {
    rotate(90, X_AXIS) {
       
        minkowski() {
            linear_extrude(width - 2*r, center = true) {
                offset(-r) basis_shape_2d_rough();
            }
            sphere(r=r+o);
        }
    }
}

module basis_shape_2d_rough(){
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


