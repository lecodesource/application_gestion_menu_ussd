import 'package:flutter/material.dart';

class ForfaitsPage extends StatelessWidget {
  const ForfaitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forfaits disponibles'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _ForfaitCard(
            titre: 'Forfait Internet',
            description: '1 Go - 7 jours',
            prix: 1000,
            onAcheter: () => _showAchatDialog(context, 'Forfait Internet 1 Go'),
            couleur: Colors.blueAccent,
          ),
          _ForfaitCard(
            titre: 'Forfait Appels',
            description: '60 minutes - 30 jours',
            prix: 2000,
            onAcheter: () => _showAchatDialog(context, 'Forfait Appels 60 min'),
            couleur: Colors.greenAccent,
          ),
          _ForfaitCard(
            titre: 'Forfait Tout-en-un',
            description: '5 Go + 120 minutes - 30 jours',
            prix: 5000,
            onAcheter: () => _showAchatDialog(context, 'Forfait Tout-en-un'),
            couleur: Colors.orangeAccent,
          ),
        ],
      ),
    );
  }

  void _showAchatDialog(BuildContext context, String forfait) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer l\'achat'),
        content: Text('Voulez-vous acheter le $forfait ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Achat effectué avec succès!')),
              );
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}

class _ForfaitCard extends StatelessWidget {
  final String titre;
  final String description;
  final int prix;
  final VoidCallback onAcheter;
  final Color couleur;

  const _ForfaitCard({
    required this.titre,
    required this.description,
    required this.prix,
    required this.onAcheter,
    required this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: couleur.withOpacity(0.1),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titre,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: couleur,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              '$prix FCFA',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: couleur,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onAcheter,
              style: ElevatedButton.styleFrom(
                backgroundColor: couleur,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Acheter',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
