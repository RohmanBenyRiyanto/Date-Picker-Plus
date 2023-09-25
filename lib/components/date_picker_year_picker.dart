part of date_picker_plus;

class YearPicker extends StatelessWidget {
  final int year;
  final String? currentMonth;
  final VoidCallback onYearIncrement;
  final VoidCallback onYearDecrement;
  final EdgeInsets? padding;

  const YearPicker({
    super.key,
    this.padding,
    this.currentMonth = '',
    required this.year,
    required this.onYearIncrement,
    required this.onYearDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 4.0,
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$currentMonth $year',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: onYearDecrement,
                splashRadius: 20.0,
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 16.0,
                ),
              ),
              IconButton(
                onPressed: onYearIncrement,
                splashRadius: 20.0,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 16.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
