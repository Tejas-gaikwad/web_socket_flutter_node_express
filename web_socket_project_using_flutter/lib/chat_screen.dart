import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class ChatScreen extends StatefulWidget {
  final String myid;
  const ChatScreen({
    super.key,
    required this.myid,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IOWebSocketChannel _channel;

  bool connected = false; // boolean value to track connection status

  String myid = ""; //my id
  String recieverid = "111"; //reciever id
  // swap myid and recieverid value on another mobile to test send and recieve
  String auth = "chatapphdfgjd34534hjdfk"; //auth key

  List<MessageData> msglist = [];

  TextEditingController msgtext = TextEditingController();

  @override
  void initState() {
    super.initState();
    myid = widget.myid;

    channelconnect();
  }

  channelconnect() {
    try {
      print('TRYING TO CONNECT TO SOCKET 1 ->>>>>>>>>>>>>>>>>>>>>>>>>>');
      _channel = IOWebSocketChannel.connect('ws://10.0.2.2:6060/$myid');
      print('TRYING TO CONNECT TO SOCKET 2 ->>>>>>>>>>>>>>>>>>>>>>>>>>');
      _channel.stream.listen(
        (message) {
          print("message   ->>>>>>>>>>>>>     " + message);
          setState(() {
            if (message == "connected") {
              connected = true;
              setState(() {});
              print("Connection establised.");
            } else if (message == "send:success") {
              print("Message send success");
              setState(() {
                msgtext.text = "";
              });
            } else if (message == "send:error") {
              print("Message send error");
            } else if (message.substring(0, 6) == "{'cmd'") {
              print("Message data");
              message = message.replaceAll(RegExp("'"), '"');
              var jsondata = json.decode(message);
              msglist.add(MessageData(
                //on message recieve, add data to model
                msgtext: jsondata["msgtext"],
                userid: jsondata["userid"],
                isme: false,
              ));
              setState(() {
                //update UI after adding data to message model
              });
            }
          });
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (error) {
      print("error on connecting to websocket.   ==>>>>    $error");
    }
  }

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
        title: Text("My ID: $myid - Chat App Example"),
        leading: Icon(Icons.circle,
            color: connected ? Colors.greenAccent : Colors.redAccent),
        //if app is connected to node.js then it will be gree, else red.
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Text("Your Messages", style: TextStyle(fontSize: 20)),
            ),

            Container(
                child: Column(
              children: msglist.map((onemsg) {
                return Container(
                    margin: EdgeInsets.only(
                      //if is my message, then it has margin 40 at left
                      left: onemsg.isme ? 40 : 0,
                      right: onemsg.isme ? 0 : 40, //else margin at right
                    ),
                    child: Card(
                        color: onemsg.isme ? Colors.blue[100] : Colors.red[100],
                        //if its my message then, blue background else red background
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  child: Text(onemsg.isme
                                      ? "ID: ME"
                                      : "ID: " + onemsg.userid)),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text("Message: " + onemsg.msgtext,
                                    style: TextStyle(fontSize: 17)),
                              ),
                            ],
                          ),
                        )));
              }).toList(),
            )),

            // Row(
            //   children: [
            //     Expanded(
            //       child: StreamBuilder(
            //         stream: _channel.stream,
            //         builder: (context, snapshot) {
            //           final data = snapshot.connectionState;
            //           print('DATA  ->>>>>   ${data}');
            //           return Container(
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 12, vertical: 10),
            //               color: Colors.amber,
            //               child: Text(data.toString()));
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgtext,
                      decoration:
                          const InputDecoration(hintText: 'Enter your message'),
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
