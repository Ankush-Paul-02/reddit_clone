import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/signin_button.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controllers/auth_controller.dart';
import 'package:reddit_clone/theme/palette.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInAsGuest(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.logoPath,
          height: 40,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => signInAsGuest(ref, context),
            child: 'Skip'.text.bold.color(Palette.blueColor).make(),
          )
        ],
      ),
      body: isLoading
          ? const Loader()
          : Column(
              children: [
                30.heightBox,
                'Dive into anything'
                    .text
                    .size(24)
                    .letterSpacing(0.5)
                    .bold
                    .make()
                    .centered(),
                Image.asset(
                  Constants.loginEmotePath,
                  height: 400,
                ).p(8),
                20.heightBox,
                const SigninButton(),
              ],
            ),
    );
  }
}
