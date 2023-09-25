part of date_picker_plus;

class DayStyleType {
  static const E = 'E'; // One letter (e.g., M, T, W)
  // ignore: constant_identifier_names
  static const Eee = 'Eee'; // Three letters (e.g., Mon, Tue, Wed)
  // ignore: constant_identifier_names
  static const Complete =
      'Complete'; // Complete day name (e.g., Monday, Tuesday, Wednesday)
}

class DefaultDayStyle extends DayStyle {
  DefaultDayStyle()
      : super(
          textStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 16.0,
          ),
        );
}

class CalenderPickerDay extends StatelessWidget {
  final EdgeInsets? padding;
  final DayStyle? styleDay;
  final DateTime now;
  final int firstDayOfWeek;
  final Locale? locale;

  const CalenderPickerDay({
    Key? key,
    required this.now,
    this.styleDay,
    this.padding,
    this.firstDayOfWeek = 1,
    this.locale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int daysInWeek = 7;
    final int daysBeforeFirstDay =
        (now.weekday - firstDayOfWeek + daysInWeek) % daysInWeek;
    final DateTime firstDay = now.subtract(Duration(days: daysBeforeFirstDay));

    return Container(
      padding: padding,
      height: styleDay?.dayHeaderHeight,
      width: MediaQuery.of(context).size.width,
      color:
          styleDay?.backgroundColor ?? Theme.of(context).colorScheme.background,
      child: Row(
        children: List.generate(
          daysInWeek,
          (index) {
            final DateTime day = firstDay.add(Duration(days: index));
            String dayName = '';

            switch (styleDay?.dayStyle) {
              case DayStyleType.E:
                dayName = DateFormat.E().format(day).substring(0, 1);
                break;
              case DayStyleType.Eee:
                dayName = DateFormat.E().format(day);
                break;
              case DayStyleType.Complete:
                dayName = DateFormat('EEEE').format(day);
                break;
              default:
                dayName = DateFormat.E().format(day).substring(0, 1);
                break;
            }

            return Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    dayName,
                    style: styleDay?.textStyle?.copyWith(
                          fontSize: styleDay!.fontSize,
                          fontWeight: styleDay!.fontWeight,
                        ) ??
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
