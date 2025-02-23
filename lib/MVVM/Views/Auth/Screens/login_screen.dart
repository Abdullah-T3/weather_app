import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/MVVM/View_Models/Authcubit/auth_cubit.dart';
import 'package:weather_app/Responsive/UiComponanets/InfoWidget.dart';
import 'package:weather_app/helpers/cherryToast/CherryToastMsgs.dart';
import 'package:weather_app/helpers/extantions.dart';
import 'package:weather_app/routing/routs.dart';

import '../../../../theming/styles.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Check if the user is already logged in
    final authCubit = context.read<AuthCubit>();
    if (authCubit.state is Authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pushReplacementNamed(Routes.homePage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Infowidget(
      builder: (context, deviceInfo) {
        return BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              context.pushReplacementNamed(Routes.homePage);
            } else if (state is AuthError) {
              CherryToastMsgs.CherryToastError(
                info: deviceInfo,
                context: context,
                title: 'Error',
                description: state.message,
              );
            }
          },
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              return Scaffold(
                body: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: deviceInfo.screenWidth * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: deviceInfo.localHeight * 0.15),
                          Text("Welcome back", style: TextStyles.title),
                          Container(
                            width: double.infinity,
                            height: deviceInfo.localHeight * 0.2,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/image/logo_3.png'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          CustomTextField(
                            controller: emailController,
                            text: "Enter Your Email",
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: passwordController,
                            text: "Enter Your Password",
                            password: true,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return "Password is required";
                              } else if (value.length < 8) {
                                return "Password should be at least 8 characters long";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: deviceInfo.localHeight * 0.1),
                          CustomButton(
                            text: 'Login',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthCubit>().signIn(
                                      emailController.text,
                                      passwordController.text,
                                    );
                              } else {
                                CherryToastMsgs.CherryToastError(
                                  info: deviceInfo,
                                  context: context,
                                  title: 'Error',
                                  description: 'Please enter valid data',
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?", style: TextStyles.subtitle),
                              TextButton(
                                onPressed: () {
                                  context.pushReplacementNamed(Routes.signUpScreen);
                                },
                                child: Text(
                                  'Sign Up',
                                  style: TextStyles.subtitle.copyWith(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
