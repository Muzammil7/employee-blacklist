import 'package:employeeblacklistdata/commonwidgets/appbutton.dart';
import 'package:employeeblacklistdata/commonwidgets/apptext.dart';
import 'package:employeeblacklistdata/commonwidgets/apptextfield.dart';
import 'package:employeeblacklistdata/login/controllers/logincontroller.dart';
import 'package:employeeblacklistdata/res/colors.dart';
import 'package:employeeblacklistdata/res/size.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String route = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _company = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  dynamic _register;
  dynamic _error;

  @override
  void initState() {
    LoginController().startStream();
    _register = loginStream.map((LoginData data) => data.register).distinct();
    _error = loginStream.map((LoginData data) => data.error).distinct();
    super.initState();
  }

  @override
  void dispose() {
    loginController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        padding: EdgeInsets.only(left: Dts(context).width * 0.05),
        height: Dts(context).height,
        width: Dts(context).width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                  width: Dts(context).width * 0.9,
                  child: AppText(
                    text: 'Employee Blacklist Data',
                    size: 28,
                    weight: FontWeight.w600,
                    color: theme,
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                width:
                    Dts(context).width > 650 ? 600 : Dts(context).width * 0.9,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    const AppText(
                        text: 'Login with Email and Password', size: 16),

                    // input field for user registration data

                    StreamBuilder<Object>(
                        stream: _register,
                        builder: (context, snapshot) {
                          if (loginData.register == true) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                AppTextField(controller: _name, hint: 'Name'),
                                const SizedBox(
                                  height: 20,
                                ),
                                AppTextField(
                                  controller: _company,
                                  hint: 'Company Name',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                AppTextField(
                                  controller: _number,
                                  hint: 'Mobile Number',
                                ),
                              ],
                            );
                          }
                          return Container();
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    AppTextField(
                        controller: _email, hint: 'Enter Email Address'),
                    const SizedBox(
                      height: 20,
                    ),
                    AppTextField(
                      controller: _password,
                      hint: 'Enter Password',
                      obsecure: true,
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    //input field for user registration data

                    StreamBuilder<Object>(
                        stream: _register,
                        builder: (context, snapshot) {
                          if (loginData.register == true) {
                            return Column(
                              children: [
                                AppTextField(
                                  controller: _confirmPassword,
                                  hint: 'Confirm Password',
                                  obsecure: true,
                                  maxLines: 1,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            );
                          }
                          return Container();
                        }),
                    StreamBuilder<Object>(
                        stream: _error,
                        builder: (context, snapshot) {
                          if (loginData.error != '') {
                            return Column(
                              children: [
                                SizedBox(
                                  width: Dts(context).width > 650
                                      ? 500
                                      : Dts(context).width * 0.6,
                                  child: AppText(
                                    text: loginData.error,
                                    size: 14,
                                    color: Colors.red,
                                    align: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            );
                          }
                          return Container();
                        }),

                    //login or register button

                    StreamBuilder<Object>(
                        stream: _register,
                        builder: (context, snapshot) {
                          return AppButton(
                              text: (loginData.register == true)
                                  ? 'Register'
                                  : 'Login',
                              ontap: () {
                                if (loginData.register == true) {
                                  if (_name.text.isNotEmpty &&
                                      _company.text.isNotEmpty &&
                                      _number.text.isNotEmpty &&
                                      _email.text.isNotEmpty &&
                                      _password.text.isNotEmpty &&
                                      _confirmPassword.text.isNotEmpty) {
                                    if (loginData.error != '') {
                                      loginData.error = '';
                                      loginController.add(loginData);
                                    }
                                    String pattern =
                                        r"^[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])*$";
                                    RegExp regex = RegExp(pattern);
                                    if (regex.hasMatch(_email.text)) {
                                      if (_password.text ==
                                          _confirmPassword.text) {
                                        LoginController().registerUser(
                                            _name.text,
                                            _company.text,
                                            _number.text,
                                            _email.text,
                                            _password.text,
                                            context);
                                      } else {
                                        loginData.error =
                                            'Password and Confirm Password must be same';
                                        loginController.add(loginData);
                                      }
                                    } else {
                                      loginData.error =
                                          'please enter valid email address';
                                      loginController.add(loginData);
                                    }
                                  } else {
                                    loginData.error =
                                        'please enter all details to proceed';
                                    loginController.add(loginData);
                                  }
                                } else {
                                  if (_email.text.isNotEmpty &&
                                      _password.text.isNotEmpty) {
                                    if (loginData.error != '') {
                                      loginData.error = '';
                                      loginController.add(loginData);
                                    }
                                    String pattern =
                                        r"^[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])*$";
                                    RegExp regex = RegExp(pattern);
                                    if (regex.hasMatch(_email.text)) {
                                      LoginController().login(
                                          _email.text, _password.text, context);
                                    } else {
                                      loginData.error =
                                          'please enter valid email address';
                                      loginController.add(loginData);
                                    }
                                  } else {
                                    loginData.error =
                                        'please enter all details to proceed';
                                    loginController.add(loginData);
                                  }
                                }
                              });
                        })
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // login or register changing option

              Container(
                width:
                    Dts(context).width > 650 ? 600 : Dts(context).width * 0.9,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12)),
                alignment: Alignment.center,
                child: StreamBuilder<Object>(
                    stream: _register,
                    builder: (context, snapshot) {
                      return AppButton(
                        text: (loginData.register == false)
                            ? 'Register as new user'
                            : 'Login if already exist',
                        color: Colors.transparent,
                        ontap: () {
                          if (loginData.register == true) {
                            loginData.register = false;
                          } else {
                            loginData.register = true;
                          }
                          loginController.add(loginData);
                        },
                        textColor: theme,
                        size: 18,
                      );
                    }),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
