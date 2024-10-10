import 'dart:convert';

import 'package:eco_smart/components/password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_smart/core/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  final FocusNode _passwordFocus = FocusNode();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _login(String username, String password) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var url = Uri.parse('$BASE_API_AUTH_URL/login');

      var response = await http.post(
        url,
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        String responseBody = response.body;
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);
        String token = jsonResponse['data']['access_token'];
        String userData = jsonEncode(jsonResponse['data']);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', userData);
        await prefs.setString('access_token', token);

        context.go('/');
      } else {
        String responseBody = response.body;
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse['message'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocorreu um erro: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth > 400 ? 400 : double.infinity,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('assets/images/icon.png', width: 200, height: 200),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Digite seu email',
                      ),
                      enabled: !_isLoading,
                      onFieldSubmitted: (value) {
                        _passwordFocus.requestFocus();
                      },
                    ),
                    const SizedBox(height: 20),
                    PasswordField(
                        controller: _passwordController,
                        enabled: !_isLoading,
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) {
                          if (_isLoading) return;

                          String username = _usernameController.text;
                          String password = _passwordController.text;

                          _login(username, password);
                        }),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_isLoading) return;

                        _login(_usernameController.text, _passwordController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('Entrar'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_isLoading) return;
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('Registrar-se'),
                    ),
                    if (_isLoading) const SizedBox(height: 20),
                    if (_isLoading) SpinKitFoldingCube(color: Theme.of(context).primaryColor, size: 50),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
