import 'package:flutter/material.dart';

class DeclarationMariageScreen extends StatelessWidget {
  const DeclarationMariageScreen({super.key});
  static const Color primaryColor = Color(0xFFE91E63); // Couleur du service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Déclaration de Mariage',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite, size: 60, color: primaryColor),
              SizedBox(height: 15),
              Text(
                'Page de Déclaration de Mariage',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Informations sur les conditions, le dossier et la célébration du mariage civil.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}