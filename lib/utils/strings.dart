part of date_picker_plus;

class Strings {
  static String cancel = 'Batal';
  static String ok = 'OK';

  static String getCancel(BuildContext context) {
    return Intl.message(
      cancel,
      name: 'getCancel',
      locale: Localizations.localeOf(context).toString(),
    );
  }

  static String getOk(BuildContext context) {
    return Intl.message(
      ok,
      name: 'getOk',
      locale: Localizations.localeOf(context).toString(),
    );
  }
}
