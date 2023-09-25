part of date_picker_plus;

class CalenderPicker extends StatefulWidget {
  const CalenderPicker({
    Key? key,
    int? firstDayOfWeek,
    EdgeInsets? padding,
    EdgeInsetsGeometry? margin,
    double? monthHeaderHeight,
    bool? useWeekEnd,
    required this.startDate,
    required this.endDate,
    required this.initialDate,
    required this.currentDate,
    this.styleDay,
    this.styleHeader,
    this.onSubmitted,
    this.onCancelled,
    this.onDatePickerModeChange,
    this.height,
    this.limit,
    this.bottomStyle,
    this.locale,
  })  : firstDayOfWeek = firstDayOfWeek ?? 1,
        padding = padding ?? EdgeInsets.zero,
        margin = margin ?? EdgeInsets.zero,
        monthHeaderHeight = monthHeaderHeight ?? 48.0,
        useWeekEnd = useWeekEnd ?? false,
        super(key: key);

  final DateTime startDate;
  final DateTime endDate;
  final DateTime initialDate;
  final DateTime currentDate;
  final int firstDayOfWeek;
  final DayStyle? styleDay;
  final HeaderStyle? styleHeader;
  final EdgeInsets padding;
  final CalenderPickerLimit? limit;
  final EdgeInsetsGeometry margin;
  final double monthHeaderHeight;
  final BottomStyle? bottomStyle;
  final void Function()? onSubmitted;
  final void Function()? onCancelled;
  final double? height;
  final bool useWeekEnd;
  final Locale? locale;
  final ValueChanged<DateTime>? onDatePickerModeChange;

  @override
  State<CalenderPicker> createState() => _CalenderPickerState();
}

class _CalenderPickerState extends State<CalenderPicker> {
  late ItemScrollController _scrollController;
  late DateTime _selectedDate;
  late int _visibleMonths;
  final DateTime now = DateTime.now();
  late List<DateTime> _monthsList;
  late int currentDateIndex;
  int _selectedYear = 0;

  CalenderPickerLimit? get limit => widget.limit;
  bool isLimit = false;

  @override
  void initState() {
    super.initState();
    _visibleMonths = calculateVisibleMonths();
    _scrollController = ItemScrollController();
    _selectedDate = widget.currentDate;
    isLimit = _checkIfDateIsWithinLimit(_selectedDate);

    _monthsList = generateMonthsList();
    currentDateIndex = getCurrentDateIndex();
    _selectedYear = widget.currentDate.year;

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _scrollController.jumpTo(
          index: currentDateIndex,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _checkIfDateIsWithinLimit(DateTime date) {
    if (limit == null) {
      return true; // No limitation, all dates are selectable
    }

    if (limit!.minDate != null) {
      if (date.year < limit!.minDate!.year ||
          (date.year == limit!.minDate!.year &&
              date.month < limit!.minDate!.month) ||
          (date.year == limit!.minDate!.year &&
              date.month == limit!.minDate!.month &&
              date.day < limit!.minDate!.day)) {
        return false; // Date is before the minimum selectable date
      }
    }

    if (limit!.maxDate != null) {
      if (date.year > limit!.maxDate!.year ||
          (date.year == limit!.maxDate!.year &&
              date.month > limit!.maxDate!.month) ||
          (date.year == limit!.maxDate!.year &&
              date.month == limit!.maxDate!.month &&
              date.day > limit!.maxDate!.day)) {
        return false; // Date is after the maximum selectable date
      }
    }

    return true; // Date is within the selectable range
  }

  Future scrollToItem() async {
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  List<DateTime> generateMonthsList() {
    List<DateTime> monthsList = [];
    DateTime currentDate =
        DateTime.utc(widget.startDate.year, widget.startDate.month);
    while (currentDate.isBefore(widget.endDate) ||
        currentDate.isAtSameMomentAs(widget.endDate)) {
      monthsList.add(currentDate);
      currentDate = DateTime.utc(
        currentDate.year + (currentDate.month == 12 ? 1 : 0),
        (currentDate.month % 12) + 1,
      );
    }
    return monthsList;
  }

  int getCurrentDateIndex() {
    DateTime currentDate = widget.currentDate;
    for (int i = 0; i < _monthsList.length; i++) {
      if (_monthsList[i].year == currentDate.year &&
          _monthsList[i].month == currentDate.month) {
        return i;
      }
    }
    return -1;
  }

  int calculateEmptyCellsCount(int year, int month) {
    final firstDayOfMonth = DateTime(year, month, 1);
    int emptyCellsCount =
        (firstDayOfMonth.weekday - widget.firstDayOfWeek).toInt() % 7;
    return emptyCellsCount < 0 ? emptyCellsCount + 7 : emptyCellsCount;
  }

  int calculateVisibleMonths() {
    int months = widget.endDate.month - widget.startDate.month;
    int years = widget.endDate.year - widget.startDate.year;
    return (years * 12) + months + 1;
  }

  void updateSelectedDate(DateTime date) {
    final isDateWithinLimit = _checkIfDateIsWithinLimit(date);
    if (isDateWithinLimit) {
      // Check if useWeekEnd is enabled and disallow selecting Sundays
      if (widget.useWeekEnd && date.weekday == DateTime.sunday) {
        return;
      }

      setState(() {
        _selectedDate = date;
        if (widget.onDatePickerModeChange != null) {
          widget.onDatePickerModeChange!(_selectedDate);
        }
      });
    }
  }

  Color getColorBasedOnConditions({
    bool useWeekEnd = false,
    bool isWithinMonth = false,
    bool isSelected = false,
    bool thisDay = false,
    bool isLimit = false,
  }) {
    if (useWeekEnd) {
      return Colors.red; // Ganti dengan warna dari MaterialColor
    } else {
      if (isWithinMonth) {
        if (isSelected && thisDay && !isLimit) {
          return Colors.white; // Ganti dengan warna dari MaterialColor
        } else if (isSelected && !thisDay && !isLimit) {
          return Colors.white; // Ganti dengan warna dari MaterialColor
        } else if (thisDay && !isSelected && !isLimit) {
          return Theme.of(context)
              .colorScheme
              .primary; // Ganti dengan warna dari MaterialColor
        } else if (!thisDay && isSelected && !isLimit) {
          return Theme.of(context)
              .colorScheme
              .primary; // Ganti dengan warna dari MaterialColor
        } else if (thisDay && !isSelected && isLimit) {
          return Theme.of(context)
              .colorScheme
              .primary; // Ganti dengan warna dari MaterialColor
        } else if (!thisDay && !isSelected && isLimit) {
          return Colors.grey.shade200; // Ganti dengan warna dari MaterialColor
        } else {
          return Colors.black; // Ganti dengan warna dari MaterialColor
        }
      } else {
        return Colors.transparent; // Ganti dengan warna dari MaterialColor
      }
    }
  } // Fungsi untuk menggulir ke bulan saat ini

  void _scrollToCurrentDate() {
    final currentMonth = DateTime(_selectedYear, _selectedDate.month, 1);
    for (int i = 0; i < _monthsList.length; i++) {
      if (_monthsList[i].year == currentMonth.year &&
          _monthsList[i].month == currentMonth.month) {
        _scrollController.scrollTo(
          index: i,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? MediaQuery.of(context).size.height * 0.7,
      width: MediaQuery.of(context).size.width,
      margin: widget.margin,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          DatePickerHeader(
            selectedDate: _selectedDate,
            headerStyle: widget.styleHeader,
            locale: widget.locale,
          ),
          Divider(
            height: 0,
            color: Colors.grey.shade200,
            thickness: 1,
          ),
          YearPicker(
            year: _selectedYear,
            currentMonth: DateFormat.MMMM().format(_selectedDate),
            onYearIncrement: () {
              setState(
                () {
                  _selectedYear++;
                  if (_selectedYear <= widget.endDate.year) {
                    _selectedDate = DateTime(
                      _selectedYear,
                      _selectedDate.month,
                      _selectedDate.day,
                    );
                    _scrollToCurrentDate();
                  } else {
                    // Tahun yang dipilih melewati endDate, kembalikan ke endDate
                    _selectedYear = widget.endDate.year;
                  }
                },
              );
            },
            onYearDecrement: () {
              setState(
                () {
                  _selectedYear--;
                  if (_selectedYear >= widget.startDate.year) {
                    _selectedDate = DateTime(
                      _selectedYear,
                      _selectedDate.month,
                      _selectedDate.day,
                    );
                    _scrollToCurrentDate();
                  } else {
                    // Tahun yang dipilih melewati startDate, kembalikan ke startDate
                    _selectedYear = widget.startDate.year;
                  }
                },
              );
            },
          ),
          CalenderPickerDay(
            now: now,
            padding: widget.padding,
            firstDayOfWeek: widget.firstDayOfWeek,
            styleDay: widget.styleDay,
            locale: widget.locale,
          ),
          Expanded(
            child: ScrollablePositionedList.builder(
              itemScrollController: _scrollController,
              itemCount: _visibleMonths,
              itemBuilder: (context, index) {
                DateTime month = DateTime(
                  widget.startDate.year + (index ~/ 12),
                  widget.startDate.month + (index % 12),
                  1,
                );

                int daysInMonth = DateTime(month.year, month.month + 1, 0).day;

                return Container(
                  alignment: Alignment.bottomCenter,
                  color: Theme.of(context).colorScheme.onPrimary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CalendarPickerMonth(
                        month: month,
                        monthHeaderHeight: widget.monthHeaderHeight,
                        margin: widget.padding,
                        locale: widget.locale,
                      ),
                      Container(
                        padding: widget.padding,
                        color: Theme.of(context).colorScheme.onPrimary,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: daysInMonth +
                              calculateEmptyCellsCount(month.year, month.month),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            mainAxisExtent: 48,
                          ),
                          itemBuilder: (context, index) {
                            if (index <
                                calculateEmptyCellsCount(
                                  month.year,
                                  month.month,
                                )) {
                              return Container(); // Render empty cells before the first day of the month
                            }

                            int day = index +
                                1 -
                                calculateEmptyCellsCount(
                                    month.year, month.month);
                            DateTime currentDate =
                                DateTime.utc(month.year, month.month, day);

                            bool isSelected =
                                _selectedDate.year == currentDate.year &&
                                    _selectedDate.month == currentDate.month &&
                                    _selectedDate.day == currentDate.day;

                            bool thisDay = now.year == currentDate.year &&
                                now.month == currentDate.month &&
                                now.day == currentDate.day;

                            bool isOutOfRange = currentDate.isBefore(widget
                                    .startDate
                                    .subtract(const Duration(days: 1))) ||
                                currentDate.isAfter(widget.endDate
                                    .add(const Duration(days: 1)));

                            bool isWithinMonth = day > 0 && day <= daysInMonth;

                            bool colorLimit = isOutOfRange ||
                                !isWithinMonth ||
                                !_checkIfDateIsWithinLimit(currentDate);

                            bool useWeekEnds = widget.useWeekEnd &&
                                (currentDate.weekday == DateTime.sunday);

                            Color cellColor = getColorBasedOnConditions(
                              isWithinMonth: isWithinMonth,
                              isSelected: isSelected,
                              thisDay: thisDay,
                              isLimit: colorLimit,
                              useWeekEnd: useWeekEnds,
                            );

                            return GestureDetector(
                              onTap: (isLimit || !isWithinMonth || isOutOfRange)
                                  ? () {
                                      if (!isOutOfRange) {
                                        updateSelectedDate(currentDate);
                                      }
                                    }
                                  : null, // Disable onTap if the date is outside the limit,
                              child: Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : (thisDay
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Colors.transparent),
                                    width: 1,
                                  ),
                                  color: isWithinMonth
                                      ? (isSelected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null)
                                      : Colors.transparent,
                                ),
                                child: Center(
                                  child: Text(
                                    isWithinMonth ? day.toString() : '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: cellColor,
                                        ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          CalenderPickerBottom(
            bottomStyle: widget.bottomStyle,
            onSubmitted: widget.onSubmitted,
            onCancelled: widget.onCancelled,
          ),
        ],
      ),
    );
  }
}
