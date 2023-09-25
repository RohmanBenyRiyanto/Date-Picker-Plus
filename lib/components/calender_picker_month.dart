part of date_picker_plus;

class CalendarPickerMonth extends StatelessWidget {
  const CalendarPickerMonth({
    super.key,
    required this.month,
    this.monthHeaderHeight = 48,
    this.margin,
  });

  final double monthHeaderHeight;
  final DateTime month;
  final EdgeInsets? margin;

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
          '${DateFormat.MMMM('id_ID').format(month)} ${DateFormat.y('id_ID').format(month)}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                locale: const Locale('id', 'ID'),
              ),
        ),
      ),
    );
  }
}
