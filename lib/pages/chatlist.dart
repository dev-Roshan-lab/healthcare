import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class chatList extends StatefulWidget {
  const chatList({Key? key}) : super(key: key);

  @override
  _chatListState createState() => _chatListState();
}

class _chatListState extends State<chatList> {

  String? username;
  String? imgUrl;
  String? number;
  final textController = TextEditingController();

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.get('username') as String?;
      imgUrl = preferences.get('imgUrl') as String?;
      number = preferences.get('number') as String?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height-70,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Dr. Surbhi Anand').doc('$username-chat').collection('chats').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Has error');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(height: 50, width: 50, child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  print('no data');
                  return Text('No data available');
                }
                print(snapshot.data);
                return ListTile(
                  title: Text('chatDoc[msg]'),
                  subtitle: Text('chatDoc[time]'),
                );
              },
            ),
          ),
          Container(
            height: 70,
            child: Row(
              children: [
                TextField(
                  controller: textController,
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    //FirebaseFirestore.instance.collection('Dr. Surbhi Anand').doc('$username-chat').collection('chats').add()
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
