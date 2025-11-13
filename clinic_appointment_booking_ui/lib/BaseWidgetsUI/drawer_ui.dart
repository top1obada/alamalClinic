import 'package:clinic_appointment_booking_providers/AppointmentProviders/patient_appointments_provider.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/base_current_login_provider.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/patient_login_provider.dart';
import 'package:clinic_appointment_booking_providers/PatientProviders/patient_details_provider.dart';
import 'package:clinic_appointment_booking_providers/PersonProviders/get_person_info_provider.dart';
import 'package:clinic_appointment_booking_providers/PersonProviders/update_person_provider.dart';
import 'package:clinic_appointment_booking_ui/PatientLoginUI/patient_login_ui.dart';
import 'package:clinic_appointment_booking_ui/AppointmentUI/patient_appintments_ui.dart';
import 'package:clinic_appointment_booking_ui/PersonUI/profile_ui.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseDrawer extends StatelessWidget {
  const BaseDrawer({super.key});

  Widget _buildAppIcon() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.amber.shade300,
            Colors.orange.shade400,
            Colors.deepOrange.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withValues(alpha: 0.6),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
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
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset(
            'assets/app_icon2.png',
            width: 44,
            height: 44,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.amber[300],
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                  size: 28,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ListView(
            children: [
              Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(70),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade200.withValues(alpha: 0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(child: _buildAppIcon()),
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.account_circle, color: Colors.blue),
                title: const Text(
                  'ملفي الشخصي',
                  textDirection: TextDirection.rtl,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (inner) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (c) => PVGetPersonInfo(),
                              ),
                              ChangeNotifierProvider(
                                create: (c) => PVUpdatePerson(),
                              ),
                              ChangeNotifierProvider(
                                create: (c) => PVPatientDetails(),
                              ),
                              ChangeNotifierProvider.value(
                                value: context.read<PVBaseCurrentLoginInfo>(),
                              ),
                            ],
                            child: const ProfileUi(),
                          ),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.green),
                title: const Text('مواعيدي', textDirection: TextDirection.rtl),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (inner) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (c) => PVPatientAppointments(),
                              ),
                              ChangeNotifierProvider.value(
                                value: context.read<PVBaseCurrentLoginInfo>(),
                              ),
                            ],
                            child: const PatientAppointmentsUi(),
                          ),
                    ),
                  );
                },
              ),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.blue),
                title: const Text(
                  'تسجيل الخروج',
                  textDirection: TextDirection.rtl,
                ),
                onTap: () async {
                  await context.read<PVBaseCurrentLoginInfo>().clear();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder:
                          (inner) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (c) => PVPatientLogin(),
                              ),
                            ],
                            child: const PatientLoginScreenUI(),
                          ),
                    ),
                    (Route<dynamic> rr) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
