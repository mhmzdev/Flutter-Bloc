import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_implementation/app_routes.dart';
import 'package:flutter_bloc_implementation/cubits/auth/auth_cubit.dart';
import 'package:flutter_bloc_implementation/views/forgot_password/forgot_view.dart';
import 'package:flutter_bloc_implementation/views/home/home_view.dart';
import 'package:flutter_bloc_implementation/views/login/login_view.dart';
import 'package:flutter_bloc_implementation/views/signup/signup_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: AppRoutes.login,
        routes: <String, WidgetBuilder>{
          AppRoutes.login: (_) => const LoginView(),
          AppRoutes.signup: (_) => const SignUpView(),
          AppRoutes.forgotPassword: (_) => ForgotPasswordView(),
          AppRoutes.home: (_) => const HomeView(),
        },
      ),
    );
  }
}
