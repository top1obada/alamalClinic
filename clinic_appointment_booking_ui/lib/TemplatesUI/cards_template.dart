import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart';
import 'package:clinic_appointment_booking_widgets/Interfaces/widget_getter.dart';
import 'package:flutter/material.dart';

class CardsTemplate extends StatelessWidget {
  const CardsTemplate({
    super.key,
    required this.isLoaded,
    required this.isFinished,
    required this.values,
    required this.widgetGetter,
    required this.lineLength,
    this.onCardClick,
    this.scrollController,
    this.showEndSection = true,
  });

  final WidgetGetter widgetGetter;
  final ScrollController? scrollController;
  final bool isLoaded;
  final bool isFinished;
  final List? values;
  final Function(Object?)? onCardClick;
  final int lineLength;
  final bool showEndSection;

  @override
  Widget build(BuildContext context) {
    if (values == null) {
      if (!isLoaded) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Center(
          child: Text(
            'هناك خطأ ما ${Errors.errorMessage}',
            style: const TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
            textDirection: TextDirection.rtl,
          ),
        );
      }
    }

    if (values!.isEmpty) {
      return Center(
        child: Text(
          'لا توجد بيانات',
          style: const TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
          textDirection: TextDirection.rtl,
        ),
      );
    }

    final totalRows = (values!.length / lineLength).ceil();

    return ListView.builder(
      controller: scrollController,
      itemCount: totalRows + 1,
      itemBuilder: (context, index) {
        if (index == totalRows) {
          if (showEndSection) {
            if (isFinished) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'لقد وصلت إلى نهاية المحتوى',
                  style: const TextStyle(fontSize: 16, fontFamily: 'Tajawal'),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }
          } else {
            return const SizedBox(height: 1);
          }
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / lineLength;

            return Row(
              children: List.generate(lineLength, (rowIndex) {
                final currentIndex = index * lineLength + rowIndex;
                if (currentIndex >= values!.length) {
                  return SizedBox(width: itemWidth);
                }
                return SizedBox(
                  width: itemWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: widgetGetter.getWidget(
                      values![currentIndex],
                      onCardClick,
                    ),
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }
}
