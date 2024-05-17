import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_4/const.dart';
import 'package:quiz_4/services/auth.dart';
import 'package:quiz_4/widgets/form_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GetIt _getIt = GetIt.instance;
  final GlobalKey<FormState> _loginFormKey = GlobalKey();

  late AuthService _authService;

  String? email, password;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 43, 42),
      resizeToAvoidBottomInset: false,
      body: _loginUI(),
    );
  }

  Widget _loginUI() {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: [_header(), _loginForm(), _signup()],
      ),
    ));
  }

  Widget _header() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Center(
        child: Column(
          children: [
            Text(
              "ePub",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Color.fromARGB(255, 34, 99, 102),
                      fontSize: 60,
                      fontWeight: FontWeight.bold)),
            ),
            Text(
              "Welcome Back to ePub",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      color: Color.fromARGB(255, 243, 243, 243),
                      fontSize: 20,
                      fontWeight: FontWeight.w200)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.30,
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.sizeOf(context).height * 0.05),
        child: Form(
            key: _loginFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustFormField(
                  defsize: MediaQuery.sizeOf(context).height * 0.09,
                  hintText: "Email",
                  prefix: const Icon(Icons.email),
                  regvalidation: emailValidation,
                  onSaved: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustFormField(
                  defsize: MediaQuery.sizeOf(context).height * 0.09,
                  hintText: "Password",
                  prefix: const Icon(Icons.key),
                  regvalidation: passValidation,
                  onSaved: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                _logButton(),
              ],
            )));
  }

  Widget _logButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.20,
      height: MediaQuery.sizeOf(context).height * 0.05,
      child: MaterialButton(
        onPressed: () async {
          if (_loginFormKey.currentState?.validate() ?? false) {
            _loginFormKey.currentState?.save();
            try {
              bool result = await _authService.login(email!, password!);
              if (result) {
                Navigator.of(context).pushNamed('/home');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Failed to login, Please try again!"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.toString()),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        color: Theme.of(context).colorScheme.primary,
        child: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _signup() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account?"),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/signup');
            },
            child: Text(
              "SignUp",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
