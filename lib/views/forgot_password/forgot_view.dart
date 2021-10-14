import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_implementation/constants.dart';
import 'package:flutter_bloc_implementation/cubits/auth/auth_cubit.dart';
import 'package:flutter_bloc_implementation/widgets/custom_button.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({Key key}) : super(key: key);
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthForgotPasswordError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                      backgroundColor: Colors.red, content: Text(state.err)),
                );
            }
            if (state is AuthForgotPasswordSuccess) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                      content: Text('Reset link has been sent to your email!')),
                );
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is AuthDefault) {
              return _buildInitialScreen(context);
            } else if (state is AuthForgotPasswordLoading) {
              return loader();
            } else if (state is AuthForgotPasswordSuccess) {
              return _buildInitialScreen(context);
            } else {
              return _buildInitialScreen(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildInitialScreen(BuildContext context) {
    return SafeArea(
      child: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Center(
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
                const Spacer(),
                const FlutterLogo(size: 100.0),
                const SizedBox(height: 15.0),
                const Text(
                  "Forgot Password?",
                  style: kHeadingStyle,
                ),
                const SizedBox(height: 25.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: FormBuilderTextField(
                    textInputAction: TextInputAction.done,
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
                const SizedBox(height: 25.0),
                _SendLinkButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      final authCubit = BlocProvider.of<AuthCubit>(context);
                      await authCubit.forgotPassword(
                          _formKey.currentState.fields['email'].value);
                    }
                  },
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loader() {
    return const Center(child: CircularProgressIndicator());
  }
}

class _SendLinkButton extends StatelessWidget {
  final Function onPressed;

  const _SendLinkButton({
    Key key,
    this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: onPressed,
      child: const Text("Send Link"),
    );
  }
}
