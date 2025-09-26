import 'package:flutter/material.dart';

class ExtraitActeCivilScreen extends StatelessWidget {
  const ExtraitActeCivilScreen({super.key});
  static const Color primaryColor = Color(0xFF4CAF50); // Couleur du service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Extrait d’un Acte d’État Civil',
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
              Icon(Icons.fact_check, size: 60, color: primaryColor),
              SizedBox(height: 15),
              Text(
                'Page de Demande d\'Extrait',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Lieu pour demander un extrait simple de tout acte d\'état civil (naissance, mariage, décès).',
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