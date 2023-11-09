import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:gap/gap.dart';
import 'package:kominfo_dashboard_test/login/class/auth.dart';
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
    Auth.is2FAAvailable().then((value) => {
          debugPrint('availability: $value'),
          setState(() {
            _is2FAAvailable = value;
          })
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleLogin(context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Auth.login(email, password, context);
    }
  }

  void handleRegister(context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Auth.register(email, password, context);
    }
  }

  void handleClick2FA(context) async {
    bool isLoggedIn = await Auth.isLoggedIn();
    if (!isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
            content: Text('Anda harus login terlebih dahulu')),
      );
      return null;
    }

    bool is2FAAvailable = await Auth.is2FAAvailable();
    if (!is2FAAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            duration: Duration(seconds: 1),
            content: Text('Smartphone anda tidak terpasang suatu pengaman')),
      );
      return null;
    }

    Auth.handleLogin2FA(context);
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
                    style: const TextStyle(fontSize: 12),
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
                          onPressed: () => handleLogin(context),
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
                          onPressed: () => handleClick2FA(context))
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
