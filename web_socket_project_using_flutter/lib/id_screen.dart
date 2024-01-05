import 'package:flutter/material.dart';

import 'chat_screen.dart';

class InputIdScreen extends StatefulWidget {
  const InputIdScreen({super.key});

  @override
  State<InputIdScreen> createState() => _InputIdScreenState();
}

class _InputIdScreenState extends State<InputIdScreen> {
  late TextEditingController _idController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
  }

  @override
  void dispose() {
    _idController = TextEditingController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
                        return ChatScreen(
                          myid: _idController.text,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Text('OK')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
