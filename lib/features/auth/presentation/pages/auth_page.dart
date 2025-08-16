import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kriolbusiness/config/theme/app_colors.dart'; // Importe a classe AppColors centralizada
//import 'package:sign_in_with_apple/sign_in_with_apple.dart'; // Importe o pacote de login com Apple

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
      // Invalid!
      return;
    }
    _formKey.currentState!.save();

    // Lógica de autenticação (será implementada com BLoC/Firebase)
    if (_authMode == AuthMode.login) {
      print('Login com: ${_emailController.text} / ${_passwordController.text}');
    } else {
      print('Registro com: ${_emailController.text} / ${_passwordController.text} / ${_confirmPasswordController.text}');
    }
  }

  // Função para lidar com o login com Apple
  /*Future<void> _handleAppleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print(credential);
      // Envie o credential.identityToken para o seu backend para verificação
      // ou use-o com firebase_auth para autenticação no Firebase.

    } catch (e) {
      print('Erro ao fazer login com Apple: $e');
      // Trate o erro, exiba uma mensagem para o usuário
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.prussianBlue, // Fundo principal com Prussian Blue
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo ou Nome do Aplicativo
              Text(
                'KriolBusiness',
                style: TextStyle(
                  color: AppColors.papayaWhip, // Cor clara para o texto do título
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: AppColors.barnRed.withOpacity(0.5), // Sombra com Barn Red
                      offset: const Offset(5.0, 5.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              // Formulário de Login/Registro
              Card(
                margin: const EdgeInsets.all(20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 8.0,
                color: AppColors.prussianBlue.withOpacity(0.7), // Card com transparência para manter o fundo
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
                            labelStyle: TextStyle(color: AppColors.airSuperiorityBlue), // Cor para o label
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: AppColors.airSuperiorityBlue.withOpacity(0.5)), // Borda com Air Superiority Blue
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: AppColors.fireBrick), // Borda focada com Fire Brick
                            ),
                            prefixIcon: Icon(Icons.email, color: AppColors.airSuperiorityBlue), // Ícone com Air Superiority Blue
                          ),
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: AppColors.papayaWhip), // Texto digitado com Papaya Whip
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
                                AppColors.barnRed, // Barn Red
                                AppColors.fireBrick, // Fire Brick
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: _submitAuthForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: Text(
                              _authMode == AuthMode.login ? 'LOGIN' : 'REGISTRAR',
                              style: TextStyle(
                                color: AppColors.papayaWhip, // Texto do botão com Papaya Whip
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Botão para alternar entre Login e Registro
                        TextButton(
                          onPressed: _switchAuthMode,
                          child: Text(
                            _authMode == AuthMode.login
                                ? 'Não tem uma conta? Registre-se'
                                : 'Já tem uma conta? Faça Login',
                            style: TextStyle(color: AppColors.airSuperiorityBlue), // Texto do botão de alternância com Air Superiority Blue
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Divisor para opções de login social
                        Text(
                          '- OU -',
                          style: TextStyle(color: AppColors.airSuperiorityBlue, fontSize: 16), // Texto do divisor com Air Superiority Blue
                        ),
                        const SizedBox(height: 20),
                        // Botões de Login Social
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Botão Google
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.papayaWhip, // Fundo do botão social com Papaya Whip
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: AppColors.airSuperiorityBlue.withOpacity(0.5)),
                              ),
                              child: IconButton(
                                icon: const FaIcon(FontAwesomeIcons.google, color: AppColors.barnRed, size: 30), // Ícone do Google com Barn Red
                                onPressed: () {
                                  print('Login com Google');
                                  // Lógica de login com Google
                                },
                                padding: const EdgeInsets.all(12.0),
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Botão Facebook
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.papayaWhip, // Fundo do botão social com Papaya Whip
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: AppColors.airSuperiorityBlue.withOpacity(0.5)),
                              ),
                              child: IconButton(
                                icon: const FaIcon(FontAwesomeIcons.facebook, color: AppColors.prussianBlue, size: 30), // Ícone do Facebook com Prussian Blue
                                onPressed: () {
                                  print('Login com Facebook');
                                  // Lógica de login com Facebook
                                },
                                padding: const EdgeInsets.all(12.0),
                              ),
                            ),
                            // Botão Apple (condicionalmente visível)
                            if (Theme.of(context).platform == TargetPlatform.iOS) // Apenas mostra no iOS
                              const SizedBox(width: 20),
                            if (Theme.of(context).platform == TargetPlatform.iOS) // Apenas mostra no iOS
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.papayaWhip, // Fundo do botão social com Papaya Whip
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: AppColors.airSuperiorityBlue.withOpacity(0.5)),
                                ),
                                child: IconButton(
                                  icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.black, size: 30), // Ícone do Apple
                                  onPressed: (){
                                    // _handleAppleSignIn(); // Descomente para ativar o login com Apple
                                    print('Login com Apple');
                                  },
                                  padding: const EdgeInsets.all(12.0),
                                ),
                              ),
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
      ),
    );
  }
}
