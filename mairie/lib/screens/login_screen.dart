// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestion_admin_app/providers/auth_provider.dart';
import 'package:gestion_admin_app/services/auth_service.dart';
import 'package:gestion_admin_app/screens/register_screen.dart'; // Nouvelle importation

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        final token = await _authService.login(email, password);

        if (token != null) {
          // Si le token est présent, la connexion a réussi
          Provider.of<AuthProvider>(context, listen: false).login();
        } else {
          // Gérer le cas où la connexion a échoué (afficher une erreur)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('E-mail ou mot de passe incorrect.')),
          );
        }
      } catch (e) {
        // Gérer les erreurs de l'API (e.g., pas de connexion internet)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Une erreur s\'est produite. Veuillez réessayer.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView( // Utilise ListView pour que l'écran soit scrollable si nécessaire
            // Utilise ListView pour que l'écran soit scrollable si nécessaire
            children: [
              // Ajout du logo en haut du formulaire
              Image.asset(
                'assets/images/logo.jpg', // Chemin vers ton logo. Assure-toi que le nom du fichier est correct.
                height: 120, // Ajuste la hauteur si nécessaire
              ),
              const SizedBox(height: 32),
              
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Adresse e-mail',
                  // Le style de border est géré par le thème, plus besoin de le mettre ici
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), 
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre adresse e-mail';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50), // Bouton sur toute la largeur
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Se connecter'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Redirection vers la page d'inscription
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text('Pas encore de compte ? Inscrivez-vous'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}