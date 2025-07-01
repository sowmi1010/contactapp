import 'dart:async';
import 'package:flutter/material.dart';
import '../models/contact_model.dart';

class CallPage extends StatefulWidget {
  final Contact contact;
  const CallPage({super.key, required this.contact});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage>
    with SingleTickerProviderStateMixin {
  double progress = 0.0;
  Timer? timer;
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    // call progress
    timer = Timer.periodic(const Duration(milliseconds: 500), (t) {
      setState(() {
        progress += 0.1;
        if (progress >= 1.0) {
          progress = 1.0;
          timer?.cancel();
        }
      });
    });

    // animation
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    timer?.cancel();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Text("Calling ${widget.contact.name}"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _rippleController,
              builder: (context, child) {
                return Container(
                  width: 150 + (_rippleController.value * 20),
                  height: 150 + (_rippleController.value * 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withOpacity(0.2),
                  ),
                  child: child,
                );
              },
              child: const Icon(
                Icons.phone_in_talk,
                size: 80,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Calling ${widget.contact.phone}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 100,
              child: LinearProgressIndicator(
                value: progress,
                color: Colors.deepPurple,
                backgroundColor: Colors.deepPurple.shade100,
              ),
            ),
            const SizedBox(height: 30),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.call_end),
              label: const Text("End Call"),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
