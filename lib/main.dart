import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/cubit/auth_cubit.dart';
import 'package:flutter_application_2/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // ignore: non_constant_identifier_names
  dynamic AuthService;

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthCubit>(
        create: (_) => AuthCubit(AuthService),
      ),
    ],
    child: const MyApp(),
  ));
}

// ignore: non_constant_identifier_names

