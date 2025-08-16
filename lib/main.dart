import 'package:flutter/material.dart';
import 'package:kriolbusiness/features/auth/presentation/pages/auth_page.dart'; // Importe sua AuthPage
import 'package:kriolbusiness/config/theme/app_colors.dart'; // Importe a classe AppColors centralizada

// Se você estiver usando Firebase, descomente as linhas abaixo e certifique-se de ter configurado o Firebase
// import 'package:firebase_core/firebase_core.dart';
// import 'package:kriolbusiness/firebase_options.dart'; // Gerado pelo flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Se você estiver usando Firebase, descomente e ajuste a inicialização abaixo
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KriolBusiness',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Pode ser ajustado para uma cor da sua paleta se desejar
        fontFamily: 'Roboto', // Define Roboto como a fonte padrão para todo o aplicativo
        scaffoldBackgroundColor: AppColors.prussianBlue, // Fundo padrão para Scaffold
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.prussianBlue,
          foregroundColor: AppColors.papayaWhip,
          elevation: 0,
        ),
        textTheme: TextTheme(
          // Estilos de texto padrão usando Roboto e cores da paleta
          displayLarge: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          displayMedium: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          displaySmall: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          headlineLarge: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          headlineMedium: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          headlineSmall: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          titleLarge: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          titleMedium: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          titleSmall: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          bodyLarge: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          bodyMedium: TextStyle(color: AppColors.airSuperiorityBlue, fontFamily: 'Roboto'),
          bodySmall: TextStyle(color: AppColors.airSuperiorityBlue, fontFamily: 'Roboto'),
          labelLarge: TextStyle(color: AppColors.papayaWhip, fontFamily: 'Roboto'),
          labelMedium: TextStyle(color: AppColors.airSuperiorityBlue, fontFamily: 'Roboto'),
          labelSmall: TextStyle(color: AppColors.airSuperiorityBlue, fontFamily: 'Roboto'),
        ),
        // Adicione outras configurações de tema conforme necessário, usando as cores da sua paleta
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: AppColors.airSuperiorityBlue),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: AppColors.airSuperiorityBlue.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: AppColors.fireBrick),
          ),
          prefixIconColor: AppColors.airSuperiorityBlue,
        ),
      ),
      home: const AuthPage(), // Define AuthPage como a tela inicial
    );
  }
}
