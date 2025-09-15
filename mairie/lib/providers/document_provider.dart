// lib/providers/document_provider.dart
import 'package:flutter/foundation.dart';
import 'package:gestion_admin_app/models/document.dart';
import 'package:gestion_admin_app/services/document_service.dart';

class DocumentProvider with ChangeNotifier {
  final DocumentService _documentService = DocumentService();
  List<Document> _documents = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Document> get documents => _documents;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDocuments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _documents = await _documentService.getDocuments();
    } catch (e) {
      _errorMessage = 'Impossible de charger les documents. Veuillez réessayer.';
      print('Erreur dans le provider : $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}