import 'package:flutter/material.dart';

class CopieIntegraleActeScreen extends StatelessWidget {
  const CopieIntegraleActeScreen({super.key});
  static const Color primaryColor = Color(0xFFFF9800); // Couleur du service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Copie Intégrale de l’Acte de Naissance',
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
              Icon(Icons.assignment, size: 60, color: primaryColor),
              SizedBox(height: 15),
              Text(
                'Page de Demande de Copie Intégrale',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Demandez une copie complète et conforme de l\'acte de naissance.',
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