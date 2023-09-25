part of date_picker_plus;

class DatePickerHeader extends StatelessWidget {
  DatePickerHeader({
    Key? key,
    this.selectedDate,
    this.selectedStartDate,
    this.selectedEndDate,
    this.locale,
    HeaderStyle? headerStyle,
  })  : headerStyle = headerStyle ?? HeaderStyle(),
        super(key: key);

  final HeaderStyle headerStyle;
  final DateTime? selectedDate;
  final DateTime? selectedStartDate;
  final DateTime? selectedEndDate;
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          headerStyle.backgroundColor ?? Theme.of(context).colorScheme.primary,
      margin: headerStyle.margin,
      padding: headerStyle.padding,
      height: headerStyle.height,
      decoration: headerStyle.decoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: headerStyle.crossAxisAlignment,
              mainAxisAlignment: headerStyle.mainAxisAlignment,
              children: [
                Text(
                  headerStyle.title,
                  style: headerStyle.titleTextStyle ??
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                ),
                const SizedBox(height: 28.0),
                Text(
                  selectedStartDate == null
                      ? (selectedDate != null
                          ? DateFormat(
                              // Mon, Jan 20
                              'EEE, MMM dd',
                            ).format(selectedDate!)
                          : '')
                      : selectedEndDate == null
                          ? DateFormat(
                              'EEE, MMM dd',
                            ).format(selectedStartDate!)
                          : "${DateFormat(
                              'EEE, MMM dd',
                            ).format(selectedStartDate!)} -  ${DateFormat(
                              'EEE, MMM dd',
                            ).format(selectedEndDate!)}",
                  style: headerStyle.dateTextStyle ??
                      Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
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
            visible: true,
            child: Transform(
              transform: Matrix4.translationValues(
                0.0,
                6,
                0.0,
              ),
              child: IconButton(
                splashRadius: 24.0,
                icon: Icon(
                  Icons.mode_edit_outlined,
                  color: headerStyle.editButtonColor ?? Colors.white,
                ),
                tooltip: headerStyle.editButtonTooltip ?? 'Edit',
                onPressed: () {
                  debugPrint('Edit button pressed');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
