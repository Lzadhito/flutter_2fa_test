import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:local_auth/local_auth.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final supabase = Supabase.instance.client;
  final LocalAuthentication auth = LocalAuthentication();

  bool _is2FAAvailable = false;
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    check2FAAvailability();
  }

  check2FAAvailability() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    _is2FAAvailable = canAuthenticate && availableBiometrics.isNotEmpty;
  }

  Future<void> handleSubmitLogin(context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await supabase
            .from('Users')
            .select('email, password')
            .eq('email', email)
            .eq('password', password)
            .single();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              duration: Duration(seconds: 1), content: Text('Login Berhasil')),
        );
        Navigator.pushNamed(context, '/dashboard');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              duration: Duration(seconds: 1),
              backgroundColor: Colors.red,
              content: Text('username atau password salah')),
        );
      }
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

        if (didAuthenticate) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                duration: Duration(seconds: 1),
                content: Text('Login Berhasil')),
          );
          Navigator.pushNamed(context, '/dashboard');
        }
        // ···
      } on PlatformException catch (error) {
        debugPrint(error.toString());
        // ...
      }
      // Some biometrics are enrolled.
    }
  }

  void handleRegister(context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            duration: Duration(seconds: 200), content: Text('Mendaftarkan')),
      );

      try {
        await supabase
            .from('Users')
            .select('email, password')
            .eq('email', email)
            .single();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
            content: Text('Email sudah terdaftar')));
        return;
      } catch (error) {
        try {
          await supabase
              .from('Users')
              .insert({'email': email, 'password': password});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                duration: Duration(seconds: 1),
                content: Text('Registrasi Berhasil')),
          );
          Navigator.pushNamed(context, '/dashboard');
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                duration: const Duration(seconds: 1),
                backgroundColor: Colors.red,
                content: Text(error.toString())),
          );
        }
      }
    }
  }

  void handleWarn2FANotSet() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          duration: Duration(seconds: 1),
          content: Text('Smartphone anda tidak terpasang suatu pengaman')),
    );
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
                    style: const TextStyle(fontSize: 12),
                    onSaved: (value) {
                      email = value ?? '';
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        hintText: 'Masukkan Email'),
                    // The validator receives the text that the user has entered.
                    validator: (email) {
                      if (email != null && email.isNotEmpty) {
                        final bool isValid = EmailValidator.validate(email);
                        return isValid
                            ? null
                            : 'Mohon masukkan email yang benar';
                      }
                      return 'Mohon masukkan email yang benar';
                    },
                  ),
                  const Gap(20),
                  TextFormField(
                    style: TextStyle(fontSize: 12),
                    onSaved: (value) {
                      password = value ?? '';
                    },
                    obscureText: true,
                    enableSuggestions: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        hintText: 'Masukkan Password'),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      debugPrint(value);
                      if (value == null || value.isEmpty) {
                        return 'Mohon masukkan password';
                      }
                      return null;
                    },
                  ),
                  const Gap(20),
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
                        style: IconButton.styleFrom(
                            backgroundColor: _is2FAAvailable
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey),
                        icon: const Icon(Icons.fingerprint_rounded),
                        onPressed: _is2FAAvailable
                            ? () => handleLogin2FA(context)
                            : handleWarn2FANotSet,
                      )
                    ],
                  ),
                  const Gap(20),
                  const Row(children: <Widget>[
                    Expanded(child: Divider()),
                    Gap(10),
                    Text("atau", style: TextStyle(color: Colors.grey)),
                    Gap(10),
                    Expanded(child: Divider()),
                  ]),
                  const Gap(20),
                  ElevatedButton.icon(
                      icon: const Icon(Icons.person_add_rounded),
                      onPressed: null,
                      label: const Text(
                        'Daftar menggunakan akun e-TPP',
                        style: TextStyle(fontSize: 13),
                      )),
                  const Gap(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Belum punya akun? "),
                      GestureDetector(
                        child: Text(
                          "Daftar",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        onTap: () => handleRegister(context),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    )));
  }
}
