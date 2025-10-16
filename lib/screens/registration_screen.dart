import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expoqr/widgets/custom_app_bar.dart';
import 'package:expoqr/widgets/user_type_selector.dart';
import 'package:expoqr/services/api_service.dart';
import 'package:expoqr/screens/submission_complete_screen.dart';

enum ScreenState { loading, valid, invalid }
enum UserType { student, staff, external }

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  ScreenState _screenState = ScreenState.loading;
  UserType selectedUserType = UserType.external;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  bool agreeToPrivacy = false;
  String? currentBoothLabel;
  String? currentDepartment;

  @override
  void initState() {
    super.initState();
    final uri = Uri.parse(html.window.location.href);
    final boothId = uri.queryParameters['q'] ?? '';
    ApiService.getBoothInfo(boothId).then((info) {
      setState(() {
        if (info['success'] == true) {
          _screenState = ScreenState.valid;
          currentBoothLabel = info['data']['summaryName'];
          currentDepartment = info['data']['boothName'];
        } else {
          _screenState = ScreenState.invalid;
        }
      });
    }).catchError((_) {
      setState(() => _screenState = ScreenState.invalid);
    });
  }

  void _submit() async {
    try {
      bool result = await ApiService.registerAndVisit(
        boothId: Uri.parse(html.window.location.href).queryParameters['q'] ?? '',
        type: selectedUserType.name,
        identifier: idController.text.trim(),
        name: selectedUserType == UserType.external ? nameController.text.trim() : null,
        contact: selectedUserType == UserType.external ? phoneController.text.trim() : null,
        privacyConsent: agreeToPrivacy,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SubmissionCompleteScreen(
            isSuccess: result,
            title: result ? 'Registration Complete' : 'Registration Failed',
            subtitle: result ? 'Thank you for participating!' : 'Please try again later.',
          ),
        ),
      );
    } catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SubmissionCompleteScreen(isSuccess: false),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_screenState == ScreenState.loading) {
      return Scaffold(
        appBar: CustomAppBar(title: 'EXPO Booth Registration'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_screenState == ScreenState.invalid) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Invalid Booth'),
        body: const Center(child: Text('Invalid QR code or booth closed.')),
      );
    }
    return Scaffold(
      appBar: CustomAppBar(title: 'EXPO Booth Registration'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              currentDepartment ?? '',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            Text(currentBoothLabel ?? ''),
            const SizedBox(height: 16),
            UserTypeSelector(
              selectedUserType: selectedUserType,
              onChanged: (type) => setState(() => selectedUserType = type),
            ),
            const SizedBox(height: 16),
            if (selectedUserType == UserType.external) ...[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              CheckboxListTile(
                value: agreeToPrivacy,
                onChanged: (v) => setState(() => agreeToPrivacy = v!),
                title: const Text(
                  // 개인정보 처리방침 샘플로 대체
                  '1. [Purpose] Collect name & phone for event verification\n'
                  '2. [Retention] 1 month after event\n'
                  '3. Used only for participation confirmation\n'
                  '※ Sample policy.',
                ),
              ),
            ] else ...[
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: selectedUserType == UserType.student ? 'Student ID (7 digits)' : 'Staff ID (8 digits)',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
