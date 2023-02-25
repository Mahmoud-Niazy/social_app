import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_final/dio_helper/dio.dart';
import 'package:social_final/screens/another_user_screen.dart';
import 'package:social_final/screens/comments_screen.dart';
import 'package:social_final/screens/edit_profile_screen.dart';
import 'package:social_final/screens/register_screen.dart';
import 'package:social_final/social_cubit/social_cubit.dart';
import 'package:social_final/social_layout/social_layout.dart';
import 'package:social_final/splash_screen/splash_screen.dart';
import 'cashe_helper/cashe_helper.dart';
import 'constants.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DioHelper.Init();
  FirebaseMessaging.onMessage.listen((event) {
    print('noti');
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('noti 2');

  });
 await  CasheHelper.Init();
  uId  = CasheHelper.GetData(key: 'uId');
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://mipmap/ic_launcher',
    [
      NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),

          ledColor: Colors.white)
    ],
  );
  runApp(MyApp());

}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SocialCubit()..GetUserData()..GetAllPosts()..GetAllUsers(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            caption: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
          ),
        ),
        initialRoute: '/',
        // uId == null?  '/' : SocialLayout.route,
        routes: {
          '/' : (context) => SplashScreen(),
          RegisterScreen.route : (context) => RegisterScreen(),
          SocialLayout.route : (context) => SocialLayout(),
          EditProfileScreen.route : (context)=> EditProfileScreen(),
          // PeopleWhoLikeScreen.route : (context)=> PeopleWhoLikeScreen(),
          CommentsScreen.route : (context)=> CommentsScreen(),
          AnotherUserScreen.route :(context)=> AnotherUserScreen(),
        },
        debugShowCheckedModeBanner: false ,
      ),
    );
  }
}