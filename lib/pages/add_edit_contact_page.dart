import 'package:flutter/material.dart';
import '../models/contact_model.dart';

class AddEditContactPage extends StatefulWidget {
  final Contact? contact; // null = add new
  final void Function(Contact contact) onSave;

  const AddEditContactPage({super.key, this.contact, required this.onSave});

  @override
  State<AddEditContactPage> createState() => _AddEditContactPageState();
}

class _AddEditContactPageState extends State<AddEditContactPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.contact?.name ?? "");
    phoneController = TextEditingController(text: widget.contact?.phone ?? "");
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? "Add Contact" : "Edit Contact"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
                validator: (v) => v!.isEmpty ? "Enter phone" : null,
              ),
              const SizedBox(height: 40),
              FilledButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newContact = Contact(
                      name: nameController.text,
                      phone: phoneController.text,
                    );
                    widget.onSave(newContact);
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text("Save Contact"),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
