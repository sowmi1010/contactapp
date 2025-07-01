import 'package:flutter/material.dart';
import '../models/contact_model.dart';
import 'contact_details_page.dart';
import 'add_edit_contact_page.dart';

class ContactsTab extends StatefulWidget {
  final List<Contact> contacts;
  final Set<String> favoriteNumbers;
  final void Function(String) toggleFavorite;

  const ContactsTab({
    super.key,
    required this.contacts,
    required this.favoriteNumbers,
    required this.toggleFavorite,
  });

  @override
  State<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredContacts =
        widget.contacts
            .where(
              (c) =>
                  c.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  c.phone.contains(searchQuery),
            )
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F2F6),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search contacts...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = filteredContacts[index];
                final isFavorite = widget.favoriteNumbers.contains(
                  contact.phone,
                );

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
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
                        radius: 24,
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          contact.name[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.star : Icons.star_border,
                            color: isFavorite ? Colors.amber : Colors.grey,
                          ),
                          onPressed: () {
                            widget.toggleFavorite(contact.phone);
                          },
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == "edit") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => AddEditContactPage(
                                        contact: contact,
                                        onSave: (updated) {
                                          setState(() {
                                            final idx = widget.contacts.indexOf(
                                              contact,
                                            );
                                            widget.contacts[idx] = updated;
                                          });
                                        },
                                      ),
                                ),
                              );
                            } else if (value == "delete") {
                              setState(() {
                                widget.contacts.remove(contact);
                              });
                            }
                          },
                          itemBuilder:
                              (_) => [
                                const PopupMenuItem(
                                  value: "edit",
                                  child: Text("Edit"),
                                ),
                                const PopupMenuItem(
                                  value: "delete",
                                  child: Text("Delete"),
                                ),
                              ],
                        ),
                      ],
                    ),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => AddEditContactPage(
                    onSave: (newContact) {
                      setState(() {
                        widget.contacts.add(newContact);
                      });
                    },
                  ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Contact"),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
