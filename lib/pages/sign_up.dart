import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_4/const.dart';
import 'package:quiz_4/services/auth.dart';
import 'package:quiz_4/widgets/form_field.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final GetIt _getIt = GetIt.instance;

  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  late AuthService _authService;
  // late MediaServices _mediaServices;
  // late StorageService _storageService;

  String? email, password, name;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    // _mediaServices = _getIt.get<MediaServices>();
    _authService = _getIt.get<AuthService>();
    // _storageService = _getIt.get<StorageService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 43, 42),
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: ListView(
          children: [
            _header(),
            if (!isloading) _registerForm(),
            if (!isloading) _login(),
            if (isloading)
              const Center(
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
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
              "Welcome to ePub",
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

  Widget _registerForm() {
    return Form(
      key: _registerFormKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          CustFormField(
            defsize: MediaQuery.sizeOf(context).height * 0.09,
            hintText: "Name",
            prefix: const Icon(Icons.person),
            regvalidation: nameValidation,
            onSaved: (value) {
              setState(() {
                name = value;
              });
            },
          ),
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
          CustFormField(
            defsize: MediaQuery.sizeOf(context).height * 0.09,
            hintText: "Password",
            prefix: const Icon(Icons.password),
            regvalidation: passValidation,
            onSaved: (value) {
              setState(() {
                password = value;
              });
            },
          ),
          _regButton(),
        ],
      ),
    );
  }

  Widget _regButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.50,
      height: MediaQuery.sizeOf(context).height * 0.05,
      child: MaterialButton(
        onPressed: () async {
          setState(() {
            isloading = true;
          });
          try {
            if (_registerFormKey.currentState?.validate() ?? false) {
              _registerFormKey.currentState?.save();
              await _authService.signup(email!, password!, name!);
            }
          } catch (e) {
            print(e);
          }
          setState(() {
            isloading = false;
          });
        },
        color: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: const Text(
          "Register Account",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _login() {
    return SizedBox(
      width: MediaQuery.of(context).size.width *
          0.8, // Adjust the fraction as needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Already Have an Account?"),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/login');
            },
            child: Text(
              "Login",
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
