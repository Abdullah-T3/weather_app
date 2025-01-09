import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/MVVM/View_Models/Authcubit/auth_cubit.dart';
import 'package:weather_app/Responsive/UiComponanets/InfoWidget.dart';
import 'package:weather_app/helpers/extantions.dart';
import 'package:weather_app/routing/routs.dart';
import '../../../../theming/styles.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.pushReplacementNamed(Routes.homePage);
          context.read<AuthCubit>().close();
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is Unauthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Sign Up Failed")),
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

          return Infowidget(
            builder: (context, deviceInfo) {
              return Scaffold(
                body: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: deviceInfo.screenWidth * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: deviceInfo.localHeight * 0.1),
                          Image.asset(
                            "assets/image/logo_3.png",
                            width: deviceInfo.screenWidth * 0.5,
                            height: deviceInfo.localHeight * 0.2,
                          ),
                          Text("Welcome to Breeze", style: TextStyles.title),
                          const Text(
                            "Stay updated with accurate forecasts anytime, anywhere.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF9399A2), fontSize: 14),
                          ),
                          const SizedBox(height: 75),
                          CustomTextField(
                            controller: fullNameController,
                            text: "Full Name",
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return "Full Name is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: emailController,
                            text: "Enter Your Email",
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              } else if (!value.contains('@')) {
                                return "Please enter a valid email";
                              } else if (!value.endsWith('.com')) {
                                return "Please enter a valid email";
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
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: confirmPasswordController,
                            text: "Confirm Your Password",
                            password: true,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return "Confirm password is required";
                              } else if (value != passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 60),
                          CustomButton(
                            text: 'Register',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthCubit>().signUp(
                                      emailController.text,
                                      passwordController.text,
                                    );
                              }
                            },
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Already have an account?", style: TextStyles.subtitle),
                              TextButton(
                                onPressed: () {
                                  context.pushReplacementNamed(Routes.loginScreen);
                                },
                                child: Text(
                                  'Sign In',
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
          );
        },
      ),
    );
  }
}
