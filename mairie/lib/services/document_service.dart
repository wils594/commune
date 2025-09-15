// lib/services/document_service.dart
import 'package:dio/dio.dart';
import 'package:gestion_admin_app/models/document.dart';
import 'package:gestion_admin_app/services/api_service.dart';

class DocumentService {
  final Dio _dio = ApiService().dio;

  /// ************************************************************
  /// ** ATTENTION DÉVELOPPEUR BACKEND : L'API DES DOCUMENTS **
  /// ************************************************************
  ///
  /// Le front-end envoie une requête GET pour récupérer les documents.
  /// -> `http://ton-adresse-ip:8000/api/documents`
  ///
  /// **IMPORTANT :** Cette requête nécessite une authentification.
  /// Le front-end envoie automatiquement le token dans les en-têtes :
  /// Header: Authorization: Bearer <le_token_reçu_lors_de_la_connexion>
  ///
  /// **Le front-end S'ATTEND à recevoir une réponse au format JSON :**
  /// En cas de succès :
  /// Un code HTTP 200 avec un tableau d'objets (documents) :
  ///
  /// [
  ///   {
  ///     "id": 1,
  ///     "title": "Rapport 2025",
  ///     "content": "Contenu du rapport annuel..."
  ///   },
  ///   {
  ///     "id": 2,
  ///     "title": "Procès verbal de réunion",
  ///     "content": "Résumé de la réunion du 15/09/2025..."
  ///   }
  /// ]
  ///
  /// En cas d'échec d'authentification :
  /// Un code HTTP 401 (Unauthorized)
  /// {
  ///   "message": "Unauthenticated."
  /// }
  ///
  Future<List<Document>> getDocuments() async {
    try {
      final response = await _dio.get('/documents');
      
      final documents = (response.data as List)
          .map((json) => Document.fromJson(json))
          .toList();

      return documents;
    } on DioError catch (e) {
      print('Erreur lors de la récupération des documents : ${e.message}');
      // On pourrait relancer l'erreur pour la gérer dans le provider
      rethrow;
    }
  }
}