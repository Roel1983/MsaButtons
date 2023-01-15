use <TwoButtonsOneLed.scad>

TwoButtonsOneLedCase(
    is_printable = true
);

module TwoButtonsOneLedCase(
    is_printable = false
) {
    TwoButtonsOneLed("case", is_printable);
}