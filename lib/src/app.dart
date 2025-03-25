import 'package:flutter/material.dart';
import 'package:flutter_application_2/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Individual Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          // Handle auth state changes
        },
        child: const LoginScreen(),
      ),
    );
  }
}
