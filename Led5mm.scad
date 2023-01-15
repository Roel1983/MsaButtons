$fn = 32;

Led5mm();

module Led5mm() {
    translate([  0, 5]) {
        cylinder(d=6.6, h=10, center=true);
    }
}
