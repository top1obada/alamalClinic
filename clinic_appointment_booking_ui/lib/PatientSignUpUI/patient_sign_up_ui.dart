import 'package:clinic_appointment_booking_dto/PatientDTO/completed_patient_dto.dart';
import 'package:clinic_appointment_booking_dto/UserDTO/login_requirements_dto.dart';
import 'package:clinic_appointment_booking_dto/PersonDTO/person_dto.dart';
import 'package:clinic_appointment_booking_dto/UserDTO/user_dto.dart';
import 'package:clinic_appointment_booking_dto/PatientDTO/patient_dto.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/base_current_login_provider.dart';
import 'package:clinic_appointment_booking_providers/PatientProviders/patient_sign_up_provider.dart';
import 'package:clinic_appointment_booking_ui/PatientMainMenuUI/patient_main_menu_ui.dart';
import 'package:flutter/material.dart';
import 'package:project_widgets/CountriesWidgets/countries_drop_down_list_widget.dart';
import 'package:project_widgets/DateTimeWidgets/wd_date_time.dart';
import 'package:project_widgets/TextFormsFiledsWidgets/PasswordTextFormFileds/native_password_text_form_filed.dart';
import 'package:project_widgets/TextsFiledsFunctions/TextFileds.dart';
import 'package:project_widgets/Validators/vd_not_empty.dart';
import 'package:project_widgets/GenderWidgets/gender_selector_widget.dart';
import 'package:provider/provider.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/error.dart'
    as error;

class UIPatientSignUp extends StatefulWidget {
  const UIPatientSignUp({super.key});

  @override
  State<UIPatientSignUp> createState() => _UIPatientSignUp();
}

class _UIPatientSignUp extends State<UIPatientSignUp> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for required fields only
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController =
      TextEditingController(); // ADDED MIDDLE NAME
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  String? nationality;
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String gender = ''; // selected gender

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose(); // ADDED MIDDLE NAME
    lastNameController.dispose();
    birthdayController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    final signUpProvider = context.read<PVPatientSignUp>();

    ClsCompletedPatientDto completedPatientDto = ClsCompletedPatientDto(
      person: ClsPersonDto(
        firstName: firstNameController.text.trim(),
        middleName: middleNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        nationality: nationality,
        gender: gender.trim(),
        birthDate: DateTime.tryParse(birthdayController.text.trim()),
      ),
      user: ClsUserDto(userName: userNameController.text.trim()),
      patient: ClsPatientDto(),
    );

    ClsLoginRequirementsDto loginInfo = ClsLoginRequirementsDto(
      userName: userNameController.text.trim(),
      password: passwordController.text.trim(),
    );

    final result = await signUpProvider.signUp(completedPatientDto, loginInfo);

    if (!mounted) return;

    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.Errors.errorMessage!),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    PVBaseCurrentLoginInfo pvbaseCurrentLoginInfo = signUpProvider;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إنشاء الحساب بنجاح!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder:
            (inner) => MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: pvbaseCurrentLoginInfo),
                ChangeNotifierProvider(
                  create: (_) => PVMainMenuUiPagesProvider(),
                ),
              ],
              child: const PatientMainMenuUi(),
            ),
      ),
      (Route<dynamic> rr) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'إنشاء حساب مريض جديد',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'المعلومات الشخصية',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextFields.buildInputField(
                    'الاسم الأول',
                    firstNameController,
                    validator:
                        (val) =>
                            EmptyValidator.validateNotEmpty(val, 'الاسم الأول'),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),

                  TextFields.buildInputField(
                    'الاسم الأوسط (اختياري)',
                    middleNameController,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),

                  TextFields.buildInputField(
                    'الاسم الأخير',
                    lastNameController,
                    validator:
                        (val) => EmptyValidator.validateNotEmpty(
                          val,
                          'الاسم الأخير',
                        ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),

                  WDBirthDatePicker(
                    controller: birthdayController,
                    validator:
                        (val) => EmptyValidator.validateNotEmpty(
                          val,
                          'تاريخ الميلاد',
                        ),
                  ),
                  const SizedBox(height: 12),

                  WDGenderSelector(
                    onChanged: (val) => gender = val,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 12),

                  WDCountriesDropdown(
                    text: 'الجنسية',
                    onChanged: (val) => nationality = val,
                  ),
                  const SizedBox(height: 20),

                  const Divider(),

                  Text(
                    'بيانات الحساب',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextFields.buildInputField(
                    'اسم المستخدم',
                    userNameController,
                    validator:
                        (val) => EmptyValidator.validateNotEmpty(
                          val,
                          'اسم المستخدم',
                        ),
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 12),

                  WDNativePasswordTextFormField(
                    controller: passwordController,
                    hintText: 'كلمة المرور',
                    textDirection: TextDirection.rtl,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Consumer<PVPatientSignUp>(
              builder: (context, signUpProvider, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: signUpProvider.isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          signUpProvider.isLoading
                              ? Colors.grey[400]
                              : Colors.blue[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        signUpProvider.isLoading
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'جاري إنشاء الحساب...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                            : const Text(
                              'تسجيل',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
