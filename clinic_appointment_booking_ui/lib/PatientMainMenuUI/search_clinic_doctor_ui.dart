import 'package:clinic_appointment_booking_dto/DoctorDTO/clinic_doctor_dto.dart';
import 'package:clinic_appointment_booking_providers/DoctorProviders/clinic_doctors_by_name.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/base_current_login_provider.dart';
import 'package:clinic_appointment_booking_ui/DoctorUI/doctor_detials_ui.dart';
import 'package:clinic_appointment_booking_ui/TemplatesUI/cards_template.dart';
import 'package:clinic_appointment_booking_widgets/DoctorWidgets/doctor_widget_card.dart';
import 'package:flutter/material.dart';
import 'package:project_widgets/SearchWidgets/search_widget.dart';
import 'package:provider/provider.dart';
import 'package:clinic_appointment_booking_providers/DoctorProviders/clinic_doctors_privious_appointment.dart';
import 'package:clinic_appointment_booking_providers/DoctorProviders/doctor_details_provider.dart';

class PVSearch extends ChangeNotifier {
  String? _searchingText;

  String? get searchingText {
    return _searchingText;
  }

  set searchingText(String? value) {
    _searchingText = value;
    notifyListeners();
  }
}

class SearchDoctorsUi extends StatefulWidget {
  const SearchDoctorsUi({super.key});

  @override
  State<SearchDoctorsUi> createState() {
    return _SearchDoctorsUi();
  }
}

class _SearchDoctorsUi extends State<SearchDoctorsUi> {
  final ScrollController _previousDoctorsScrollController = ScrollController();
  final ScrollController _searchingScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _previousDoctorsScrollController.addListener(() async {
        if (_previousDoctorsScrollController.position.pixels ==
            _previousDoctorsScrollController.position.maxScrollExtent) {
          await _loadDoctorsPreviousAppointments();
        }
      });

      _searchingScrollController.addListener(() async {
        if (_searchingScrollController.position.pixels ==
            _searchingScrollController.position.maxScrollExtent) {
          await _loadDoctorsSearching();
        }
      });

      await _loadDoctorsPreviousAppointments();
    });
  }

  Future<void> _loadDoctorsSearching() async {
    await context.read<PVSearchDoctors>().getClinicDoctors(
      searchTerm: context.read<PVSearch>().searchingText!,
      pageSize: 10,
    );
  }

  Future<void> _loadDoctorsPreviousAppointments() async {
    await context
        .read<PVPreviousDoctorsAppointments>()
        .getPreviousDoctorsAppointments(
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
      children: [
        SearchHeader(
          onSearch: (text) async {
            PVSearch pvSearch = context.read<PVSearch>();
            context.read<PVSearchDoctors>().clearDoctors();
            if (text.isEmpty) {
              pvSearch.searchingText = null;
            } else {
              pvSearch.searchingText = text;
              await _loadDoctorsSearching();
            }
          },
          hintText: 'ابحث عن طبيب...',
        ),
        Expanded(
          child: Consumer<PVSearch>(
            builder: (cont, value, child) {
              if (value.searchingText == null) {
                return Consumer<PVPreviousDoctorsAppointments>(
                  builder: (con, providerValue, child) {
                    return CardsTemplate(
                      scrollController: _previousDoctorsScrollController,
                      isLoaded: providerValue.isLoaded,
                      isFinished: providerValue.isFinished,
                      values: providerValue.previousDoctors,
                      lineLength: 2,
                      widgetGetter: GetClinicDoctorWidget(),
                      onCardClick: (c) {
                        ClsClinicDoctorDto doctorDto = c as ClsClinicDoctorDto;

                        if (doctorDto.doctorID == null) {
                          return;
                        }

                        // Navigate to DoctorDetailsScreen for previous appointments
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
                                          baseContext
                                              .read<PVBaseCurrentLoginInfo>(),
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
                );
              } else {
                return Consumer<PVSearchDoctors>(
                  builder: (con, providerValue, child) {
                    return CardsTemplate(
                      scrollController: _searchingScrollController,
                      isLoaded: providerValue.isLoaded,
                      isFinished: providerValue.isFinished,
                      values: providerValue.searchDoctors,
                      lineLength: 2,
                      widgetGetter: GetClinicDoctorWidget(),
                      onCardClick: (c) {
                        ClsClinicDoctorDto doctorDto = c as ClsClinicDoctorDto;

                        if (doctorDto.doctorID == null) {
                          return;
                        }

                        // Navigate to DoctorDetailsScreen for search results
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
                                          baseContext
                                              .read<PVBaseCurrentLoginInfo>(),
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
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
