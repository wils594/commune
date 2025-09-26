import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestion_admin_app/providers/auth_provider.dart';
import 'package:gestion_admin_app/services/auth_service.dart';
import 'package:gestion_admin_app/screens/register_screen.dart';

// Définition de la palette de couleurs basée sur les indications (Vert, Jaune, Bleu, Café)
const Color primaryColor = Color(0xFF007A9A); // Un Bleu institutionnel (légèrement tiré sur le vert/cyan pour le contraste)
const Color accentColor = Color.fromARGB(255, 245, 249, 37); // Un Jaune/Orange vif pour l'accentuation
const Color secondaryColor = Color.fromARGB(255, 0, 91, 137); // Bleu
const Color coffeeColor = Color(0xFF795548); // Couleur Café / Marron

// Pour le fond des champs, nous gardons une couleur neutre claire
const Color lightBackgroundColor = Color(0xFFF4F6F9);

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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Afficher l'indicateur de chargement
      });

      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        final token = await _authService.login(email, password);

        if (token != null) {
          // Connexion réussie
          Provider.of<AuthProvider>(context, listen: false).login();
        } else {
          // Gérer le cas où la connexion a échoué (mauvaises identifiants)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Identifiants incorrects. Veuillez vérifier votre e-mail et mot de passe.')),
          );
        }
      } catch (e) {
        // Gérer les erreurs de l'API (e.g., pas de connexion internet, erreur serveur)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connexion impossible. Vérifiez votre connexion Internet ou réessayez plus tard.')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Masquer l'indicateur de chargement
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Connexion'),
        backgroundColor: primaryColor, // Bleu principal
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.jpg', // Chemin vers votre logo
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 48),

                // Champ E-mail
                _buildTextFormField(
                  controller: _emailController,
                  labelText: 'Adresse e-mail',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre adresse e-mail';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                       return 'Veuillez entrer une adresse e-mail valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Champ Mot de passe
                _buildTextFormField(
                  controller: _passwordController,
                  labelText: 'Mot de passe',
                  icon: Icons.lock,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Bouton de Connexion
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm, // Désactiver pendant le chargement
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: primaryColor, // Bleu principal
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Se connecter',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 20),

                // Lien vers l'Inscription
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pas encore de compte ?',
                      style: TextStyle(color: coffeeColor), // Utilisation de la couleur Café pour le texte par défaut
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Inscrivez-vous',
                        style: TextStyle(
                          color: secondaryColor, // Vert pour le lien d'action
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget utilitaire pour construire les champs de texte avec un style cohérent
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: coffeeColor), // Texte de saisie en couleur Café
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: primaryColor.withOpacity(0.8)),
        prefixIcon: Icon(icon, color: primaryColor.withOpacity(0.7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentColor, width: 2), // Jaune/Orange pour le focus
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: lightBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      validator: validator,
    );
  }
}