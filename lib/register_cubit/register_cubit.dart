import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_final/register_cubit/register_states.dart';
import 'package:social_final/data_models/user_data_model.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;

  ToggleSuffixIcon() {
    isPassword = !isPassword;
    emit(ToggleSuffixIconState());
  }

  UserRegister({
    required String email,
    required String password,
    required String name ,
    required String phone,
     String? fcmToken,

  }) {

    emit(UserRegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      UserCreate(
        uId: value.user!.uid,
        name: name,
        email: email,
        phone: phone,
        fcmToken: fcmToken
      );
      emit(UserRegisterSuccessfullyState());
    }).catchError((error) {
      emit(UserRegisterErrorState());
    });
  }

  UserCreate({
    required String uId,
    required String name,
    required String email,
    required String phone,
     String? fcmToken,
  })async {
    emit(UserCreateLoadingState());
    UserModel user = UserModel(
      phone: phone,
      name: name,
      email: email,
      fcmToken: fcmToken,
      image:
          'https://img.freepik.com/premium-photo/tiny-cute-adorable-animal_727939-188.jpg?size=338&ext=jpg&ga=GA1.2.190088039.1657057581',
      cover:
          'https://img.freepik.com/premium-photo/cowboy-riding-horse-against-sunset-sky-with-planets-background-digital-art-style_787667-1723.jpg?size=626&ext=jpg&ga=GA1.2.190088039.1657057581',
      uId: uId,
      bio: 'Write your bio .........',
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(user.ToMap())
        .then((value) {
          emit(UserCreateSuccessfullyState());
    })
        .catchError((error) {
          emit(UserCreateErrorState());
          print(error);
    });
  }
}
