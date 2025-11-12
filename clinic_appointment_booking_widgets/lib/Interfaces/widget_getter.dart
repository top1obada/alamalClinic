import 'package:flutter/widgets.dart';

abstract class WidgetGetter {
  Widget getWidget(Object value, Function(Object?)? onClick);
}
