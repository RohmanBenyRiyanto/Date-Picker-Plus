part of date_picker_plus;

class BottomStyle {
  final TextStyle? buttonTextStyle;
  final EdgeInsetsGeometry padding;
  final Color? buttonColor;
  final String? cancelButtonText;
  final String? okButtonText;

  BottomStyle({
    this.buttonTextStyle,
    this.cancelButtonText,
    this.okButtonText,
    this.buttonColor,
    EdgeInsetsGeometry? padding,
  }) : padding = padding ?? const EdgeInsets.symmetric(horizontal: 16);
}

class CalenderPickerBottom extends StatelessWidget {
  CalenderPickerBottom({
    Key? key,
    this.onSubmitted,
    this.onCancelled,
    BottomStyle? bottomStyle,
  })  : bottomStyle = bottomStyle ?? BottomStyle(),
        super(key: key);

  final BottomStyle bottomStyle;
  final void Function()? onSubmitted;
  final void Function()? onCancelled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: bottomStyle.padding,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            onPressed: onCancelled,
            child: Text(
              bottomStyle.cancelButtonText ?? Strings.getCancel(context),
              style: bottomStyle.buttonTextStyle ??
                  Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 16),
          TextButton(
            onPressed: onSubmitted,
            child: Text(
              bottomStyle.okButtonText ?? Strings.getOk(context),
              style: bottomStyle.buttonTextStyle ??
                  Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
