import 'package:flutter/material.dart';

class DroitRechercheScreen extends StatelessWidget {
  const DroitRechercheScreen({super.key});
  static const Color primaryColor = Color(0xFF9C27B0); // Couleur du service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Droit de Recherche',
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
              Icon(Icons.search, size: 60, color: primaryColor),
              SizedBox(height: 15),
              Text(
                'Page des Droits de Recherche',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Procédure pour la recherche et l\'accès aux archives d\'état civil.',
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