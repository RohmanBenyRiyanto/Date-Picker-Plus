part of date_picker_plus;

class HeaderStyle {
  final Color? backgroundColor;
  final double? height;
  final TextStyle? titleTextStyle;
  final TextStyle? dateTextStyle;
  final String? editButtonIcon;
  final Color? editButtonColor;
  final String? editButtonTooltip;
  final String title;
  final String? note;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BoxDecoration? decoration;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  HeaderStyle({
    this.titleTextStyle,
    this.dateTextStyle,
    this.editButtonIcon,
    this.editButtonColor,
    this.editButtonTooltip,
    this.note,
    Color? backgroundColor,
    this.height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    String? title,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.decoration,
  })  : margin = margin ?? EdgeInsets.zero,
        padding = padding ?? const EdgeInsets.all(16.0),
        title = title ?? 'Select Date',
        // Check if decoration is not null, set backgroundColor to null
        backgroundColor = decoration != null ? null : backgroundColor,
        assert(
            decoration == null || backgroundColor == null,
            'Cannot provide both a color and a decoration\n'
            'To have a background color, set "color" to something\n'
            'To have a custom decoration, set "decoration" to something');
}
