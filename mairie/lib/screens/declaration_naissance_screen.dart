import 'package:flutter/material.dart';
// 1. IMPORT DU PACKAGE file_picker
import 'package:file_picker/file_picker.dart'; 

class DeclarationNaissanceScreen extends StatefulWidget {
  const DeclarationNaissanceScreen({super.key});

  @override
  State<DeclarationNaissanceScreen> createState() => _DeclarationNaissanceScreenState();
}

class _DeclarationNaissanceScreenState extends State<DeclarationNaissanceScreen> {
  static const Color primaryColor = Color(0xFF005691);
  static const Color serviceColor = Color(0xFFF44336);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Contrôleurs de formulaire
  final TextEditingController _declarantNameController = TextEditingController();
  final TextEditingController _newbornNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();

  int _currentStep = 0;
  
  // VARIABLES D'ÉTAT pour suivre les fichiers joints
  bool _isAttestationNaissanceAttached = false;
  bool _isActeParentalAttached = false;
  bool _isFicheDeclarationAttached = false;
  
  // Variables pour stocker le nom des fichiers joints (pour l'affichage)
  // C'est la clé pour afficher le nom du fichier après l'importation.
  String? _attestationFileName;
  String? _acteParentalFileName;
  String? _ficheDeclarationFileName;

  late final List<Step> _steps;

  @override
  void initState() {
    super.initState();
    _steps = [
      _buildStepOne(),
      _buildStepTwo(),
      _buildStepThree(),
    ];
  }

  @override
  void dispose() {
    _declarantNameController.dispose();
    _newbornNameController.dispose();
    _birthDateController.dispose();
    _birthPlaceController.dispose();
    super.dispose();
  }

  // ------------------------- WIDGETS D'ÉTAPE -------------------------
  
  Step _buildStepOne() {
    return Step(
      title: const Text('Nouveau-né'),
      subtitle: const Text('Informations sur l\'enfant'),
      content: Column(
        children: [
          TextFormField(
            controller: _newbornNameController,
            decoration: const InputDecoration(
              labelText: 'Nom et Prénoms du Nouveau-né',
              prefixIcon: Icon(Icons.badge),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Champ obligatoire.';
              return null;
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _birthDateController,
            decoration: const InputDecoration(
              labelText: 'Date de Naissance (JJ/MM/AAAA)',
              prefixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.datetime,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Champ obligatoire.';
              return null;
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _birthPlaceController,
            decoration: const InputDecoration(
              labelText: 'Lieu de Naissance (Maternité/Ville)',
              prefixIcon: Icon(Icons.location_on),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Champ obligatoire.';
              return null;
            },
          ),
        ],
      ),
      isActive: _currentStep >= 0,
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
    );
  }

  Step _buildStepTwo() {
    return Step(
      title: const Text('Déclarant'),
      subtitle: const Text('Vos coordonnées'),
      content: Column(
        children: [
          TextFormField(
            controller: _declarantNameController,
            decoration: const InputDecoration(
              labelText: 'Nom et Prénoms du Déclarant',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Veuillez entrer le nom du déclarant.';
              return null;
            },
          ),
          const SizedBox(height: 15),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Numéro de Téléphone',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
      isActive: _currentStep >= 1,
      state: _currentStep > 1 ? StepState.complete : StepState.indexed,
    );
  }

  // Étape 3 : Pièces à Fournir (Uploads) et Envoi
  Step _buildStepThree() {
    return Step(
      title: const Text('Pièces & Envoi'),
      subtitle: const Text('Joindre les documents et finaliser'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Joindre les pièces justificatives 📎',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          const SizedBox(height: 10),
          
          // --- BOUTONS D'IMPORTATION DE FICHIERS ---
          _buildFileUploader(
            label: '1. Attestation de naissance (Médecin/Sage-femme)',
            isAttached: _isAttestationNaissanceAttached,
            fileName: _attestationFileName, // Passe le nom du fichier
            onTap: () => _handleFilePick(0),
          ),
          _buildFileUploader(
            label: '2. Acte parental ou carnet prénatal',
            isAttached: _isActeParentalAttached,
            fileName: _acteParentalFileName, // Passe le nom du fichier
            onTap: () => _handleFilePick(1),
          ),
          _buildFileUploader(
            label: '3. Fiche de déclaration de naissance (État Civil)',
            isAttached: _isFicheDeclarationAttached,
            fileName: _ficheDeclarationFileName, // Passe le nom du fichier
            onTap: () => _handleFilePick(2),
          ),
          
          const SizedBox(height: 20),
          const Divider(),

          // --- SECTION HORAIRES ---
          const Text(
            'Dépôt & Retrait du Dossier ⏱️',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
          ),
          _buildTimeInfo(
            title: 'Dépôt',
            time: 'Tous les jours ouvrables de 07h00 à 12h00 puis de 14h30 à 17h30',
            icon: Icons.upload_file,
          ),
          _buildTimeInfo(
            title: 'Retrait',
            time: 'Tous les jours ouvrables, 72 heures après le dépôt',
            icon: Icons.download_done,
          ),
          const SizedBox(height: 20),
          
          // Bouton final
          ElevatedButton.icon(
            onPressed: () {
              // Vérifie si TOUTES les pièces nécessaires sont jointes
              if (!_isAttestationNaissanceAttached || !_isActeParentalAttached || !_isFicheDeclarationAttached) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez joindre tous les documents requis.')),
                  );
                  return;
              }
              
              // Si les documents sont là, valide et envoie
              if (_formKey.currentState!.validate()) {
                _sendRequest(context);
              }
            },
            icon: const Icon(Icons.send_rounded, color: Colors.white),
            label: const Text(
              'Finaliser et Envoyer la Demande en Ligne',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: serviceColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
      isActive: _currentStep >= 2,
      state: _currentStep > 2 ? StepState.complete : StepState.indexed,
    );
  }
  
  // ------------------------- LOGIQUE D'IMPORTATION DE FICHIER -------------------------
  
  void _handleFilePick(int fileIndex) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'], // Extensions courantes
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      // Récupère le nom du fichier
      String fileName = result.files.single.name;
      
      setState(() {
        // Met à jour l'état et le nom du fichier en fonction de l'index
        if (fileIndex == 0) {
          _isAttestationNaissanceAttached = true;
          _attestationFileName = fileName;
        } else if (fileIndex == 1) {
          _isActeParentalAttached = true;
          _acteParentalFileName = fileName;
        } else if (fileIndex == 2) {
          _isFicheDeclarationAttached = true;
          _ficheDeclarationFileName = fileName;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fichier "$fileName" joint avec succès !')),
      );

    } else {
      // L'utilisateur a annulé la sélection
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sélection de fichier annulée.')),
      );
    }
  }
  
  // ------------------------- WIDGET D'UPLOAD DE FICHIER -------------------------
  
  Widget _buildFileUploader({
    required String label,
    required bool isAttached,
    required VoidCallback onTap,
    String? fileName, // Paramètre pour afficher le nom du fichier
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        elevation: 1,
        child: ListTile(
          leading: Icon(
            isAttached ? Icons.check_circle : Icons.upload_file,
            color: isAttached ? Colors.green : primaryColor,
          ),
          title: Text(label),
          // Affiche le nom du fichier joint en sous-titre
          subtitle: isAttached 
              ? Text(fileName ?? 'Fichier joint.')
              : null,
          trailing: isAttached
              ? const Text('Joint ✅', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
              : ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: const Text('Importer', style: TextStyle(color: Colors.white)),
                ),
        ),
      ),
    );
  }

  // ------------------------- LOGIQUE DE NAVIGATION ET ENVOI -------------------------

  void _onStepContinue() {
    // Validation des étapes 1 et 2
    if (_currentStep < 2 && !_formKey.currentState!.validate()) return;
    
    // Si nous sommes à la dernière étape (2), on simule l'envoi
    if (_currentStep == _steps.length - 1) {
      if (_isAttestationNaissanceAttached && _isActeParentalAttached && _isFicheDeclarationAttached) {
        _sendRequest(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez joindre tous les documents requis pour l\'envoi.')),
        );
      }
      return;
    }

    // Passage à l'étape suivante
    setState(() {
      _currentStep += 1;
    });
  }

  void _onStepCancel() {
    setState(() {
      if (_currentStep > 0) {
        _currentStep -= 1;
      }
    });
  }

  void _sendRequest(BuildContext context) {
    // Logique d'envoi API...
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Demande en ligne pour "${_newbornNameController.text}" enregistrée. Les fichiers joints seront traités. Veuillez déposer les originaux dans les 72h.',
        ),
        duration: const Duration(seconds: 7),
      ),
    );
  }
  
  // Widget d'information sur les horaires
  Widget _buildTimeInfo({required String title, required String time, required IconData icon}) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: serviceColor, size: 30),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          time,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  // ------------------------- WIDGET PRINCIPAL (BUILD) -------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Déclaration de Naissance',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          onStepTapped: (step) => setState(() => _currentStep = step),
          steps: _steps,
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: <Widget>[
                  // Bouton Continuer/Terminer
                  if (_currentStep < _steps.length - 1)
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(backgroundColor: serviceColor),
                      child: const Text('Suivant', style: TextStyle(color: Colors.white)),
                    ),
                  
                  // Bouton Précédent
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: Text('Précédent', style: TextStyle(color: primaryColor)),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}