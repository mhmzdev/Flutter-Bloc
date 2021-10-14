import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_implementation/constants.dart';
import 'package:flutter_bloc_implementation/cubits/auth/auth_cubit.dart';
import 'package:flutter_bloc_implementation/widgets/custom_button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSignUpError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                      backgroundColor: Colors.red, content: Text(state.err)),
                );
            } else if (state is AuthSignUpSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                      content: Text('Account has been created successfully!')),
                );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is AuthDefault) {
              return _buildInitialForm();
            } else if (state is AuthSignUpLoading) {
              return _loading();
            } else if (state is AuthSignUpSuccess) {
              return _buildInitialForm();
            } else {
              return _buildInitialForm();
            }
          },
        ),
      ),
    );
  }

  Widget _buildInitialForm() {
    return SafeArea(
      child: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: BackButton(
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const FlutterLogo(size: 80),
                const SizedBox(height: 15.0),
                const Text(
                  "Flutter Bloc - Implementations",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                const SizedBox(height: 20.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sign Up',
                    style: kHeadingStyle,
                  ),
                ),
                const SizedBox(height: 8.0),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("It's quick and easy"),
                ),
                const SizedBox(height: 25.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: FormBuilderTextField(
                    textInputAction: TextInputAction.next,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.match(context, r'[a-zA-Z]',
                          errorText: "Name can only be alphabets!"),
                    ]),
                    name: 'name',
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      prefixIcon: const Icon(Icons.person),
                      hintText: 'Full Name',
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
                    textInputAction: TextInputAction.next,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                      FormBuilderValidators.email(context),
                    ]),
                    name: 'email',
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      prefixIcon: const Icon(Icons.email),
                      hintText: 'Email Address',
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
                    textInputAction: TextInputAction.done,
                    validator: FormBuilderValidators.required(context),
                    obscureText: _isObscure,
                    name: 'password',
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8.0),
                      prefixIcon: const Icon(Icons.lock_open),
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
                _SignUpButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      final authCubit = BlocProvider.of<AuthCubit>(context);
                      await authCubit.signUp(
                          _formKey.currentState.fields['name'].value,
                          _formKey.currentState.fields['email'].value,
                          _formKey.currentState.fields['password'].value);
                    }
                  },
                ),
                const SizedBox(height: 30.0),
                const Text(
                  "By clicking sign up you are agreeing to our Terms of Services",
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loading() {
    return const SizedBox(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final Function onPressed;

  const _SignUpButton({
    Key key,
    this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      child: const Text(
        "Sign Up",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
