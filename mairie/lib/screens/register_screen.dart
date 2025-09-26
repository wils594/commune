import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestion_admin_app/providers/auth_provider.dart';
import 'package:gestion_admin_app/services/auth_service.dart';

// Définition d'une palette de couleurs inspirée d'une institution
// (À ajuster si les couleurs officielles sont connues)
const Color primaryColor = Color(0xFF005691); // Bleu foncé - Suggère la fiabilité, l'autorité
const Color accentColor = Color(0xFFFFA500); // Orange - Suggère le dynamisme, la chaleur
const Color backgroundColor = Color(0xFFF4F6F9); // Gris clair pour le fond des champs

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Utilisez l'instance du service d'authentification ici
  final AuthService _authService = AuthService();

  // Ajout d'un état pour le chargement
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Afficher l'indicateur de chargement
      });

      final name = _nameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        final token = await _authService.register(name, email, password);

        if (token != null) {
          // Inscription réussie et utilisateur connecté
          // L'utilisation de `listen: false` est correcte pour les appels de méthode
          Provider.of<AuthProvider>(context, listen: false).login();
        } else {
          // Gérer le cas où l'API renvoie null sans erreur (si possible)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Échec de l\'inscription. Veuillez réessayer.')),
          );
        }
      } catch (e) {
        // Gérer les erreurs de l'API (e.g., email déjà utilisé, mauvaise connexion)
        String errorMessage = 'Échec de l\'inscription. Veuillez réessayer.';
        // Tentative d'extraire un message d'erreur plus précis si 'e' est un type connu
        // Par exemple, si vous utilisez 'dio' ou une autre librairie avec des erreurs structurées,
        // vous pourriez faire une vérification plus spécifique ici.
        if (e.toString().contains('Email already in use')) {
          errorMessage = "Cette adresse e-mail est déjà utilisée.";
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
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
        title: const Text('Inscription'),
        backgroundColor: primaryColor, // Utilisation de la couleur principale
        foregroundColor: Colors.white,
        elevation: 0, // Enlève l'ombre de l'AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              // Ajout de contraintes de remplissage pour centrer le contenu sur les grands écrans
              shrinkWrap: true,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.jpg', // Chemin vers votre logo
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 32),
                
                // Champ Nom
                _buildTextFormField(
                  controller: _nameController,
                  labelText: 'Nom Complet',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom complet';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Champ E-mail
                _buildTextFormField(
                  controller: _emailController,
                  labelText: 'Adresse e-mail',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une adresse e-mail';
                    }
                    // Simple validation d'e-mail
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
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Le mot de passe doit contenir au moins 6 caractères';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Champ Confirmer le mot de passe
                _buildTextFormField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirmer le mot de passe',
                  icon: Icons.lock_reset,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez confirmer votre mot de passe';
                    }
                    if (value != _passwordController.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Bouton d'Inscription
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm, // Désactiver pendant le chargement
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: primaryColor, // Utilisation de la couleur principale
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
                          'S\'inscrire',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 20),

                // Lien vers la Connexion
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Déjà un compte ?'),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Revenir à l'écran précédent (Connexion)
                      },
                      child: const Text(
                        'Connectez-vous',
                        style: TextStyle(
                          color: primaryColor,
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
      decoration: InputDecoration(
        labelText: labelText,
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
          borderSide: const BorderSide(color: accentColor, width: 2),
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
        fillColor: backgroundColor, // Utilisation de la couleur de fond claire
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      validator: validator,
    );
  }
}