import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:social_final/cashe_helper/cashe_helper.dart';
import 'package:social_final/login_cubit/login_cubit.dart';
import 'package:social_final/login_cubit/login_states.dart';
import 'package:social_final/screens/register_screen.dart';
import 'package:social_final/reusable_components/reusable_components.dart';
import 'package:social_final/social_cubit/social_cubit.dart';
import 'package:social_final/social_layout/social_layout.dart';

import '../constants.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is UserLoginSuccessfullyState) {
            uId = CasheHelper.GetData(key: 'uId');
            SocialCubit.get(context).GetUserData();
            // SocialCubit.get(context).GetAllPosts();
            // SocialCubit.get(context).GetAllUsers();
            NavigateAndRemove(
              context: context,
              route: SocialLayout.route,
            );
            MotionToast.success(
              title: Text("Login Successfully"),
              description: Text(""),
              toastDuration: Duration(
                seconds: 3,
              ),
            ).show(context);
            // CasheHelper.SaveData(key: 'Login', value: true).then((value) {
            //   if(value){
            //
            //   }
            // });
          }
          print(state);
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            // appBar: AppBar(),
            body: Stack(
              children: [
                Image.asset(
                  'assets/rm222-mind-14.jpg',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Login',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'login now to communicate with new friends',
                              style: Theme.of(context).textTheme.caption,
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            BuildTextFormField(
                              controller: emailController,
                              radius: 15,
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
                              radius: 15,
                              label: 'Password',
                              pIcon: Icons.lock_outline,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Password can\'t be empty ';
                                }
                              },
                              sIcon: cubit.isPassword
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.visibility_off_outlined,
                              isPassword: cubit.isPassword,
                              onPressedOnSIcon: () {
                                cubit.ToggleSuffixIcon();
                              },
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            ConditionalBuilder(
                              condition: state is! UserLoginLoadingState,
                              builder: (context) => BuildMaterialButton(
                                onPressed: () {
                                  if(formKey.currentState!.validate()){
                                    cubit.UserLogin(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                                label: 'LOGIN',
                              ),
                              fallback: (context) =>
                                  Center(child: CircularProgressIndicator()),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text('Don\'t have an account ? '),
                                TextButton(
                                  onPressed: () {
                                    NavigateWithName(
                                      context: context,
                                      route: RegisterScreen.route,
                                    );
                                  },
                                  child: Text(
                                    'Register now',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
