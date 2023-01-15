use <TwoButtonsOneLed.scad>

TwoButtonsOneLedBack(
    is_printable = true
);

module TwoButtonsOneLedBack(
    is_printable = false
) {
    TwoButtonsOneLed("back", is_printable);
}
