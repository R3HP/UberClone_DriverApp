import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:taxi_line_driver/core/service_locator.dart';
import 'package:taxi_line_driver/features/accounting/presentation/controller/auth_controller.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isSignUp = false;
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _carModelController = TextEditingController();
  final _carPlateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final AuthController authController;
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController = ref.read(authControllerProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/auth_driver_bg.jpg'),
              fit: BoxFit.fill),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
          position: DecorationPosition.background,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(20.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7, sigmaY: 5),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 100),
                      reverseDuration: const Duration(milliseconds: 100),
                      curve: Curves.elasticIn,
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              Colors.white.withOpacity(0.5),
                              Colors.white.withOpacity(0.1)
                            ],
                                begin: AlignmentDirectional.topStart,
                                end: AlignmentDirectional.bottomEnd)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 40),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Use Your Email And Password to Login',
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              if (_isSignUp)
                                AuthFormTextField(
                                    controller: _userNameController,
                                    label: 'User Name'),
                              AuthFormTextField(
                                  controller: _emailController, label: 'Email'),
                              AuthFormTextField(
                                  controller: _passwordController,
                                  label: 'Password'),
                              if (_isSignUp)
                                AuthFormTextField(
                                    controller: _carModelController,
                                    label: 'Car Model'),
                              if (_isSignUp)
                                AuthFormTextField(
                                    controller: _carPlateController,
                                    label: 'License Plate'),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isSignUp = !_isSignUp;
                                    });
                                  },
                                  child: Text(
                                    _isSignUp
                                        ? 'Already A member ? Login'
                                        : 'Don\'t Have An Account Yet ? Create now',
                                  )),
                              ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (_isSignUp) {
                                        authController.createUser(
                                            _userNameController.text,
                                            _emailController.text,
                                            _passwordController.text,
                                            _carModelController.text,
                                            _carPlateController.text);
                                      } else {
                                        authController.loginWithEmailAndPassword(
                                            _emailController.text,
                                            _passwordController.text);
                                      }
                                    }
                                  },
                                  child: Text(_isSignUp ? 'Signup' : 'Signin'))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthFormTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const AuthFormTextField({
    Key? key,
    required this.controller,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: controller,
          validator: ((value) {
            final int treshold;
            switch (label) {
              case 'User Name':
                treshold = 8;
                break;
              case 'Password':
                treshold = 8;
                break;
              case 'Email':
                treshold = 8;
                break;
              case 'Car Model':
                treshold = 4;
                break;
              case 'License Plate':
                treshold = 5;
                break;
              default:
                treshold = 0;
                break;
            }
            if (value!.isEmpty || value.length < treshold) {
              return '$label must at least be $treshold characters';
            }
            if (label == 'Email' && !value.contains('@')) {
              return 'Email Should Have @ In It';
            }
          }),
          obscureText: true,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: label,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
