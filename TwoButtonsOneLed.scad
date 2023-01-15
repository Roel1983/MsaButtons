use <CaseAndBack.scad>
use <Button.scad>
use <Led5mm.scad>

TwoButtonsOneLed();

module TwoButtonsOneLed(part, is_printable) {
    CaseAndBack(
        width        = 70,
        part         = part,
        is_printable = is_printable
    ) {
        translate([-17, 0]) Button();
        translate([  0, 0]) Led5mm();
        translate([ 17, 0]) Button();
    };
}
