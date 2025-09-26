// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestion_admin_app/providers/auth_provider.dart';
import 'package:gestion_admin_app/providers/document_provider.dart';
import 'package:gestion_admin_app/services/auth_service.dart';
// REMARQUE : Si vous utilisez Google Fonts, décommentez l'import ci-dessous
// import 'package:google_fonts/google_fonts.dart'; 

// --- MODÈLE POUR LES SERVICES (MIS À JOUR AVEC COULEUR) ---
class ServiceItem {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;
  final Color cardColor; // Nouveau champ pour la couleur

  ServiceItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
    required this.cardColor,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  static const Color primaryColor = Color(0xFF005691); // Couleur principale pour l'AppBar et le Drawer

  // --- LISTE DES SERVICES DE LA MAIRIE (ÉTAT CIVIL) ---
  late final List<ServiceItem> _services;

  @override
  void initState() {
    super.initState();
    
    // Définition de la liste des services avec des couleurs, icônes et descriptions uniques.
    _services = [
      ServiceItem(
        title: 'Déclaration de Naissance',
        description: 'Déclarez la naissance d\'un enfant dans le délai légal.',
        icon: Icons.baby_changing_station,
        cardColor: const Color(0xFFF44336), // Rouge vif
        onTap: () { print('Naviguer vers Déclaration de Naissance'); },
      ),
      ServiceItem(
        title: 'Extrait Acte Civil',
        description: 'Demandez un extrait simple ou plurilingue de tout acte civil.',
        icon: Icons.fact_check,
        cardColor: const Color(0xFF4CAF50), // Vert Émeraude
        onTap: () { print('Naviguer vers Extrait Acte Civil'); },
      ),
      ServiceItem(
        title: 'Copie Intégrale de l’Acte',
        description: 'Obtenez la reproduction complète d\'un acte de naissance ou autre.',
        icon: Icons.assignment,
        cardColor: const Color(0xFFFF9800), // Orange Vif
        onTap: () { print('Naviguer vers Copie Intégrale'); },
      ),
      ServiceItem(
        title: 'Transcription',
        description: 'Formalisez l\'enregistrement d\'un acte civil étranger.',
        icon: Icons.language,
        cardColor: const Color(0xFF2196F3), // Bleu Ciel
        onTap: () { print('Naviguer vers Transcription'); },
      ),
      ServiceItem(
        title: 'Droit de Recherche',
        description: 'Soumission d\'une demande pour retrouver un document archivé.',
        icon: Icons.search,
        cardColor: const Color(0xFF9C27B0), // Violet Profond
        onTap: () { print('Naviguer vers Droit de Recherche'); },
      ),
      ServiceItem(
        title: 'Duplicata',
        description: 'Obtenez une copie certifiée conforme d\'un acte déjà délivré.',
        icon: Icons.copy,
        cardColor: const Color(0xFF00BCD4), // Cyan
        onTap: () { print('Naviguer vers Duplicata'); },
      ),
      ServiceItem(
        title: 'Mention',
        description: 'Ajout ou modification d\'une mention marginale sur un acte.',
        icon: Icons.edit_note,
        cardColor: const Color(0xFFFFC107), // Ambre
        onTap: () { print('Naviguer vers Mention'); },
      ),
      ServiceItem(
        title: 'Déclaration de Décès',
        description: 'Déclarez un décès pour l\'enregistrement officiel et les démarches.',
        icon: Icons.healing, // ICÔNE CORRIGÉE
        cardColor: const Color(0xFF607D8B), // Bleu Gris (Sobriété)
        onTap: () { print('Naviguer vers Déclaration de Décès'); },
      ),
      ServiceItem(
        title: 'Déclaration de Mariage',
        description: 'Informations sur le dépôt de dossier et la célébration du mariage.',
        icon: Icons.favorite,
        cardColor: const Color(0xFFE91E63), // Rose Vif
        onTap: () { print('Naviguer vers Déclaration de Mariage'); },
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        // Optionnel: Récupérer les données spécifiques à l'utilisateur connecté
        // Provider.of<DocumentProvider>(context, listen: false).fetchDocuments(); 
      }
    });
  }
  
  // --- WIDGET POUR CONSTRUIRE LA GRILLE ---
  Widget _buildServiceGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.85, 
        ),
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final service = _services[index];
          return Card(
            elevation: 8, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: service.onTap,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, 
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ICONE DE COULEUR UNIQUE
                    Icon(
                      service.icon,
                      size: 45,
                      color: service.cardColor, // Couleur propre et attirante
                    ),
                    const SizedBox(height: 8),
                    // TITRE (POLICE ALICE si disponible)
                    Text(
                      service.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      // Utilisez GoogleFonts.alice(...) si vous l'avez configuré
                      style: const TextStyle(
                        fontFamily: 'Alice', // Tente la police Alice
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // DESCRIPTION
                    Expanded(
                      child: Text(
                        service.description,
                        textAlign: TextAlign.center,
                        maxLines: 4, 
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isConnected = authProvider.isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Services d\'État Civil - Mairie'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (isConnected) 
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await AuthService().logout();
                authProvider.logout(); 
              },
            ),
        ],
      ),
      
      // --- MENU LATÉRAL (DRAWER) ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: primaryColor),
              child: Text(
                'Mairie - État Civil',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isConnected ? 'Connecté(e) comme Administrateur' : 'Mode Visiteur',
                style: TextStyle(
                  color: isConnected ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.folder_shared),
              title: const Text('Gestion des Documents Admin'),
              onTap: () => Navigator.pop(context), 
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historique des Demandes'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      
      // --- CORPS DE LA PAGE ---
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isConnected 
                    ? 'Bonjour Administrateur, accédez aux différents services d\'État Civil.' 
                    : 'Bienvenue au Service d\'État Civil. Choisissez votre démarche ci-dessous.',
                style: const TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            // Affichage de la grille des services
            _buildServiceGrid(context),

            // Contenu du DocumentProvider (pour l'Admin)
            if (isConnected)
              Consumer<DocumentProvider>(
                builder: (context, docProvider, child) {
                  if (docProvider.isLoading) {
                    return const Center(child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ));
                  }
                  if (docProvider.errorMessage != null) {
                    return Center(child: Text('Erreur de documents: ${docProvider.errorMessage!}'));
                  }
                  
                  if (docProvider.documents.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                          child: Text('Documents d\'administration récents :', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: docProvider.documents.length > 3 ? 3 : docProvider.documents.length,
                          itemBuilder: (context, index) {
                            final document = docProvider.documents[index];
                            return ListTile(
                              leading: Icon(Icons.article_outlined, color: primaryColor),
                              title: Text(document.title),
                              subtitle: Text(document.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                            );
                          },
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
          ],
        ),
      ),
    );
  }
}