import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:social_final/register_cubit/register_cubit.dart';
import 'package:social_final/register_cubit/register_states.dart';
import 'package:social_final/reusable_components/reusable_components.dart';


class RegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  static String route = 'RegisterScreen';
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is UserRegisterSuccessfullyState) {
            Navigator.pop(context);
            MotionToast.success(
              title:  Text("Register Successfully"),
              description:  Text(""),
              toastDuration: Duration(
                seconds: 3,
              ),
            ).show(context);

            // Fluttertoast.showToast(
            //   msg: 'User Register Successfully',
            //   backgroundColor: Colors.green,
            // ).then((_){
            //   Navigator.pop(context);
            // });
          }
          print(state);
        },
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register ',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Register now to communicate with new friends',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        BuildTextFormField(
                          controller: emailController,
                          radius: 20,
                          label: 'Email',
                          pIcon: Icons.email_outlined,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Email can\'t be empty ';
                            }
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        BuildTextFormField(
                          controller: passwordController,
                          radius: 20,
                          label: 'Password',
                          isPassword: cubit.isPassword,
                          pIcon: Icons.lock_outline,
                          onPressedOnSIcon: () {
                            cubit.ToggleSuffixIcon();
                          },
                          sIcon: cubit.isPassword
                              ? Icons.remove_red_eye_outlined
                              : Icons.visibility_off_outlined,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Password can\'t be empty ';
                            }
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        BuildTextFormField(
                          controller: nameController,
                          radius: 20,
                          label: 'Name',
                          pIcon: Icons.person,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Name can\'t be empty ';
                            }
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        BuildTextFormField(
                          controller: phoneController,
                          radius: 20,
                          type: TextInputType.phone,
                          label: 'Phone',
                          pIcon: Icons.phone,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Phone can\'t be empty ';
                            }
                          },
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        ConditionalBuilder(
                          condition: state is! UserRegisterLoadingState,
                          builder: (context) => BuildMaterialButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                cubit.UserRegister(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                );
                              }
                            },
                            label: 'REGISTER',
                          ),
                          fallback: (context) => Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
