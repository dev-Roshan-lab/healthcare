// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:health/src/model/video_call.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class Room extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => IndexState();
// }
//
// class IndexState extends State<Room> {
//   final _channelController = TextEditingController();
//   bool _validateError = false;
//   ClientRole _role = ClientRole.Broadcaster;
//
//   @override
//   void dispose() {
//     _channelController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text('Start Video Call'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           height: 400,
//           child: Card(
//             child: Column(
//               children: <Widget>[
//                 Text('Join meeting'),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   child: Row(
//                     children: <Widget>[
//                       Expanded(
//                         child: RaisedButton(
//                           onPressed: () {
//                             onJoin('skr-lks-tmo',context);
//                           },
//                           child: Text('Join'),
//                           color: Colors.blueAccent,
//                           textColor: Colors.white,
//                         ),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
// }
//
// // run the emulator