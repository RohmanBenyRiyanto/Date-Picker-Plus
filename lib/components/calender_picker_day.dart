// ignore_for_file: constant_identifier_names

part of date_picker_plus;

enum DayStyleType {
  E, // One letter (e.g., M, T, W)
  Eee, // Three letters (e.g., Mon, Tue, Wed)
  Complete, // Complete day name (e.g., Monday, Tuesday, Wednesday)
}

class DayStyle {
  final TextStyle? textStyle;
  final double dayHeaderHeight;
  final DayStyleType dayStyle;
  final Color backgroundColor;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;

  DayStyle({
    this.textStyle,
    double? dayHeaderHeight,
    DayStyleType? dayStyle,
    Color? backgroundColor,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
  })  : dayStyle = dayStyle ?? DayStyleType.E,
        dayHeaderHeight = dayHeaderHeight ?? 48.0,
        backgroundColor = backgroundColor ?? Colors.white;

  DayStyle copyWith({
    TextStyle? textStyle,
    double? dayHeaderHeight,
    DayStyleType? dayStyle,
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

/// Widget untuk menampilkan baris hari-hari pada Calender Picker
class CalenderPickerDay extends StatelessWidget {
  /// Konstruktor `CalenderPickerDay`.
  ///
  /// - Parameter [key] digunakan untuk mengidentifikasi widget ini.
  /// - Parameter [now] merupakan tanggal saat ini.
  /// - Parameter [styleDay] berisi konfigurasi untuk gaya penampilan hari dalam kalender.
  /// - Parameter [padding] memberikan jarak padding pada konten widget.
  /// - Parameter [firstDayOfWeek] menunjukkan hari pertama dalam seminggu (1 untuk Senin, 2 untuk Selasa, dst.). Default-nya adalah 1.
  const CalenderPickerDay({
    Key? key,
    required this.now,
    this.styleDay,
    this.padding,
    this.firstDayOfWeek = 1,
    this.locale,
  }) : super(key: key);

  /// Jarak padding pada konten widget.
  final EdgeInsets? padding;

  /// Konfigurasi untuk gaya penampilan hari dalam kalender.
  final DayStyle? styleDay;

  /// Tanggal saat ini.
  final DateTime now;

  /// Hari pertama dalam seminggu (1 untuk Senin, 2 untuk Selasa, dst.).
  final int firstDayOfWeek;

  /// Locale
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    // Jumlah hari dalam seminggu.
    const int daysInWeek = 7;

    // Jumlah hari sebelum hari pertama dalam seminggu.
    final int daysBeforeFirstDay =
        (now.weekday - firstDayOfWeek + daysInWeek) % daysInWeek;

    // Tanggal hari pertama dalam seminggu.
    final DateTime firstDay = now.subtract(Duration(days: daysBeforeFirstDay));

    return Container(
      padding: padding,
      height: styleDay?.dayHeaderHeight,
      width: MediaQuery.of(context).size.width,
      color: styleDay?.backgroundColor,
      child: Row(
        children: List.generate(
          daysInWeek,
          (index) {
            // Tanggal hari pada posisi [index].
            final DateTime day = firstDay.add(Duration(days: index));

            // Nama hari.
            String dayName = '';

            // Menentukan format nama hari berdasarkan [styleDay.dayStyle].
            switch (styleDay?.dayStyle) {
              case DayStyleType.E:
                dayName = DateFormat.E(locale).format(day).substring(0, 1);
                break;
              case DayStyleType.Eee:
                dayName = DateFormat.E(locale).format(day);
                break;
              case DayStyleType.Complete:
                dayName = DateFormat('EEEE', locale.toString()).format(day);
                break;
              default:
                dayName = DateFormat.E().format(day).substring(0, 1);
                break;
            }

            return Expanded(
              child: Center(
                child: Text(
                  dayName,
                  style: styleDay!.textStyle?.copyWith(
                        fontSize: styleDay!.fontSize,
                        fontWeight: styleDay!.fontWeight,
                      ) ??
                      const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16.0,
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
