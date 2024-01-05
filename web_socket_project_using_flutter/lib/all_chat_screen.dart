import 'package:flutter/material.dart';

import 'chat_screen.dart';

class AllChatsScreen extends StatefulWidget {
  final String myId;
  const AllChatsScreen({super.key, required this.myId});

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  late TextEditingController _idController;

  List<ProfileModel> chatList = [];

  @override
  void initState() {
    super.initState();
    chatList = [
      ProfileModel(
        chatId: '111',
        name: 'Tejas Gaikwad',
      ),
      ProfileModel(
        chatId: '222',
        name: 'Viraj shinde',
      ),
      ProfileModel(
        chatId: '333',
        name: 'Manish shinde',
      ),
      ProfileModel(
        chatId: '444',
        name: 'Akshay',
      ),
      ProfileModel(
        chatId: '555',
        name: 'Viraj vagh',
      ),
      ProfileModel(
        chatId: '666',
        name: 'Rahul Pawar',
      ),
    ];
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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Chats'),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    return individualChatCard(
                      myId: widget.myId,
                      lastMessage: "Hey, What's UP",
                      userName: chatList[index].name,
                      profileChatId: chatList[index].chatId,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget individualChatCard({
    required String myId,
    required String userName,
    required String lastMessage,
    required String profileChatId,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ChatScreen(
              myId: myId,
              profileName: userName,
              recieverid: profileChatId,
            );
          },
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(18.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        lastMessage,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text('09:45'),
                Container(
                    padding: EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: Text('2')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ProfileModel {
  final String chatId;
  final String name;

  ProfileModel({
    required this.chatId,
    required this.name,
  });
}
