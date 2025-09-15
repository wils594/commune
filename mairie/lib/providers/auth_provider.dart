// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  // Méthode de connexion
  Future<void> login() async {
    _isAuthenticated = true;
    notifyListeners(); // Informe l'interface utilisateur que l'état a changé
  }

  // Méthode de déconnexion
  Future<void> logout() async {
    _isAuthenticated = false;
    notifyListeners(); // Informe l'interface utilisateur que l'état a changé
  }
}