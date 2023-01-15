use <CaseAndBack.scad>
use <Button.scad>

OneButton();

module OneButton(part, is_printable) {
    CaseAndBack(
        width        = 50,
        part         = part,
        is_printable = is_printable
    ) {
        Button();
    };
}
