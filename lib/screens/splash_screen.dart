import 'package:dafluta/dafluta.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nonzero/screens/main_screen.dart';
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
          body: state.showLoading ? const Waiting() : SignInButton(state),
        ),
      ),
    );
  }
}

class SignInButton extends StatelessWidget {
  final SplashState state;

  const SignInButton(this.state);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: CustomButton(
          text: 'Sign in',
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

  Future onSignIn() async {
    showLoading = true;
    notify();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    Routes.pushReplacement(MainScreen.instance());
  }
}
