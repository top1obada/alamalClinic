import 'package:flutter/material.dart';
import 'package:project_widgets/SearchWidgets/words_line.dart';

class DoctorSpecialtiesLine extends StatelessWidget {
  const DoctorSpecialtiesLine({
    super.key,
    required this.doctorSpecialties,
    required this.onItemClick,
  });

  final List<String>? doctorSpecialties;
  final Function(String) onItemClick;

  @override
  Widget build(BuildContext context) {
    if (doctorSpecialties == null) {
      return const Text(
        'حدث خطأ في تحميل البيانات',
        style: TextStyle(fontSize: 16, color: Colors.red),
        textAlign: TextAlign.center,
      );
    }

    if (doctorSpecialties!.isEmpty) {
      return const Text(
        'لا توجد تخصصات طبية متاحة',
        style: TextStyle(fontSize: 16, color: Colors.grey),
        textAlign: TextAlign.center,
      );
    }

    // Add "All" as first item to the list of strings
    final List<String> words = [
      'الكل', // "All" item
      ...doctorSpecialties!,
    ];

    return TextSelectorLine(
      words: words,
      onWordSelected: onItemClick,
      defaultColor: Colors.grey,
      backgroundColor: Colors.white,
      defaultFontSize: 16,
      selectedFontSize: 20,
      showBackground: true,
    );
  }
}
