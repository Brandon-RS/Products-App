import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:products_app/providers/login_form_provider.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/ui/input_decoration.dart';
import 'package:products_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String routeName = 'Login';

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
                    Text('Login', style: Theme.of(context).textTheme.headline4),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Text('Crear una nueva cuenta', style: Theme.of(context).textTheme.button),
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
                    if (!loginForm.isValidForm()) return;
                    loginForm.isLoading = true;

                    // TODO: validar si el login es correcto.
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                  },
          ),
        ],
      ),
    );
  }
}
