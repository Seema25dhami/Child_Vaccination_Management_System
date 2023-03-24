import 'package:child_vaccination/helper/helperFunction.dart';
import 'package:child_vaccination/screen/MyHomePage.dart';
import 'package:child_vaccination/screen/RegisterPage.dart';
import 'package:child_vaccination/screen/ResetPassword.dart';
import 'package:child_vaccination/services/authenticationService.dart';
import 'package:child_vaccination/shared/validity.dart';
import 'package:child_vaccination/widget/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formkey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  String email = "";
  String password = "";
  bool _isLoading = false;
  bool passwordVisible = true;
  AuthenticationService authenticationService = AuthenticationService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "IMMUNIFY",
                        style: GoogleFonts.merriweather(
                          textStyle: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.1,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Unlock exclusive resources and tools for your child\'s success - Login now!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Image
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),
                      const SizedBox(height: 8),
                      // Email
                      TextFormField(
                        controller: _emailTextController,
                        validator: (value) => Validator.validateEmail(
                            email: _emailTextController.text),
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      // Password
                      TextFormField(
                        controller: _passwordTextController,
                        validator: (value) => Validator.validatePassword(
                            password: _passwordTextController.text),
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(
                            Icons.password_outlined,
                            color: Theme.of(context).primaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            color: Theme.of(context).primaryColor,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      // forget password option
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          forgetPassword();
                        },
                        child: const Text(
                          "Forget Password ?",
                          style: TextStyle(
                            color: Color.fromARGB(255, 160, 195, 224),
                          ),
                        ),
                      ),
                      const SizedBox(height: 13),
                      // login into App
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            login();
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      // Google Sign In option
                      const SizedBox(height: 13),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            loginWithGoogle();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/google.png',
                                height: 24,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                "Sign In with Google",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Register the account
                      const SizedBox(
                        height: 15,
                      ),
                      Text.rich(
                        TextSpan(
                            text: "Don't have an account?",
                            style: const TextStyle(
                                color: Colors.blueGrey, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "Register here",
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterPage(),
                                        ),
                                      );
                                    })
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // login function
  login() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authenticationService
          .loginInUserWithEmailAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          // move to home page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePage(),
            ),
          );
          _emailTextController.clear();
          _passwordTextController.clear();
        } else {
          showSnackbar(context, Colors.redAccent, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  // forget password
  forgetPassword() {
    // move to resetPassword page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResetPassword(),
      ),
    );
  }

  // login with google
  loginWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    await authenticationService.SignInWithGoogle().then((value) {
      if (value == true) {
        // move to home page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
        );
      } else {
        showSnackbar(context, Colors.redAccent, value);
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
}
