import 'package:flutter/material.dart';

import 'all_chat_screen.dart';
import 'chat_screen.dart';

class IdScreen extends StatefulWidget {
  const IdScreen({super.key});

  @override
  State<IdScreen> createState() => _IdScreenState();
}

class _IdScreenState extends State<IdScreen> {
  late TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Enter you own uniques id'),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      label: Text('Enter unique Number'),
                      hintText: 'Enter number'),
                  controller: _idController,
                ),
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AllChatsScreen(
                          myId: _idController.text,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
