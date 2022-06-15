import 'dart:async';

import 'package:dafluta/dafluta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nonzero/screens/main_screen.dart';
import 'package:nonzero/services/localizations.dart';
import 'package:nonzero/services/routes.dart';
import 'package:nonzero/widgets/custom_button.dart';

class ConnectionScreen extends StatelessWidget {
  final SplashState state = SplashState();

  static FadeRoute instance() => FadeRoute(ConnectionScreen());

  @override
  Widget build(BuildContext context) {
    return DarkStatusBar(
      child: StateProvider<SplashState>(
        state: state,
        builder: (context, state) => Scaffold(
          body: body(),
        ),
      ),
    );
  }

  Widget body() {
    if (state.showSignIn) {
      return SignInButton(state);
    } else if (state.showLoading) {
      return const Waiting();
    } else {
      return const Empty();
    }
  }
}

class SignInButton extends StatelessWidget {
  final SplashState state;

  const SignInButton(this.state);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 150,
        child: CustomButton(
          text: Localized.get.connectionSignIn,
          onPressed: state.onSignIn,
        ),
      ),
    );
  }
}

class Waiting extends StatelessWidget {
  const Waiting();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class SplashState extends BaseState {
  bool showLoading = false;
  bool showSignIn = false;

  @override
  Future onLoad() async {
    final Stream<User?> stream = FirebaseAuth.instance.authStateChanges();
    StreamSubscription? subscription;
    subscription = stream.listen((user) {
      subscription?.cancel();

      if (user == null) {
        showLoading = false;
        showSignIn = true;
        notify();
      } else {
        openMainScreen();
      }
    });
  }

  Future onSignIn() async {
    showLoading = true;
    showSignIn = false;
    notify();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    openMainScreen();
  }

  void openMainScreen() => Routes.pushReplacement(MainScreen.instance());
}
