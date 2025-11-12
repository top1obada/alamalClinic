import 'package:clinic_appointment_booking_providers/DoctorProviders/clinic_doctors_by_name.dart';
import 'package:clinic_appointment_booking_providers/DoctorProviders/clinic_doctors_patient_favorite.dart';
import 'package:clinic_appointment_booking_providers/DoctorProviders/clinic_doctors_privious_appointment.dart';
import 'package:clinic_appointment_booking_ui/PatientMainMenuUI/clinic_doctors_patient_favorite_ui.dart';
import 'package:clinic_appointment_booking_ui/PatientMainMenuUI/clinic_doctors_ui.dart';
import 'package:clinic_appointment_booking_ui/PatientMainMenuUI/bottom_main_menu_line.dart';
import 'package:clinic_appointment_booking_ui/PatientMainMenuUI/search_clinic_doctor_ui.dart';
import 'package:clinic_appointment_booking_ui/WidgetsUI/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/base_current_login_provider.dart';
import 'package:clinic_appointment_booking_providers/DoctorSpecialtyProviders/doctor_specialties_provider.dart';
import 'package:clinic_appointment_booking_providers/DoctorProviders/clinic_doctors_by_specialty_provider.dart';

enum EnMainMenuPages {
  eClinicDoctors(1),
  eSearchDoctors(2),
  eFavoriteDoctors(3);

  final int value;

  const EnMainMenuPages(this.value);

  @override
  String toString() {
    return name.substring(1, name.length);
  }

  static EnMainMenuPages? fromValue(int? value) {
    if (value == null) return null;
    return EnMainMenuPages.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw Exception('Unknown EnMainMenuPages value: $value'),
    );
  }
}

class PVMainMenuUiPagesProvider extends ChangeNotifier {
  EnMainMenuPages page = EnMainMenuPages.eClinicDoctors;

  void changePage(EnMainMenuPages page) {
    this.page = page;
    notifyListeners();
  }
}

class PatientMainMenuUi extends StatefulWidget {
  const PatientMainMenuUi({super.key});

  @override
  State<PatientMainMenuUi> createState() {
    return _PatientMainMenuUi();
  }
}

class _PatientMainMenuUi extends State<PatientMainMenuUi> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BaseScaffold(
        titleWidget: _buildTitleWidget(),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Consumer<PVMainMenuUiPagesProvider>(
                builder: (innercontext, value, child) {
                  if (value.page == EnMainMenuPages.eSearchDoctors) {
                    return MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (_) => PVSearchDoctors(),
                        ),
                        ChangeNotifierProvider(
                          create: (_) => PVPreviousDoctorsAppointments(),
                        ),
                        ChangeNotifierProvider(create: (_) => PVSearch()),
                        ChangeNotifierProvider.value(
                          value: context.read<PVBaseCurrentLoginInfo>(),
                        ),
                      ],
                      child: const SearchDoctorsUi(),
                    );
                  }

                  if (value.page == EnMainMenuPages.eFavoriteDoctors) {
                    return MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (_) => PVPatientFavoriteDoctors(),
                        ),
                        ChangeNotifierProvider.value(
                          value: context.read<PVBaseCurrentLoginInfo>(),
                        ),
                      ],
                      child: const PatientFavoriteDoctorsUi(),
                    );
                  }

                  return MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (_) => PVDoctorSpecialties(),
                      ),
                      ChangeNotifierProvider(
                        create: (_) => PVClinicDoctorsBySpecialty(),
                      ),
                      ChangeNotifierProvider.value(
                        value: context.read<PVBaseCurrentLoginInfo>(),
                      ),
                    ],
                    child: const ClinicDoctorsUi(),
                  );
                },
              ),
            ),

            const BottomLineMainMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleWidget() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade300,
            Colors.blue.shade600,
            Colors.blue.shade800,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.6),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Icon(
            Icons.medical_services,
            color: Colors.blue[700],
            size: 24,
          ),
        ),
      ),
    );
  }
}
