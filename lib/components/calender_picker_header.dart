part of date_picker_plus;

class HeaderStyle {
  final Color backgroundColor;
  final double headerHeight;
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
    double? headerHeight,
    EdgeInsets? padding,
    EdgeInsets? margin,
    String? title,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.decoration,
  })  : backgroundColor = backgroundColor ?? const Color(0xFF025EED),
        headerHeight = headerHeight ?? 72.0,
        margin = margin ?? EdgeInsets.zero,
        padding = padding ?? EdgeInsets.zero,
        title = title ?? 'Pilih Tanggal',
        assert(
            decoration == null || backgroundColor == null,
            'Cannot provide both a color and a decoration\n'
            'To have a background color, set "color" to something\n'
            'To have a custom decoration, set "decoration" to something');
}

class CalenderPickerHeader extends StatelessWidget {
  CalenderPickerHeader({
    Key? key,
    this.selectedDate,
    this.selectedStartDate,
    this.selectedEndDate,
    HeaderStyle? headerStyle,
  })  : headerStyle = headerStyle ?? HeaderStyle(),
        super(key: key);

  final HeaderStyle headerStyle;
  final DateTime? selectedDate;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: headerStyle.backgroundColor,
      margin: headerStyle.margin,
      padding: headerStyle.padding,
      height: headerStyle.headerHeight,
      decoration: headerStyle.decoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: headerStyle.crossAxisAlignment,
              mainAxisAlignment: headerStyle.mainAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  headerStyle.title,
                  style: headerStyle.titleTextStyle ??
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  selectedStartDate == null
                      ? (selectedDate != null
                          ? DateFormat('dd MMMM yyyy', 'id_ID')
                              .format(selectedDate!)
                          : '')
                      : selectedEndDate == null
                          ? DateFormat('MMM dd', 'id_ID')
                              .format(selectedStartDate!)
                          : "${DateFormat('MMM dd', 'id_ID').format(selectedStartDate!)} -  ${DateFormat('MMM dd', 'id_ID').format(selectedEndDate!)}",
                  style: headerStyle.dateTextStyle ??
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                ),
                Visibility(
                  visible: headerStyle.note != null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4.0),
                      Text(
                        headerStyle.note ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Visibility(
            visible: false,
            child: Transform(
              transform: Matrix4.translationValues(
                0.0,
                12,
                0.0,
              ),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.edit,
                  color: headerStyle.editButtonColor ?? Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
