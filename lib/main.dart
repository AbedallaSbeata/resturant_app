import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:resturant_app/Manager/add_data.dart';
import 'package:resturant_app/cubit/cubit.dart';
import 'package:resturant_app/home/start_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: StartApp(),
      ),
    );
  }
}
