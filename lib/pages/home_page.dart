import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import 'contacts_tab.dart';
import 'favorites_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Contact> contacts = [
    Contact(name: "Anu", phone: "9876543210"),
    Contact(name: "Bala", phone: "9123456780"),
    Contact(name: "Charan", phone: "9784512345"),
    Contact(name: "Divya", phone: "9012784536"),
  ];

  final Set<String> favoriteNumbers = {};

  @override
  Widget build(BuildContext context) {
    final pages = [
      ContactsTab(
        contacts: contacts,
        favoriteNumbers: favoriteNumbers,
        toggleFavorite: _toggleFavorite,
      ),
      FavoritesTab(contacts: contacts, favoriteNumbers: favoriteNumbers),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentIndex == 0 ? "Contacts" : "Favorites",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: pages[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: "Contacts",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favorites"),
        ],
      ),
    );
  }

  void _toggleFavorite(String phone) {
    setState(() {
      if (favoriteNumbers.contains(phone)) {
        favoriteNumbers.remove(phone);
      } else {
        favoriteNumbers.add(phone);
      }
    });
  }
}
