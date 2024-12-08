import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class TransfertPage extends StatefulWidget {
  const TransfertPage({super.key});

  @override
  State<TransfertPage> createState() => _TransfertPageState();
}

class _TransfertPageState extends State<TransfertPage> {
  List<Contact> contacts = [];
  Contact? _selectedContact;
  final TextEditingController _montantController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      // Gérer l'absence de permission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permission pour accéder aux contacts refusée')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfert d\'argent')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Formulaire
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Saisie du montant
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: _montantController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Montant à transférer',
                        hintText: 'Entrez le montant',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un montant';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Veuillez entrer un montant valide';
                        }
                        return null;
                      },
                    ),
                  ),
                  // Sélection du destinataire ou entrée manuelle
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: contacts.isEmpty
                        ? Column(
                      children: [
                        // Saisie manuelle du numéro de téléphone
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Numéro de téléphone',
                            hintText: 'Entrez le numéro',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un numéro';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        // Option pour ouvrir les contacts
                        ElevatedButton(
                          onPressed: _loadContacts,
                          child: const Text('Accéder aux contacts'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                          ),
                        ),
                      ],
                    )
                        : DropdownButtonFormField<Contact>(
                      decoration: const InputDecoration(
                        labelText: 'Destinataire',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedContact,
                      onChanged: (Contact? newContact) {
                        setState(() {
                          _selectedContact = newContact;
                          _phoneController.text = newContact?.phones?.isNotEmpty == true
                              ? newContact!.phones!.first.value!
                              : '';
                        });
                      },
                      items: contacts.map<DropdownMenuItem<Contact>>((Contact contact) {
                        return DropdownMenuItem<Contact>(
                          value: contact,
                          child: Text(contact.displayName ?? 'Inconnu'),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner un destinataire';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _validateAndProceed,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Valider le Transfert',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _validateAndProceed() {
    if (_formKey.currentState?.validate() ?? false) {
      final montant = _montantController.text;
      final contact = _selectedContact;
      final phoneNumber = _phoneController.text;

      if (contact != null) {
        _showConfirmDialog(montant, contact.displayName ?? '', contact.phones?.first.value ?? '');
      } else if (phoneNumber.isNotEmpty) {
        _showConfirmDialog(montant, 'Numéro inconnu', phoneNumber);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Veuillez entrer un destinataire')));
      }
    }
  }

  void _showConfirmDialog(String montant, String name, String phone) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirmer le transfert de $montant FCFA à $name ($phone)?',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Annuler
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _transfertEffectue();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('Confirmer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _transfertEffectue() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transfert effectué avec succès!')),
    );
    // Retour à la page d'accueil après un délai
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Retourne à la page précédente
    });
  }
}
