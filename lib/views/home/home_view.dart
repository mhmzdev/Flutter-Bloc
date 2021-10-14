import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_implementation/cubits/auth/auth_cubit.dart';

class HomeView extends StatelessWidget {
  final User user;
  const HomeView({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLogOut) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) => _homeWidget(context),
      ),
    );
  }

  Widget _homeWidget(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            user.photoURL != null
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.photoURL),
                  )
                : Container(),
            SizedBox(height: user != null ? 10.0 : 0.0),
            Text(user.email),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () async {
                final authCubit = BlocProvider.of<AuthCubit>(context);
                user.photoURL == null
                    ? await authCubit.logOut()
                    : await authCubit.gmailLogout();
                // should be done in some better way
                await authCubit.facebookLogout();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      );
}
