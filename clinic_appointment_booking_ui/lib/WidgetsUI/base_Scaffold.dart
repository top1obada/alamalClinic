import 'package:clinic_appointment_booking_ui/WidgetsUI/drawer_ui.dart';
import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    super.key,
    this.title,
    this.titleWidget,
    required this.body,
    this.bottomNavigationBar,
  }) : assert(
         title != null || titleWidget != null,
         'Either title or titleWidget must be provided',
       );

  final String? title;
  final Widget? titleWidget;
  final Widget body;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      drawer: const BaseDrawer(),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget _buildTitle() {
    if (titleWidget != null) {
      return titleWidget!;
    } else {
      return Text(title!);
    }
  }
}
