import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc_implementation/app_routes.dart';
import 'package:flutter_bloc_implementation/constants.dart';
import 'package:flutter_bloc_implementation/cubits/auth/auth_cubit.dart';
import 'package:flutter_bloc_implementation/views/home/home_view.dart';
import 'package:flutter_bloc_implementation/widgets/custom_button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLoginError) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(state.errorMsg)),
                  );
              }

              if (state is AuthGmailError) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(state.errorMsg)),
                  );
              }

              if (state is AuthLoginSuccess || state is AuthGmailSuccess) {
                if (state is AuthLoginSuccess) _formKey.currentState.reset();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => HomeView(
                              user: state.user,
                            )));
              }
            },
            builder: (context, state) => buildInitialScreen(),
          ),
        ),
      ),
    );
  }

  Widget buildInitialScreen() {
    return SafeArea(
      child: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FlutterLogo(size: 100.0),
                const SizedBox(height: 15.0),
                const Text(
                  "Flutter Bloc - Implementations",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                const SizedBox(height: 25.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.email(context),
                    ]),
                    name: 'email',
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      prefixIcon: const Icon(Icons.email),
                      hintText: 'Enter email',
                      hintStyle: kHintStyle,
                      fillColor: Colors.grey[200],
                      filled: true,
                      enabledBorder: kOutlineBorder,
                      focusedBorder: kOutlineBorder,
                      errorBorder: kErrorOutlineBorder,
                      focusedErrorBorder: kErrorOutlineBorder,
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: FormBuilderTextField(
                    validator: FormBuilderValidators.required(context),
                    obscureText: _isObscure,
                    name: 'password',
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Enter password',
                      hintStyle: kHintStyle,
                      fillColor: Colors.grey[200],
                      filled: true,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                        child: Icon(
                          _isObscure
                              ? Icons.radio_button_off
                              : Icons.radio_button_checked,
                          size: 20.0,
                        ),
                      ),
                      enabledBorder: kOutlineBorder,
                      focusedBorder: kOutlineBorder,
                      errorBorder: kErrorOutlineBorder,
                      focusedErrorBorder: kErrorOutlineBorder,
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
                _LoginButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      final authCubit = BlocProvider.of<AuthCubit>(context);
                      await authCubit.login(
                          _formKey.currentState.fields['email'].value,
                          _formKey.currentState.fields['password'].value);
                    }
                  },
                ),
                TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.forgotPassword),
                    child: const Text("Forgot Password?")),
                const Divider(height: 20.0, endIndent: 8.0, indent: 8.0),
                CustomButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.signup),
                    child: const Text("Create an Account")),
                const SizedBox(height: 40.0),
                const Text('Or', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20.0),
                const SocialSignIn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoader() => SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );

  // override the back button on android
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              "Exit Application",
            ),
            content: const Text(
              "Are You Sure?",
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.black54),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        )) ??
        false;
  }
}

class _LoginButton extends StatelessWidget {
  final Function onPressed;

  const _LoginButton({
    Key key,
    this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AuthLoginLoading) {
            return kLoaderBtn;
          } else {
            return const Text("Login");
          }
        },
      ),
    );
  }
}

class SocialSignIn extends StatelessWidget {
  const SocialSignIn({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () async {
            final authCubit = BlocProvider.of<AuthCubit>(context);
            await authCubit.gmailAuth();
          },
          icon: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is AuthGmailLoading) {
                return const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                );
              } else {
                return const Icon(
                  FontAwesomeIcons.google,
                  color: Colors.red,
                );
              }
            },
          ),
        ),
        const SizedBox(width: 15.0),
        IconButton(
          onPressed: () async {
            final authCubit = BlocProvider.of<AuthCubit>(context);
            await authCubit.facebookAuth();
          },
          icon: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is AuthFBLoading) {
                return const SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                );
              } else {
                return const Icon(
                  FontAwesomeIcons.facebook,
                  color: Colors.blue,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
