import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_final/cashe_helper/cashe_helper.dart';
import 'package:social_final/login_cubit/login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;

  ToggleSuffixIcon() {
    isPassword = !isPassword;
    emit(ToggleSuffixIconState());
  }

  UserLogin({
    required String email,
    required String password,
  }) {
    emit(UserLoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      CasheHelper.SaveData(
        key: 'uId',
        value: value.user!.uid,
      );
      emit(UserLoginSuccessfullyState());
    }).catchError((error) {
      emit(UserLoginErrorState());
    });
  }
}
