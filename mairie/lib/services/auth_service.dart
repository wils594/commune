// lib/services/auth_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gestion_admin_app/services/api_service.dart';

class AuthService {
  final Dio _dio = ApiService().dio;
  final _storage = const FlutterSecureStorage();

  // ******************************************************
  // ** ATTENTION DÉVELOPPEUR BACKEND : L'API DE CONNEXION **
  // ******************************************************
  //
  // Le front-end envoie une requête POST à l'URL suivante :
  // -> `http://ton-adresse-ip:8000/api/login`
  //
  // Les données envoyées dans le corps de la requête sont au format JSON :
  // {
  //   "email": "email_de_l'utilisateur",
  //   "password": "mot_de_passe_de_l'utilisateur"
  // }
  //
  // Le front-end S'ATTEND à recevoir une réponse au format JSON :
  // **En cas de succès :**
  // {
  //   "token": "ton_token_jwt_ou_sanctum"
  // }
  //
  // **En cas d'échec (email/mot de passe incorrect) :**
  // Code HTTP 401 ou 422
  // {
  //   "message": "The given data was invalid.",
  //   "errors": {
  //     "email": ["These credentials do not match our records."]
  //   }
  // }
  // Le message d'erreur est facultatif mais recommandé.
  //
  Future<String?> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final token = response.data['token'];
      if (token != null) {
        await _storage.write(key: 'auth_token', value: token);
        return token;
      }
      return null;
    } on DioError catch (e) {
      print('Erreur de connexion : ${e.response?.data}');
      rethrow; // Ajout de rethrow pour propager l'erreur à l'UI
    }
  }
  
  // ******************************************************
  // ** ATTENTION DÉVELOPPEUR BACKEND : L'API D'INSCRIPTION **
  // ******************************************************
  //
  // Le front-end envoie une requête POST à l'URL suivante :
  // -> `http://ton-adresse-ip:8000/api/register`
  //
  // Les données envoyées dans le corps de la requête sont au format JSON :
  // {
  //   "name": "nom_de_l'utilisateur",
  //   "email": "email_de_l'utilisateur",
  //   "password": "mot_de_passe_de_l'utilisateur",
  //   "password_confirmation": "confirmation_du_mot_de_passe"
  // }
  //
  // Le front-end S'ATTEND à recevoir une réponse au format JSON :
  // **En cas de succès :**
  // Un code HTTP 201 (Created) avec un token :
  // {
  //   "token": "ton_token_jwt_ou_sanctum"
  // }
  // Le front-end va stocker ce token et se connecter automatiquement.
  //
  // **En cas d'échec (email déjà utilisé, mot de passe trop court, etc.) :**
  // Code HTTP 422 (Unprocessable Entity)
  // {
  //   "message": "The given data was invalid.",
  //   "errors": {
  //     "email": ["L'adresse e-mail est déjà utilisée."],
  //     "password": ["Le mot de passe doit contenir au moins 6 caractères."]
  //   }
  // }
  // Le front-end utilisera ce JSON pour afficher les messages d'erreur à l'utilisateur.
  //
  Future<String?> register(String name, String email, String password) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );
      final token = response.data['token'];
      if (token != null) {
        await _storage.write(key: 'auth_token', value: token);
        return token;
      }
      return null;
    } on DioError catch (e) {
      print('Erreur d\'inscription : ${e.response?.data}');
      // On peut relancer l'erreur pour la gérer dans l'UI et afficher un message spécifique
      rethrow;
    }
  }

  // ******************************************************
  // ** GESTION DU TOKEN ET AUTHENTIFICATION DES REQUÊTES **
  // ******************************************************
  //
  // Le front-end stocke le token reçu après la connexion.
  // Pour TOUTES les requêtes API suivantes qui nécessitent une authentification
  // (ex: obtenir la liste des utilisateurs, des documents, etc.),
  // le front-end ajoutera ce token dans l'en-tête de la requête.
  //
  // **Exemple d'en-tête de requête attendu par le back-end :**
  // Authorization: Bearer <le_token_stocké>
  // Accept: application/json
  //
  // Le back-end doit vérifier la validité de ce token pour chaque requête
  // et renvoyer une erreur 401 si le token est manquant ou invalide.
  //
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    // NOTE BACKEND: Pour une sécurité accrue, vous pouvez aussi créer un endpoint
    // '/logout' qui invalide le token côté serveur.
    // Le front-end appellerait cet endpoint avant de supprimer le token localement.
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }
}