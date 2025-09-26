import 'package:flutter/material.dart';

class MentionScreen extends StatelessWidget {
  const MentionScreen({super.key});
  static const Color primaryColor = Color(0xFFFFC107); // Couleur du service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajout/Modification de Mention',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit_note, size: 60, color: primaryColor),
              SizedBox(height: 15),
              Text(
                'Page des Mentions Marginales',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Espace pour déposer une demande d\'ajout ou de modification de mention sur un acte.',
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