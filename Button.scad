$fn = 64;

Button();

module Button() {
    linear_extrude(36, center=true) intersection() {
        circle(d=16.5);
        square([16.5,15], true);
    }
}