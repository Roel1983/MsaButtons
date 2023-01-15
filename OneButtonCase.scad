use <OneButton.scad>

OneButtonCase(
    is_printable = true
);

module OneButtonCase(
    is_printable = false
) {
    OneButton("case", is_printable);
}
