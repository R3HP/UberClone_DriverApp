import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_line_driver/core/service_locator.dart';
import 'package:taxi_line_driver/features/accounting/presentation/controller/auth_controller.dart';
import 'package:taxi_line_driver/features/accounting/presentation/screen/auth_screen.dart';
import 'package:taxi_line_driver/features/main_screen/home_screen.dart';
import 'package:riverpod/riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setUp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'TaxiLine Driver',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, AsyncSnapshot<User?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SplashCreen();
              } else {
                if (snapshot.data == null) {
                  return const AuthScreen();
                } else {
                  return Consumer(
                    builder: (context, ref, child) {
                      final authController = ref.watch(authControllerProvider);
                      if (authController.currentDriver == null) {
                        return FutureBuilder(
                            future: authController.setCurrentDriver(),
                            builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting ?  SplashCreen() : const HomePage());
                      } else {
                        return const HomePage();
                      }
                    },
                  );
                }
              }
            }));
  }
}

class SplashCreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('splash sssshhshshshsh'),
    );
  }
}
