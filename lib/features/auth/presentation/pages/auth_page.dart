// lib/features/auth/presentation/pages/auth_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kriolbusiness/config/theme/app_colors.dart';
import 'package:kriolbusiness/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kriolbusiness/features/auth/presentation/bloc/auth_event.dart';
import 'package:kriolbusiness/features/auth/presentation/bloc/auth_state.dart';
import 'package:kriolbusiness/features/auth/presentation/widgets/social_login_button.dart';
//import 'package:sign_in_with_apple/sign_in_with_apple.dart';

enum AuthMode { login, signup }

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthMode _authMode = AuthMode.login;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.login) {
        _authMode = AuthMode.signup;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  void _submitAuthForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final authBloc = BlocProvider.of<AuthBloc>(context);

    if (_authMode == AuthMode.login) {
      authBloc.add(AuthLoginRequested(
        email: _emailController.text,
        password: _passwordController.text,
      ));
    } else {
      authBloc.add(AuthRegisterRequested(
        email: _emailController.text,
        password: _passwordController.text,
      ));
    }
  }

  /*Future<void> _handleAppleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print(credential);
      // TODO: Enviar credential.identityToken para o AuthBloc para autenticação com Apple

    } catch (e) {
      print('Erro ao fazer login com Apple: $e');
      // Trate o erro, exiba uma mensagem para o usuário
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.prussianBlue,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Bem-vindo, ${state.user.email}!'))
            );
            // TODO: Navegar para a tela principal do aplicativo
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro: ${state.message}'))
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'KriolBusiness',
                    style: TextStyle(
                      color: AppColors.papayaWhip,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: AppColors.barnRed.withOpacity(0.5),
                          offset: const Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Card(
                    margin: const EdgeInsets.all(20.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 8.0,
                    color: AppColors.prussianBlue.withOpacity(0.7),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'E-mail',
                                labelStyle: TextStyle(color: AppColors.airSuperiorityBlue),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: AppColors.airSuperiorityBlue.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: AppColors.fireBrick),
                                ),
                                prefixIcon: Icon(Icons.email, color: AppColors.airSuperiorityBlue),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: AppColors.papayaWhip),
                              validator: (value) {
                                if (value!.isEmpty || !value.contains('@')) {
                                  return 'E-mail inválido!';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                labelStyle: TextStyle(color: AppColors.airSuperiorityBlue),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: AppColors.airSuperiorityBlue.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: AppColors.fireBrick),
                                ),
                                prefixIcon: Icon(Icons.lock, color: AppColors.airSuperiorityBlue),
                              ),
                              obscureText: true,
                              style: TextStyle(color: AppColors.papayaWhip),
                              validator: (value) {
                                if (value!.isEmpty || value.length < 6) {
                                  return 'A senha deve ter pelo menos 6 caracteres!';
                                }
                                return null;
                              },
                            ),
                            if (_authMode == AuthMode.signup)
                              const SizedBox(height: 20),
                            if (_authMode == AuthMode.signup)
                              TextFormField(
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                  labelText: 'Confirmar Senha',
                                  labelStyle: TextStyle(color: AppColors.airSuperiorityBlue),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: AppColors.airSuperiorityBlue.withOpacity(0.5)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: AppColors.fireBrick),
                                  ),
                                  prefixIcon: Icon(Icons.lock, color: AppColors.airSuperiorityBlue),
                                ),
                                obscureText: true,
                                style: TextStyle(color: AppColors.papayaWhip),
                                validator: _authMode == AuthMode.signup
                                    ? (value) {
                                        if (value != _passwordController.text) {
                                          return 'As senhas não coincidem!';
                                        }
                                        return null;
                                      }
                                    : null,
                              ),
                            const SizedBox(height: 30),
                            // Botão Principal de Login/Registro
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.barnRed,
                                    AppColors.fireBrick,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: ElevatedButton(
                                onPressed: state is AuthLoading ? null : _submitAuthForm, // Desabilita o botão durante o carregamento
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: state is AuthLoading
                                    ? const CircularProgressIndicator(color: Colors.white) // Mostra indicador de carregamento
                                    : Text(
                                        _authMode == AuthMode.login ? 'LOGIN' : 'REGISTRAR',
                                        style: TextStyle(
                                          color: AppColors.papayaWhip,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: state is AuthLoading ? null : _switchAuthMode, // Desabilita o botão durante o carregamento
                              child: Text(
                                _authMode == AuthMode.login
                                    ? 'Não tem uma conta? Registre-se'
                                    : 'Já tem uma conta? Faça Login',
                                style: TextStyle(color: AppColors.airSuperiorityBlue),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Text(
                              '- OU -',
                              style: TextStyle(color: AppColors.airSuperiorityBlue, fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                SocialLoginButton(
                                  icon: FontAwesomeIcons.google,
                                  iconColor: AppColors.barnRed,
                                  onPressed: state is AuthLoading ? null : () {  'Google login not implemented yet'; },
                                  isLoading: state is AuthLoading,
                                ),
                                const SizedBox(width: 20),
                                SocialLoginButton(
                                  icon: FontAwesomeIcons.facebook,
                                  iconColor: AppColors.barnRed,
                                  onPressed: state is AuthLoading ? null : () {  'Facebook login not implemented yet'; },
                                  isLoading: state is AuthLoading,
                                ),
                                if (Theme.of(context).platform == TargetPlatform.iOS) ...[
                                  const SizedBox(width: 20),
                                  SocialLoginButton(
                                    icon: FontAwesomeIcons.apple,
                                    iconColor: AppColors.barnRed,
                                    onPressed: state is AuthLoading ? null : () { 'Apple login not implemented yet'; },
                                    isLoading: state is AuthLoading,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}