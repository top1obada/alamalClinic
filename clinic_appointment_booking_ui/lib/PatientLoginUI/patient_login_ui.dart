import 'package:clinic_appointment_booking_dto/UserDTO/login_requirements_dto.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/base_current_login_provider.dart';
import 'package:clinic_appointment_booking_providers/PatientProviders/patient_sign_up_provider.dart';
import 'package:clinic_appointment_booking_ui/PatientMainMenuUI/patient_main_menu_ui.dart';

import 'package:clinic_appointment_booking_ui/PatientSignUpUI/patient_sign_up_ui.dart';
import 'package:flutter/material.dart';
import 'package:project_widgets/TextFormsFiledsWidgets/PasswordTextFormFileds/native_password_text_form_filed.dart';
import 'package:project_widgets/TextsFiledsFunctions/TextFileds.dart';
import 'package:project_widgets/Validators/vd_not_empty.dart';
import 'package:provider/provider.dart';
import 'package:clinic_appointment_booking_providers/LoginProviders/patient_login_provider.dart';

class PatientLoginScreenUI extends StatefulWidget {
  const PatientLoginScreenUI({super.key});

  @override
  State<PatientLoginScreenUI> createState() => _PatientLoginScreenUIState();
}

class _PatientLoginScreenUIState extends State<PatientLoginScreenUI> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // Get the provider instance
      final loginProvider = context.read<PVPatientLogin>();

      var result = await loginProvider.login(
        ClsLoginRequirementsDto(
          userName: usernameController.text,
          password: passwordController.text,
        ),
      );

      if (!mounted) return;

      if (result) {
        PVBaseCurrentLoginInfo currentLogin = loginProvider;
        PVBaseCurrentLoginInfo pvbaseCurrentLoginInfo = currentLogin;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (innerContext) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(value: pvbaseCurrentLoginInfo),
                    ChangeNotifierProvider(
                      create: (c) => PVMainMenuUiPagesProvider(),
                    ),
                  ],
                  child: const PatientMainMenuUi(),
                ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('اسم المستخدم أو كلمة المرور غير صحيحة'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                _buildHeaderSection(),
                const SizedBox(height: 40),

                _buildLoginForm(),

                const SizedBox(height: 20),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Text(
          'مرحباً بعودتك!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'سجل الدخول إلى حسابك للمتابعة',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    final blackWithOpacity = Color.fromRGBO(0, 0, 0, 0.1);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: blackWithOpacity, blurRadius: 15, spreadRadius: 2),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFields.buildInputField(
              'اسم المستخدم',
              usernameController,
              validator:
                  (value) =>
                      EmptyValidator.validateNotEmpty(value, "اسم المستخدم"),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 20),

            WDNativePasswordTextFormField(
              controller: passwordController,
              hintText: 'كلمة المرور',
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 30),

            Consumer<PVPatientLogin>(
              builder: (context, loginProvider, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loginProvider.isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          loginProvider.isLoading
                              ? Colors.grey[400]
                              : Colors.blue[900],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child:
                        loginProvider.isLoading
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
                                  'جاري التسجيل...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                            : const Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('ليس لديك حساب؟', style: TextStyle(color: Colors.grey[600])),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (conext) => ChangeNotifierProvider(
                      create: (c) => PVPatientSignUp(),
                      child: const UIPatientSignUp(),
                    ),
              ),
            );
          },
          child: Text(
            'سجل الآن',
            style: TextStyle(
              color: Colors.blue[900],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
