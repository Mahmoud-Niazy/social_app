abstract class LoginStates {}
class LoginInitialState extends LoginStates {}

class ToggleSuffixIconState extends LoginStates{}

class UserLoginLoadingState extends LoginStates {}
class UserLoginSuccessfullyState extends LoginStates{}
class UserLoginErrorState extends LoginStates{}