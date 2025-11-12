import 'package:clinic_appointment_booking_dto/DoctorDTO/clinic_doctor_dto.dart';
import 'package:clinic_appointment_booking_providers/DoctorSpecialtyProviders/doctor_specialties_provider.dart';
import 'package:clinic_appointment_booking_providers/DoctorProviders/clinic_doctors_by_specialty_provider.dart';
import 'package:clinic_appointment_booking_ui/DoctorUI/doctor_detials_ui.dart';
import 'package:clinic_appointment_booking_ui/TemplatesUI/cards_template.dart';
import 'package:clinic_appointment_booking_widgets/DoctorWidgets/doctor_widget_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clinic_appointment_booking_widgets/DoctorSpecialtiesWidgets/word_line_doctor_specialties_widget.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart';
import 'package:clinic_appointment_booking_providers/DoctorProviders/doctor_details_provider.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/base_current_login_provider.dart';

class ClinicDoctorsUi extends StatefulWidget {
  const ClinicDoctorsUi({super.key});

  @override
  State<ClinicDoctorsUi> createState() {
    return _ClinicDoctorsUi();
  }
}

class _ClinicDoctorsUi extends State<ClinicDoctorsUi> {
  final ScrollController _scrollController = ScrollController();

  String? _selectedSpecialty;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<PVDoctorSpecialties>().getDoctorSpecialties();

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
    await context.read<PVClinicDoctorsBySpecialty>().getClinicDoctors(
      pageSize: 6,
      specialty: _selectedSpecialty,
    );
  }

  Future<void> _onSpecialtySelected(String specialty) async {
    _selectedSpecialty = specialty == 'الكل' ? null : specialty;

    context.read<PVClinicDoctorsBySpecialty>().clearDoctors();
    await _loadDoctors();
  }

  @override
  Widget build(BuildContext baseContext) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(158, 158, 158, 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Consumer<PVDoctorSpecialties>(
            builder: (context, specialtiesProvider, child) {
              return specialtiesProvider.isLoading
                  ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                      strokeWidth: 2,
                    ),
                  )
                  : specialtiesProvider.doctorSpecialties == null
                  ? const Text(
                    'حدث خطأ في تحميل التخصصات الطبية',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontFamily: 'Tajawal',
                    ),
                    textAlign: TextAlign.center,
                  )
                  : specialtiesProvider.doctorSpecialties!.isEmpty
                  ? const Text(
                    'لا توجد تخصصات طبية متاحة',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: 'Tajawal',
                    ),
                    textAlign: TextAlign.center,
                  )
                  : DoctorSpecialtiesLine(
                    doctorSpecialties: specialtiesProvider.doctorSpecialties,
                    onItemClick: _onSpecialtySelected,
                  );
            },
          ),
        ),

        Expanded(
          child: Consumer<PVClinicDoctorsBySpecialty>(
            builder: (context, doctorsProvider, child) {
              if (Errors.errorMessage != null &&
                  !doctorsProvider.isLoading &&
                  doctorsProvider.clinicDoctors == null) {
                return Center(
                  child: Text(
                    Errors.errorMessage!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontFamily: 'Tajawal',
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (doctorsProvider.isLoading &&
                  doctorsProvider.clinicDoctors == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                    strokeWidth: 2,
                  ),
                );
              }

              if (doctorsProvider.isLoaded &&
                  (doctorsProvider.clinicDoctors == null ||
                      doctorsProvider.clinicDoctors!.isEmpty)) {
                return const Center(
                  child: Text(
                    'لا توجد أطباء متاحين',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontFamily: 'Tajawal',
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return CardsTemplate(
                scrollController: _scrollController,
                isLoaded: doctorsProvider.isLoaded,
                isFinished: doctorsProvider.isFinished,
                values: doctorsProvider.clinicDoctors,
                lineLength: 2,
                widgetGetter: GetClinicDoctorWidget(),
                onCardClick: (c) {
                  ClsClinicDoctorDto clinicDoctorDTO = c as ClsClinicDoctorDto;

                  if (clinicDoctorDTO.doctorID == null) {
                    return;
                  }

                  // Navigate to DoctorDetailsScreen with MultiProvider
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
                              doctorID: clinicDoctorDTO.doctorID!,
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
