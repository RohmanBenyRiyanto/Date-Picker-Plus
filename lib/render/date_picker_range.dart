part of date_picker_plus;

class CalenderPickerRange extends StatefulWidget {
  const CalenderPickerRange({
    Key? key,
    int? firstDayOfWeek,
    EdgeInsets? padding,
    EdgeInsetsGeometry? margin,
    double? monthHeaderHeight,
    required this.startDate,
    required this.endDate,
    required this.initialDate,
    required this.initialStartDate,
    required this.initialEndDate,
    this.styleDay,
    this.styleHeader,
    this.onDatePickerModeChange,
    this.onSubmitted,
    this.onCancelled,
    this.limit,
    this.height,
    this.bottomStyle,
    this.locale,
  })  : firstDayOfWeek = firstDayOfWeek ?? 1,
        padding = padding ?? EdgeInsets.zero,
        margin = margin ?? EdgeInsets.zero,
        monthHeaderHeight = monthHeaderHeight ?? 48.0,
        super(key: key);

  final double? height;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime initialDate;
  final DateTime initialStartDate;
  final DateTime initialEndDate;
  final CalenderPickerLimit? limit;
  final int firstDayOfWeek;
  final DayStyle? styleDay;
  final HeaderStyle? styleHeader;
  final EdgeInsets padding;
  final BottomStyle? bottomStyle;
  final EdgeInsetsGeometry margin;
  final double monthHeaderHeight;
  final void Function()? onSubmitted;
  final void Function()? onCancelled;
  final void Function(DateTime startDate, DateTime? endDate)?
      onDatePickerModeChange;
  final Locale? locale;

  @override
  State<CalenderPickerRange> createState() => _CalenderPickerRangeState();
}

class _CalenderPickerRangeState extends State<CalenderPickerRange> {
  late ItemScrollController _scrollController;
  late DateTime _selectedStartDate;
  late DateTime? _selectedEndDate;
  late int _visibleMonths;
  final DateTime now = DateTime.now();
  late List<DateTime> _monthsList;
  late int startDateIndex;

  final currentDateKey = GlobalKey();

  CalenderPickerLimit? get limit => widget.limit;
  bool isLimit = false;

  @override
  void initState() {
    super.initState();
    _visibleMonths = calculateVisibleMonths();
    _scrollController = ItemScrollController();
    _selectedStartDate = widget.initialStartDate;
    _selectedEndDate = widget.initialEndDate;

    isLimit = _checkIfDateIsWithinLimit(
      _selectedStartDate,
      _selectedEndDate,
    );

    _monthsList = generateMonthsList();
    startDateIndex = getCurrentDateIndex();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        _scrollController.jumpTo(
          index: startDateIndex,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool _checkIfDateIsWithinLimit(DateTime startDate, [DateTime? endDate]) {
    if (limit == null) {
      return true;
    }

    DateTime date = endDate ??
        startDate; // Use endDate if provided, otherwise use startDate

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

  List<DateTime> generateMonthsList() {
    List<DateTime> monthsList = [];
    DateTime currentDate = widget.startDate;
    while (currentDate.isBefore(widget.endDate) ||
        currentDate.isAtSameMomentAs(widget.endDate)) {
      monthsList.add(currentDate);
      currentDate = DateTime(
        currentDate.year + (currentDate.month == 12 ? 1 : 0),
        (currentDate.month % 12) + 1,
        1,
      );
    }
    return monthsList;
  }

  int getCurrentDateIndex() {
    return _monthsList.indexWhere(
      (element) =>
          element.year == widget.initialStartDate.year &&
          element.month == widget.initialStartDate.month,
    );
  }

  int calculateEmptyCellsCount(DateTime month) {
    int emptyCellsCount = month.weekday - widget.firstDayOfWeek;
    if (emptyCellsCount < 0) {
      emptyCellsCount += 7;
    }
    return emptyCellsCount;
  }

  int calculateVisibleMonths() {
    int months = widget.endDate.month - widget.startDate.month;
    int years = widget.endDate.year - widget.startDate.year;
    return (years * 12) + months + 1;
  }

  void updateSelectedDate(DateTime date) {
    if (_checkIfDateIsWithinLimit(date)) {
      if (_selectedEndDate == null) {
        _selectedStartDate = date;
        _selectedEndDate = null;
      } else if (_selectedEndDate == null) {
        if (date.isBefore(_selectedStartDate)) {
          _selectedStartDate = date;
        } else if (date.isAfter(_selectedStartDate)) {
          _selectedEndDate = date;
        } else if (date.isAtSameMomentAs(_selectedStartDate)) {
          _selectedStartDate = date;
          _selectedEndDate = null;
        }
      } else if (_selectedEndDate != null) {
        _selectedStartDate = date;
        _selectedEndDate = null;
      }

      if (_selectedEndDate != null) {
        widget.onDatePickerModeChange
            ?.call(_selectedStartDate, _selectedEndDate);
      }
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
      return Colors.red.shade400; // Ganti dengan warna dari MaterialColor
    } else {
      if (isWithinMonth) {
        if (isSelected && thisDay && !isLimit) {
          return Colors.white; // Ganti dengan warna dari MaterialColor
        } else if (isSelected && !thisDay && !isLimit) {
          return Colors.white; // Ganti dengan warna dari MaterialColor
        } else if (thisDay && !isSelected && !isLimit) {
          return Colors.blue; // Ganti dengan warna dari MaterialColor
        } else if (!thisDay && isSelected && !isLimit) {
          return Colors.blue; // Ganti dengan warna dari MaterialColor
        } else if (thisDay && !isSelected && isLimit) {
          return Colors.blue; // Ganti dengan warna dari MaterialColor
        } else if (!thisDay && !isSelected && isLimit) {
          return Colors.grey.shade200; // Ganti dengan warna dari MaterialColor
        } else {
          return Colors.black; // Ganti dengan warna dari MaterialColor
        }
      } else {
        return Colors.transparent; // Ganti dengan warna dari MaterialColor
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          DatePickerHeader(
            selectedStartDate: _selectedStartDate,
            selectedEndDate: _selectedEndDate,
            headerStyle: widget.styleHeader,
            locale: widget.locale,
          ),
          Divider(
            height: 0,
            color: Colors.grey.shade200,
            thickness: 1,
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
                  key: index == startDateIndex ? currentDateKey : null,
                  color: Theme.of(context).colorScheme.onPrimary,
                  child: Column(
                    children: [
                      CalendarPickerMonth(
                        margin: widget.padding,
                        month: month,
                        monthHeaderHeight: widget.monthHeaderHeight,
                        locale: widget.locale,
                      ),
                      Container(
                        padding: widget.padding,
                        color: Theme.of(context).colorScheme.onPrimary,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              daysInMonth + calculateEmptyCellsCount(month),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 8,
                            mainAxisExtent: 48,
                          ),
                          itemBuilder: (context, index) {
                            if (index < calculateEmptyCellsCount(month)) {
                              // Render empty cells before the first day of the month
                              return Container();
                            }

                            int day =
                                index + 1 - calculateEmptyCellsCount(month);

                            DateTime currentDate = DateTime(
                              month.year,
                              month.month,
                              day,
                            );

                            DateTime endDate =
                                DateTime(month.year, month.month, day);

                            bool isStartDate = _selectedStartDate.year ==
                                    currentDate.year &&
                                _selectedStartDate.month == currentDate.month &&
                                _selectedStartDate.day == currentDate.day;

                            bool isEndDate = _selectedEndDate != null &&
                                _selectedEndDate!.year == currentDate.year &&
                                _selectedEndDate!.month == currentDate.month &&
                                _selectedEndDate!.day == currentDate.day;

                            bool isRangeOfDates() {
                              if (_selectedEndDate == null) {
                                return false;
                              } else if (isStartDate || isEndDate) {
                                return currentDate
                                        .isAfter(_selectedStartDate) &&
                                    currentDate.isBefore(_selectedEndDate!);
                              } else {
                                return currentDate
                                        .isAfter(_selectedStartDate) &&
                                    currentDate.isBefore(_selectedEndDate!);
                              }
                            }

                            bool thisDay = now.year == currentDate.year &&
                                now.month == currentDate.month &&
                                now.day == currentDate.day;

                            bool isOutOfRange =
                                currentDate.isBefore(widget.startDate) ||
                                    endDate.isAfter(widget.endDate);

                            bool isWithinMonth = day > 0 && day <= daysInMonth;

                            bool colorLimit = isOutOfRange ||
                                !isWithinMonth ||
                                !_checkIfDateIsWithinLimit(currentDate) ||
                                (!_checkIfDateIsWithinLimit(
                                        _selectedStartDate, currentDate) &&
                                    !_checkIfDateIsWithinLimit(
                                        currentDate, _selectedEndDate));

                            Color cellColor = getColorBasedOnConditions(
                              isWithinMonth: isWithinMonth,
                              isSelected: isStartDate || isEndDate,
                              thisDay: thisDay,
                              isLimit: colorLimit,
                            );

                            return Container(
                              decoration: BoxDecoration(
                                color: isRangeOfDates()
                                    // ? AppColors.primary.shade100
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context).colorScheme.onPrimary,
                                gradient: isStartDate
                                    ? _selectedEndDate == null
                                        ? null
                                        : LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                            ],
                                          )
                                    : isEndDate
                                        ? LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ],
                                          )
                                        : null,
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(
                                    isStartDate ? 24 : 0,
                                  ),
                                  right: Radius.circular(
                                    isEndDate ? 24 : 0,
                                  ),
                                ),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (!isOutOfRange) {
                                    setState(
                                      () {
                                        updateSelectedDate(currentDate);
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isStartDate || isEndDate
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: thisDay
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.transparent,
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      isWithinMonth ? day.toString() : '',
                                      // style: AppText.bodyLargeRegular.copyWith(
                                      //   color: cellColor,
                                      // ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: cellColor,
                                          ),
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
