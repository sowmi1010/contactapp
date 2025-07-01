import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import 'contact_details_page.dart';

class FavoritesTab extends StatelessWidget {
  final List<Contact> contacts;
  final Set<String> favoriteNumbers;

  const FavoritesTab({
    super.key,
    required this.contacts,
    required this.favoriteNumbers,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteContacts =
        contacts
            .where((contact) => favoriteNumbers.contains(contact.phone))
            .toList();

    if (favoriteContacts.isEmpty) {
      return const Center(
        child: Text(
          "No favorites yet",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Container(
      color: const Color(0xFFF1F2F6),
      child: ListView.builder(
        itemCount: favoriteContacts.length,
        itemBuilder: (context, index) {
          final contact = favoriteContacts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Hero(
                tag: contact.phone,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.deepPurple,
                  child: Text(
                    contact.name[0],
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              title: Text(
                contact.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                contact.phone,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ContactDetailsPage(contact: contact),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
