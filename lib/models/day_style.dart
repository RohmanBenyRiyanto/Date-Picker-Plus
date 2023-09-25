part of date_picker_plus;

class DayStyle {
  final TextStyle? textStyle;
  final double dayHeaderHeight;
  final String dayStyle;
  final Color? backgroundColor;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;

  DayStyle({
    this.textStyle,
    double? dayHeaderHeight,
    String? dayStyle,
    this.backgroundColor,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
  })  : dayStyle = dayStyle ?? DayStyleType.E,
        dayHeaderHeight = dayHeaderHeight ?? 48.0;

  DayStyle copyWith({
    TextStyle? textStyle,
    double? dayHeaderHeight,
    String? dayStyle,
    Color? backgroundColor,
    String? fontFamily,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return DayStyle(
      textStyle: textStyle ?? this.textStyle,
      dayHeaderHeight: dayHeaderHeight ?? this.dayHeaderHeight,
      dayStyle: dayStyle ?? this.dayStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
    );
  }
}
