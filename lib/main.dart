import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'package:taxi_line_driver/core/service_locator.dart';
import 'package:taxi_line_driver/features/accounting/presentation/controller/auth_controller.dart';
import 'package:taxi_line_driver/features/accounting/presentation/screen/auth_screen.dart';

import 'package:taxi_line_driver/features/cabing/presentation/screen/navigation_screen.dart';
import 'package:taxi_line_driver/features/main_screen/home_screen.dart';

import 'features/main_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUp();
  final container = ProviderContainer();
  final authController = container.read(authControllerProvider);
  WidgetsBinding.instance!
      .addObserver(LifeCycleEventHandler(authController: authController));
  await Firebase.initializeApp();
  runApp(UncontrolledProviderScope(
    child: const MyApp(),
    container: container,
  ));
}

class LifeCycleEventHandler extends WidgetsBindingObserver {
  AuthController authController;

  LifeCycleEventHandler({
    required this.authController,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (authController.isAvailable) {
          authController.makeDriverOffline();
        }
        //make driver offline
        break;
      case AppLifecycleState.resumed:
        if (authController.wasAvailable) {
          authController.makeDriverOnline(LatLng(
              authController.currentLocationData.latitude!,
              authController.currentLocationData.longitude!));
        }

        // make driver online / resume driver state
        break;
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    super.dispose();
    ProviderScope.containerOf(context).dispose();
  }

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
              return const SplashCreen();
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
                          builder: (context, snapshot) =>
                              snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? const SplashCreen()
                                  : const HomePage());
                    } else {
                      return const HomePage();
                    }
                  },
                );
              }
            }
          }),
      routes: {
        NavigationScreen.routeName: (context) => const NavigationScreen()
      },
    );
  }
}

