part of date_picker_plus;

class CalendarPickerMonth extends StatelessWidget {
  const CalendarPickerMonth({
    super.key,
    required this.month,
    this.monthHeaderHeight = 48,
    this.margin,
    this.locale,
  });

  final double monthHeaderHeight;
  final DateTime month;
  final EdgeInsets? margin;
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: margin,
      color: Theme.of(context).colorScheme.onPrimary,
      height: monthHeaderHeight,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Text(
          '${DateFormat.MMMM(locale).format(month)} ${DateFormat.y(locale).format(month)}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                locale: locale,
              ),
        ),
      ),
    );
  }
}
