import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../reusable_components/reusable_components.dart';
import '../social_cubit/social_cubit.dart';
import '../social_cubit/social_states.dart';

class EditProfileScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();
  static String route = 'EditProfileScreen';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is UpdateUserDataSuccessfullyState) {}
      },
      builder: (context, state) {
        var user = SocialCubit.get(context).user;
        return ConditionalBuilder(
          condition: user != null,
          builder: (context) {
            nameController.text = user!.name;
            emailController.text = user.email;
            phoneController.text = user.phone;
            bioController.text = user.bio;
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Edit Profile',
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              Align(
                                child: Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    Container(
                                      height: 250,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: Cover(context),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.blue,
                                        child: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onTap: () {
                                        SocialCubit.get(context)
                                            .GetCoverImage();
                                      },
                                    ),
                                  ],
                                ),
                                alignment: AlignmentDirectional.topStart,
                              ),
                              Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [
                                  CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage: Profile(context),
                                  ),
                                  InkWell(
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.blue,
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      SocialCubit.get(context)
                                          .GetProfileImage();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Row(
                          children: [
                            if (SocialCubit.get(context).profileImage != null)
                              ConditionalBuilder(
                                condition: state is ! UploadProfileImageLoadingState,
                                builder: (context)=>Expanded(
                                  child: BuildMaterialButton(
                                    onPressed: () {
                                      SocialCubit.get(context).UploadProfileImage(
                                        name: nameController.text,
                                        email: emailController.text,
                                        bio: bioController.text,
                                        phone: phoneController.text,
                                      );
                                    },
                                    label: 'Update Profile Image & Data ',
                                  ),
                                ),
                                fallback: (context)=> Center(child: CircularProgressIndicator()),
                              ),
                            SizedBox(
                              width: 15.0,
                            ),
                            if (SocialCubit.get(context).coverImage != null)
                              ConditionalBuilder(
                                condition: state is ! UploadCoverImageLoadingState,
                                builder: (context)=>Expanded(
                                  child: BuildMaterialButton(
                                    onPressed: () {
                                      SocialCubit.get(context).UploadCoverImage(
                                        name: nameController.text,
                                        email: emailController.text,
                                        bio: bioController.text,
                                        phone: phoneController.text,
                                      );
                                    },
                                    label: 'Update Cover Image & Data',
                                  ),
                                ),
                                fallback: (context)=> Center(child: CircularProgressIndicator()),
                              ),

                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        BuildTextFormField(
                          controller: nameController,
                          label: 'Name',
                          radius: 20,
                          pIcon: Icons.person,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name can\'t be empty ';
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        BuildTextFormField(
                          controller: emailController,
                          label: 'Email',
                          radius: 20,
                          pIcon: Icons.email_outlined,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email can\'t be empty ';
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        BuildTextFormField(
                          controller: phoneController,
                          label: 'Phone',
                          pIcon: Icons.phone_android,
                          radius: 20,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Phone can\'t be empty ';
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        BuildTextFormField(
                          controller: bioController,
                          label: 'Bio',
                          pIcon: Icons.info_outline,
                          radius: 20,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Bio can\'t be empty ';
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        BuildMaterialButton(
                          onPressed: () {
                            SocialCubit.get(context).UpdateUserData(
                              name: nameController.text,
                              email: emailController.text,
                              bio: bioController.text,
                              phone: phoneController.text,
                            );
                          },
                          label: 'Update Data',
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Profile(context) {
    if (SocialCubit.get(context).profileImage != null) {
      return FileImage(SocialCubit.get(context).profileImage!);
    } else {
      return NetworkImage(SocialCubit.get(context).user!.image);
    }
  }

  Cover(context) {
    if (SocialCubit.get(context).coverImage != null) {
      return FileImage(SocialCubit.get(context).coverImage!);
    } else {
      return NetworkImage(SocialCubit.get(context).user!.cover);
    }
  }
}
