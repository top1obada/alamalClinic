import 'package:clinic_appointment_booking_dto/DoctorDTO/clinic_doctor_dto.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/base_current_login_provider.dart';
import 'package:clinic_appointment_booking_ui/DoctorUI/doctor_detials_ui.dart';
import 'package:clinic_appointment_booking_ui/TemplatesUI/cards_template.dart';
import 'package:clinic_appointment_booking_widgets/DoctorWidgets/doctor_widget_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clinic_appointment_booking_providers/DoctorProviders/clinic_doctors_patient_favorite.dart';

import 'package:clinic_appointment_booking_providers/DoctorProviders/doctor_details_provider.dart';

class PatientFavoriteDoctorsUi extends StatefulWidget {
  const PatientFavoriteDoctorsUi({super.key});

  @override
  State<PatientFavoriteDoctorsUi> createState() {
    return _PatientFavoriteDoctorsUi();
  }
}

class _PatientFavoriteDoctorsUi extends State<PatientFavoriteDoctorsUi> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          await _loadDoctors();
        }
      });

      await _loadDoctors();
    });
  }

  Future<void> _loadDoctors() async {
    await context.read<PVPatientFavoriteDoctors>().getPatientFavoriteDoctors(
      patientID:
          context
              .read<PVBaseCurrentLoginInfo>()
              .retrivingLoggedInDTO!
              .userBranchID!,
      pageSize: 6,
    );
  }

  @override
  Widget build(BuildContext baseContext) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Consumer<PVPatientFavoriteDoctors>(
            builder: (con, value, child) {
              return CardsTemplate(
                scrollController: _scrollController,
                isLoaded: value.isLoaded,
                isFinished: value.isFinished,
                values: value.favoriteDoctors,
                lineLength: 2,
                widgetGetter: GetClinicDoctorWidget(),
                onCardClick: (c) {
                  ClsClinicDoctorDto doctorDto = c as ClsClinicDoctorDto;

                  if (doctorDto.doctorID == null) {
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (context) => PVDoctorDetails(),
                              ),

                              ChangeNotifierProvider.value(
                                value:
                                    baseContext.read<PVBaseCurrentLoginInfo>(),
                              ),
                            ],
                            child: DoctorDetailsScreen(
                              doctorID: doctorDto.doctorID!,
                            ),
                          ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
