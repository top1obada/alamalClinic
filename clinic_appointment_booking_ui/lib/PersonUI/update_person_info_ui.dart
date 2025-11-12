import 'package:clinic_appointment_booking_dto/PersonDTO/person_dto.dart';
import 'package:clinic_appointment_booking_providers/PersonProviders/get_person_info_provider.dart';
import 'package:clinic_appointment_booking_providers/PersonProviders/update_person_provider.dart';
import 'package:project_widgets/CountriesWidgets/countries_drop_down_list_widget.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class UpdatePersonScreen extends StatefulWidget {
  final int personID;

  const UpdatePersonScreen({super.key, required this.personID});

  @override
  State<UpdatePersonScreen> createState() => _UpdatePersonScreenState();
}

class _UpdatePersonScreenState extends State<UpdatePersonScreen> {
  final _formKey = material.GlobalKey<material.FormState>();

  final _firstNameController = material.TextEditingController();
  final _middleNameController = material.TextEditingController();
  final _lastNameController = material.TextEditingController();
  String? _selectedGender;
  String? _selectedNationality;
  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PVGetPersonInfo>().getPerson(widget.personID);
    });
  }

  void _initializeForm(ClsPersonDto person) {
    _firstNameController.text = person.firstName ?? '';
    _middleNameController.text = person.middleName ?? '';
    _lastNameController.text = person.lastName ?? '';
    _selectedGender = person.gender;
    _selectedNationality = person.nationality;
    _selectedBirthDate = person.birthDate;
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await material.showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthDate) {
      _selectedBirthDate = picked;
    }
  }

  Future<void> _updatePerson() async {
    if (_formKey.currentState!.validate()) {
      final updatedPerson = ClsPersonDto(
        personID: widget.personID,
        firstName: _firstNameController.text.trim(),
        middleName: _middleNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        gender: _selectedGender,
        nationality: _selectedNationality,
        birthDate: _selectedBirthDate,
      );

      final success = await context.read<PVUpdatePerson>().updatePerson(
        updatedPerson,
      );

      if (success) {
        material.ScaffoldMessenger.of(context).showSnackBar(
          const material.SnackBar(
            content: material.Text('تم تحديث المعلومات بنجاح'),
            backgroundColor: material.Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        material.ScaffoldMessenger.of(context).showSnackBar(
          material.SnackBar(
            content: material.Text(
              context.read<PVUpdatePerson>().errorMessage ??
                  'فشل تحديث المعلومات',
            ),
            backgroundColor: material.Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: material.Scaffold(
          backgroundColor: material.Colors.grey[50],
          appBar: material.AppBar(
            backgroundColor: material.Colors.white,
            elevation: 0,
            leading: material.IconButton(
              icon: const material.Icon(
                material.Icons.arrow_back,
                color: material.Colors.blue,
              ),
              onPressed: _onBackPressed,
            ),
            title: const material.Text(
              'تحديث المعلومات الشخصية',
              style: material.TextStyle(
                color: material.Colors.blue,
                fontWeight: material.FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
          ),
          body: material.SafeArea(
            child: Consumer<PVGetPersonInfo>(
              builder: (context, personProvider, child) {
                if (personProvider.isLoading &&
                    personProvider.personDetails == null) {
                  return const material.Center(
                    child: material.CircularProgressIndicator(),
                  );
                }

                if (!personProvider.isLoaded ||
                    personProvider.personDetails == null) {
                  return material.Center(
                    child: material.Text(
                      'حدث خطأ في تحميل البيانات',
                      style: material.TextStyle(
                        color: material.Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                if (_firstNameController.text.isEmpty) {
                  _initializeForm(personProvider.personDetails!);
                }

                return material.SingleChildScrollView(
                  padding: const material.EdgeInsets.all(16),
                  child: material.Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        material.Container(
                          padding: const material.EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: material.Colors.white,
                            borderRadius: material.BorderRadius.circular(16),
                            boxShadow: [
                              material.BoxShadow(
                                color: material.Colors.grey.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 10,
                                offset: const material.Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              material.TextFormField(
                                controller: _firstNameController,
                                decoration: const material.InputDecoration(
                                  labelText: 'الاسم الأول',
                                  border: material.OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال الاسم الأول';
                                  }
                                  return null;
                                },
                              ),
                              const material.SizedBox(height: 16),
                              material.TextFormField(
                                controller: _middleNameController,
                                decoration: const material.InputDecoration(
                                  labelText: 'اسم الأب',
                                  border: material.OutlineInputBorder(),
                                ),
                              ),
                              const material.SizedBox(height: 16),
                              material.TextFormField(
                                controller: _lastNameController,
                                decoration: const material.InputDecoration(
                                  labelText: 'الاسم الأخير',
                                  border: material.OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال الاسم الأخير';
                                  }
                                  return null;
                                },
                              ),
                              const material.SizedBox(height: 16),
                              material.DropdownButtonFormField<String>(
                                value: _selectedGender,
                                decoration: const material.InputDecoration(
                                  labelText: 'الجنس',
                                  border: material.OutlineInputBorder(),
                                ),
                                items: const [
                                  material.DropdownMenuItem(
                                    value: 'M',
                                    child: material.Text('ذكر'),
                                  ),
                                  material.DropdownMenuItem(
                                    value: 'F',
                                    child: material.Text('أنثى'),
                                  ),
                                ],
                                onChanged: (value) {
                                  _selectedGender = value;
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى اختيار الجنس';
                                  }
                                  return null;
                                },
                              ),
                              const material.SizedBox(height: 16),
                              WDCountriesDropdown(
                                text: 'الجنسية',
                                value: _selectedNationality,
                                onChanged: (value) {
                                  _selectedNationality = value;
                                },
                              ),
                              const material.SizedBox(height: 16),
                              material.GestureDetector(
                                onTap: _selectDate,
                                child: material.AbsorbPointer(
                                  child: material.TextFormField(
                                    decoration: const material.InputDecoration(
                                      labelText: 'تاريخ الميلاد',
                                      border: material.OutlineInputBorder(),
                                      suffixIcon: material.Icon(
                                        material.Icons.calendar_today,
                                      ),
                                    ),
                                    controller: material.TextEditingController(
                                      text:
                                          _selectedBirthDate != null
                                              ? '${_selectedBirthDate!.year}-${_selectedBirthDate!.month.toString().padLeft(2, '0')}-${_selectedBirthDate!.day.toString().padLeft(2, '0')}'
                                              : '',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'يرجى اختيار تاريخ الميلاد';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: Consumer<PVUpdatePerson>(
            builder: (context, updateProvider, child) {
              return material.Container(
                padding: const material.EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: material.Colors.white,
                  boxShadow: [
                    material.BoxShadow(
                      color: material.Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const material.Offset(0, -2),
                    ),
                  ],
                ),
                child:
                    updateProvider.isLoading
                        ? const material.Center(
                          child: material.CircularProgressIndicator(),
                        )
                        : material.ElevatedButton(
                          onPressed: _updatePerson,
                          style: material.ElevatedButton.styleFrom(
                            backgroundColor: material.Colors.blue[700],
                            foregroundColor: material.Colors.white,
                            padding: const material.EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shape: material.RoundedRectangleBorder(
                              borderRadius: material.BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const material.Text(
                            'تحديث المعلومات',
                            style: material.TextStyle(
                              fontSize: 18,
                              fontWeight: material.FontWeight.bold,
                            ),
                          ),
                        ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}
