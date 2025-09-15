// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestion_admin_app/providers/auth_provider.dart';
import 'package:gestion_admin_app/providers/document_provider.dart';
import 'package:gestion_admin_app/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Lance la récupération des documents dès l'ouverture de l'écran
      Provider.of<DocumentProvider>(context, listen: false).fetchDocuments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          ),
        ],
      ),
      body: Consumer<DocumentProvider>(
        builder: (context, docProvider, child) {
          if (docProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (docProvider.errorMessage != null) {
            return Center(child: Text(docProvider.errorMessage!));
          }

          return ListView.builder(
            itemCount: docProvider.documents.length,
            itemBuilder: (context, index) {
              final document = docProvider.documents[index];
              return ListTile(
                title: Text(document.title),
                subtitle: Text(document.content),
              );
            },
          );
        },
      ),
    );
  }
}