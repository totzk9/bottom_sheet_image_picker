part of bottom_sheet_image_picker;

///[PickerDecoration] is used for decorating the UI
class PickerDecoration {
  ///Widget that will work as back button in picker
  Widget? cancelIcon;

  ///Blur amount on select media
  double blurStrength;

  ///assign number of Columns of Media Grid
  int columnCount;

  ///Album title text style
  TextStyle? albumTitleStyle;

  ///Album text text style
  TextStyle? albumTextStyle;

  ///Album's media count text style
  TextStyle? albumCountTextStyle;

  ///text of select button
  String completeText;

  ///text style of select button
  TextStyle? completeTextStyle;

  ///style of select button
  ButtonStyle? completeButtonStyle;

  ///loading widget to be used as media place holder until media loads
  Widget? loadingWidget;

  ///PickerDecoration constructor to be used for decorating the UI
  PickerDecoration({
    this.cancelIcon,
    this.columnCount = 3,
    this.blurStrength = 10,
    this.albumTitleStyle,
    this.completeText = 'Continue',
    this.completeTextStyle,
    this.completeButtonStyle,
    this.loadingWidget,
    this.albumTextStyle,
    this.albumCountTextStyle,
  });
}
