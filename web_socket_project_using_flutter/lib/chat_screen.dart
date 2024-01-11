import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart'; // Use 'package:web_socket_channel/html.dart' for web applications

class ChatScreen extends StatefulWidget {
  final String recieverid;
  final String profileName;
  final String myId;
  const ChatScreen({
    super.key,
    required this.recieverid,
    required this.profileName,
    required this.myId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IOWebSocketChannel _channel;

  bool connected = false;

  String myid = "";
  String recieverid = "";
  String auth = "chatapphdfgjd34534hjdfk"; //auth key

  List<MessageData> msglist = [];

  TextEditingController msgtext = TextEditingController();

  bool typing = false;

  @override
  void initState() {
    super.initState();
    myid = widget.myId;
    recieverid = widget.recieverid;

    channelconnect();
  }

  channelconnect() {
    try {
      _channel = IOWebSocketChannel.connect(
        // 'ws://10.0.2.2:3000/$myid',

        'wss://web-socket-app-0504-6fbf1f6526f6.herokuapp.com/$myid', //$myid
        headers: {'Connection': 'Upgrade', 'Upgrade': 'websocket'},
      );
      _channel.stream.listen(
        (message) {
          setState(() {
            if (message == "connected") {
              connected = true;
              setState(() {});
            } else if (message.startsWith("send:success")) {
              setState(() {
                msgtext.text = "";
              });
            } else if (message == "send:error") {
              print("Message send error");
            } else if (message == "Typing...") {
              setState(() {
                typing = true;
              });
            } else if (message.substring(0, 6) == "{'cmd'") {
              message = message.replaceAll(RegExp("'"), '"');
              var jsondata = json.decode(message);
              msglist.add(MessageData(
                msgtext: jsondata["msgtext"],
                userid: jsondata["userid"],
                isme: false,
              ));
              setState(() {});
            }
          });
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");

          setState(() {
            typing = false;
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (error) {
      print("error on connecting to websocket.   ==>>>>    ${error}");
    }
  }

  var i = 0;

  Future<void> sendmsg(String sendmsg, String id) async {
    if (connected == true) {
      String msg =
          "{'auth':'$auth','cmd':'send','userid':'$id', 'msgtext':'$sendmsg'}";
      setState(() {
        msgtext.text = "";
        msglist.add(MessageData(msgtext: sendmsg, userid: myid, isme: true));
      });
      _channel.sink.add(msg); //send message to reciever channel
    } else {
      channelconnect();
      print("Websocket is not connected.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        title: Text("My ID: $myid to $recieverid" +
            "  ${typing == true ? 'typing...' : ""}    "),
        leading: Icon(
          Icons.circle,
          color: connected
              ? const Color.fromARGB(255, 0, 238, 20)
              : Colors.redAccent,
        ),
        titleSpacing: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          children: [
            Column(
              children: msglist.map((onemsg) {
                return Container(
                    margin: EdgeInsets.only(
                      left: onemsg.isme ? 40 : 0,
                      right: onemsg.isme ? 0 : 40, //else margin at right
                    ),
                    child: Card(
                        color: onemsg.isme ? Colors.blue[100] : Colors.red[100],
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: Text(onemsg.isme
                                      ? "ID: ME"
                                      : "ID: " + onemsg.userid)),
                              Container(
                                child: Text("Message: " + onemsg.msgtext,
                                    style: const TextStyle(fontSize: 17)),
                              ),
                            ],
                          ),
                        )));
              }).toList(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.amber,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          // _channel.sink.add('{'typing'}');  // TODO add typing logic herer--------------
                        },
                        controller: msgtext,
                        decoration: const InputDecoration(
                            hintText: 'Enter your message'),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        // const targetUser = 'user2';
                        // final message = {
                        //   'targetUser': targetUser,
                        //   'message': "_controller.text",
                        // };
                        // _channel.sink.add(jsonEncode(message));
                        // _controller.clear();

                        if (msgtext.text != "") {
                          sendmsg(
                            msgtext.text,
                            recieverid,
                          ); //send message with webspcket
                        } else {
                          print("Enter message");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }
}

class MessageData {
  String msgtext, userid;
  bool isme;
  MessageData({
    required this.msgtext,
    required this.userid,
    required this.isme,
  });
}
