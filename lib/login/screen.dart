import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final LocalAuthentication auth = LocalAuthentication();

  void handleSubmitLogin(context) {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
      Navigator.pushNamed(context, '/dashboard');
    }
  }

  Future<void> handleLogin2FA(context) async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    if (canAuthenticate && availableBiometrics.isNotEmpty) {
      try {
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Please authenticate to show account balance',
            options: const AuthenticationOptions(biometricOnly: false));

        if (didAuthenticate) Navigator.pushNamed(context, '/dashboard');
        // ···
      } on PlatformException catch (error) {
        debugPrint(error.toString());
        // ...
      }
      // Some biometrics are enrolled.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Input Email'),
                    // The validator receives the text that the user has entered.
                    validator: (email) {
                      if (email != null && email.isNotEmpty) {
                        final bool isValid = EmailValidator.validate(email);
                        return isValid ? null : 'Please enter correct email';
                      }
                      return null;
                    },
                  ),
                  const Gap(20),
                  TextFormField(
                    obscureText: true,
                    enableSuggestions: true,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Input Password'),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      debugPrint(value);
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () => handleSubmitLogin(context),
                          child: const Text('Login'),
                        ),
                      ),
                      const Gap(10),
                      IconButton.filled(
                        icon: const Icon(Icons.fingerprint_rounded),
                        onPressed: () => handleLogin2FA(context),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    )));
  }
}
