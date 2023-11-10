import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class Auth {
  static void _onLoginSuccess(String email, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
  }

  static void login(String email, String password, context) async {
    final supabase = Supabase.instance.client;
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
      _onLoginSuccess(email, context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
            content: Text('username atau password salah')),
      );
    }
  }

  static void register(String email, String password, context) async {
    final supabase = Supabase.instance.client;

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
        _onLoginSuccess(email, context);
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

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emailPref = prefs.getString('email');
    if (emailPref == null || emailPref.isEmpty) return false;
    return true;
  }

  static Future<bool> is2FAAvailable() async {
    if (!await isLoggedIn()) return false;

    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    return canAuthenticate && availableBiometrics.isNotEmpty;
  }

  static Future<void> handleLogin2FA(context) async {
    final LocalAuthentication auth = LocalAuthentication();
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
          Navigator.pushNamedAndRemoveUntil(
              context, '/dashboard', (route) => false);
        }
        // ···
      } on PlatformException {
        // ...
      }
      // Some biometrics are enrolled.
    }
  }

  static void logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    Navigator.pushReplacementNamed(context, '/login');
  }
}
