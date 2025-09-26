  // lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestion_admin_app/providers/auth_provider.dart';
import 'package:gestion_admin_app/screens/login_screen.dart';
import 'package:gestion_admin_app/screens/home_screen.dart';
import 'package:gestion_admin_app/providers/document_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Ajoutez cette ligne pour que le DocumentProvider soit disponible dans votre application
        ChangeNotifierProvider(create: (_) => DocumentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Admin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Le Consumer écoute les changements dans l'AuthProvider
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          // Si l'utilisateur est authentifié, on montre le HomeScreen
          if (authProvider.isAuthenticated) {
            return const HomeScreen();
          } else {
            // Sinon, on reste sur le LoginScreen
            return const LoginScreen();
          }
        },
      ),
    );
  }
}