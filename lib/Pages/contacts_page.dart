import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    if (await Permission.contacts.request().isGranted) {
      final List<Contact> loadedContacts = await ContactsService.getContacts();
      setState(() {
        contacts = loadedContacts;
      });
    } else {
      // Affiche un message d'erreur si les permissions sont refusées
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission pour accéder aux contacts refusée')),
      );
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de passer l\'appel')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: contacts.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Affiche un loader pendant le chargement
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          final hasPhone = contact.phones?.isNotEmpty ?? false;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: hasPhone
                  ? CircleAvatar(
                backgroundColor: Colors.deepPurple,
                child: Text(
                  contact.displayName != null && contact.displayName!.isNotEmpty
                      ? contact.displayName!.substring(0, 1).toUpperCase()
                      : '?', // Affiche un "?" si le nom est vide
                  style: const TextStyle(color: Colors.white),
                ),
              )
                  : null, // Ne pas afficher l'avatar si le contact n'a pas de numéro
              title: Text(contact.displayName ?? 'Inconnu',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                  hasPhone ? contact.phones?.first.value ?? '' : 'Pas de numéro disponible'),
              trailing: IconButton(
                icon: const Icon(Icons.phone),
                onPressed: hasPhone
                    ? () {
                  _makePhoneCall(contact.phones!.first.value!);
                }
                    : null, // Désactive le bouton si aucun numéro
              ),
            ),
          );
        },
      ),
    );
  }
}
