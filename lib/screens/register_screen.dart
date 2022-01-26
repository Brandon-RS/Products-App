import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

import 'package:products_app/services/services.dart';
import 'package:products_app/providers/providers.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/ui/input_decoration.dart';
import 'package:products_app/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  static const String routeName = 'Register';

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: padding.top + 200),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Crear cuenta', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                  children: [
                    const TextSpan(text: 'Ya tienes una cuenta?, '),
                    TextSpan(
                      text: 'Click aqui!',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushReplacementNamed(context, LoginScreen.routeName),
                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              prefixIcon: Icons.alternate_email,
              hintText: 'sample@sample.com',
              labelText: 'Email',
            ),
            cursorColor: Colors.deepPurple,
            onChanged: (value) => loginForm.email = value,
            validator: (value) => regExp.hasMatch(value ?? '') ? null : 'Email invalido :(',
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              prefixIcon: Icons.remove_red_eye_outlined,
              hintText: 'Your password',
              labelText: 'Password',
            ),
            cursorColor: Colors.deepPurple,
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              if (value != null && value.length >= 8) return null;
              return 'La contraseña debe tener 8 caracteres o mas';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            child: Text(
              loginForm.isLoading ? 'Espere ...' : 'Ingresar',
              style: const TextStyle(color: Colors.white),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            onPressed: loginForm.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final authService = Provider.of<AuthService>(context, listen: false);

                    if (!loginForm.isValidForm()) return;
                    loginForm.isLoading = true;

                    final String? errorMessage = await authService.createUser(loginForm.email, loginForm.password);

                    if (errorMessage == null) {
                      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                    } else {
                      // TODO: mostrar error en pantalla
                      print(errorMessage);
                      loginForm.isLoading = false;
                    }
                  },
          ),
        ],
      ),
    );
  }
}
