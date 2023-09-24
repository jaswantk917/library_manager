import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_management/blocs/auth/auth_bloc.dart';
import 'package:library_management/main.dart';
import 'package:library_management/screens/signin_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        log('listener in action ${state.authStatus}');
        if (state.authStatus == AuthStatus.unauthenticated) {
          log('not authenticated');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              return const SigninPage();
            }),
            (route) {
              log('route.settings.name: ${route.settings.name}');
              log('ModalRoute: ${ModalRoute.of(context)!.settings.name}');

              return route.settings.name ==
                      ModalRoute.of(context)!.settings.name
                  ? true
                  : false;
            },
          );
        } else if (state.authStatus == AuthStatus.authenticated) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePage(title: 'Library by Jas'),
            ),
          );
        }
      },
      child: const Scaffold(),
    );
  }
}
