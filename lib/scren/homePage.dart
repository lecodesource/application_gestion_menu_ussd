import 'package:flutter/material.dart';
import 'package:menu_ussd/Pages/forfaits_page.dart';
import 'package:menu_ussd/Pages/transfer_page.dart';
import 'package:menu_ussd/themeNotifier.dart';
import 'package:provider/provider.dart';

import '../Pages/contacts_page.dart';

class InterestsScreen extends StatefulWidget {
  @override
  _InterestsScreenState createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {

  int? selectedOptionIndex;

  // Options disponibles
  final List<Map<String, dynamic>> options = [
    {
      'title': 'MIXX BY YAS',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT42Il6x1_P2mbZ_4YxCaZM3dtsAHxPc5LGHA&s',
      'page': MixxByYasPage(),
    },
    {
      'title': 'MOOV MONEY',
      'image': 'https://www.republiquetogolaise.com/media/k2/items/cache/3dc2544c934ef7d30f24944cf2b0f793_L.jpg',
      'page': MoovMoneyPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: const Text(" Bienvenue fifi ! " , style: TextStyle(fontWeight: FontWeight.bold),),
        actions: const [
          Icon(Icons.notifications ),
          SizedBox(width: 10,),
          Icon(Icons.share )
        ],
      ),
      body: Stack(
        children: [
          // Image en arrière-plan
          Positioned.fill(
            child: Image.network(
              'https://i.pinimg.com/736x/82/e6/f2/82e6f22dae07a484e7f910b619f282f1.jpg',
             // fit: BoxFit.cover,
            ),
          ),
          // Contenu principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Container(
                     child:
                     Text(
                       'Faites le choix de votre Opérateur',
                       style: TextStyle(
                         fontSize: 24,
                         fontWeight: FontWeight.bold,
                         foreground: Paint()
                           ..shader = const LinearGradient(
                             colors: [Colors.blue, Colors.purple],
                           ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                       ),
                     )

                   ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedOptionIndex = index;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedOptionIndex == index
                                    ? Colors.indigo[700]?.withOpacity(0.8)
                                    : Colors.indigo[800]?.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: selectedOptionIndex == index
                                      ? Colors.purple
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    options[index]['image'],
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    options[index]['title'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: selectedOptionIndex != null
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            options[selectedOptionIndex!]['page'],
                          ),
                        );
                      }
                          : null,
                      child: const Text(
                        'Continuer',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          themeNotifier.toggleThemeMode();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Pages spécifiques
class MixxByYasPage extends StatelessWidget {
  double solde = 1000;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MIXX BY YAS'),
      ),
      body:
      SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Carte de solde avec dégradé et ombre
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8C43FF), Color(0xFF3F51B5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Votre Solde actuel',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '1000 FCFA',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Animation des boutons du menu
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Column(
                children: [

                  MenuButton(
                    icon: Icons.send,
                    text: 'Transfert d\'argent',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TransfertPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  MenuButton(
                    icon: Icons.shopping_cart,
                    text: 'Acheter un forfait',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForfaitsPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  MenuButton(
                    icon: Icons.contact_phone,
                    text: 'Contacts',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ContactsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoovMoneyPage extends StatelessWidget {
  double solde = 1000;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MOOV MONEY'),
      ),
      body:
      SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Carte de solde avec dégradé et ombre
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8C43FF), Color(0xFF3F51B5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Votre Solde actuel',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '1000 FCFA',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Animation des boutons du menu
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Column(
                children: [

                  MenuButton(
                    icon: Icons.send,
                    text: 'Transfert d\'argent',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TransfertPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  MenuButton(
                    icon: Icons.shopping_cart,
                    text: 'Acheter un forfait',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForfaitsPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  MenuButton(
                    icon: Icons.contact_phone,
                    text: 'Contacts',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ContactsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),




    );
  }
}


class MenuButton extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const MenuButton({
    required this.icon,
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: (_) => setState(() => _scale = 0.95), // Réaction tactile
        onTapUp: (_) => setState(() => _scale = 1.0), // Rétablissement
        onTapCancel: () => setState(() => _scale = 1.0), // Rétablissement
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.indigo],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Icône avec une transition fluide et légère translation
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    widget.icon,
                    key: ValueKey(widget.icon),
                    color: Colors.white,
                    size: 30, // Taille augmentée de l'icône
                  ),
                ),
                const SizedBox(width: 16),
                // Texte élégant avec une animation de translation
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                  child: Text(widget.text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


