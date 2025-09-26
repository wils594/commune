import 'package:flutter/material.dart';

class DeclarationDecesScreen extends StatelessWidget {
  const DeclarationDecesScreen({super.key});
  static const Color primaryColor = Color(0xFF607D8B); // Couleur du service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Déclaration de Décès',
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
              Icon(Icons.healing, size: 60, color: primaryColor),
              SizedBox(height: 15),
              Text(
                'Page de Déclaration de Décès',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Déclaration officielle d\'un décès et obtention de l\'acte de décès.',
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