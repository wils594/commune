import 'package:flutter/material.dart';

class TranscriptionScreen extends StatelessWidget {
  const TranscriptionScreen({super.key});
  static const Color primaryColor = Color(0xFF2196F3); // Couleur du service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transcription',
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
              Icon(Icons.language, size: 60, color: primaryColor),
              SizedBox(height: 15),
              Text(
                'Page de Transcription',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Informations et formulaires pour la transcription des actes civils étrangers.',
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