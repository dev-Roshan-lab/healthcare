import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health/src/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:health/src/model/dactor_model.dart';
import 'package:health/src/theme/light_color.dart';
import '../startpage.dart';

class chatPage extends StatefulWidget {
  const chatPage({Key? key}) : super(key: key);

  @override
  _chatPageState createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {

  final searchControl = TextEditingController();
  List? doctorDataList = [];

  @override
  Widget build(BuildContext context) {

    setState(() {
      doctorDataList = ModalRoute.of(context)!.settings.arguments as List<dynamic>?;
    });
    List? tempDoctorDataList = doctorDataList;
    FlutterTts flutterTts = FlutterTts();

    Widget list(DoctorModel model) {
      return ListTile(
        title: Text(model.name!),
        subtitle: Text(model.type!),
        onTap: () => Navigator.pushNamed(context, "/chatScreen"),
      );
    }

    Widget _searchField() {
      return Container(
        height: 55,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(color: Theme.of(context).primaryColor == Colors.black ? Colors.blueGrey : Colors.transparent,width: 0.2 ),
          borderRadius: BorderRadius.all(Radius.circular(13)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color:  LightColor.grey.withOpacity(.3),
              blurRadius: 15,
              offset: Offset(5, 5),
            )
          ],
        ),
        child: TextField(
          controller: searchControl,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: InputBorder.none,
            hintText: "Search",
            suffixIcon: SizedBox(
                width: 50,
                child: IconButton(icon: Icon(Icons.cancel,color: Theme.of(context).secondaryHeaderColor,), onPressed: () {
                  searchControl.clear();
                  doctorDataList = tempDoctorDataList;
                },)),
          ),
          onChanged: (v) {
            //added search
            if (v == null || v == '') {
              doctorDataList = tempDoctorDataList;
            } else {
              for (int i = 0; i< doctorDataList!.length; i++) {
                if (!doctorDataList![i].type.toLowerCase().contains(v.toLowerCase())) {
                  doctorDataList!.removeAt(i);
                }
              }
            }
          },
        ),
      );
    }

    Color randomColor() {
      var random = Random();
      final colorList = [
        Theme.of(context).primaryColor,
        LightColor.orange,
        LightColor.green,
        LightColor.grey,
        LightColor.lightOrange,
        LightColor.skyBlue,
        LightColor.titleTextColor,
        Colors.red,
        Colors.brown,
        LightColor.purpleExtraLight,
        LightColor.skyBlue,
      ];
      var color = colorList[random.nextInt(colorList.length)];
      return color;
    }

    Widget _doctorTile(DoctorModel model) {
      return GestureDetector(

        onTapCancel:() async {
          await flutterTts.speak(model.name!);
          await flutterTts.awaitSpeakCompletion(true);
          await flutterTts.speak(model.type!);
        },
        child: Tooltip(
          message:model.name,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  offset: Offset(4, 4),
                  blurRadius: 10,
                  color: LightColor.grey.withOpacity(.2),
                ),
                BoxShadow(
                  offset: Offset(-3, 0),
                  blurRadius: 15,
                  color: LightColor.grey.withOpacity(.1),
                )
              ],
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(13)),
                  child: Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: randomColor(),
                    ),
                    child: Image.asset(
                      model.image!,
                      height: 50,
                      width: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                title: Text(model.name!,
                    style: GoogleFonts.marmelad
                      (color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(
                  model.type!,
                  //style: TextStyles.bodySm.subTitleColor.bold,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: 30,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ).ripple(() {
              print(model.tags);
              Navigator.pushNamed(context, "/DetailPage", arguments: model);
            }, borderRadius: BorderRadius.all(Radius.circular(20))),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundColor: Colors.lightBlue.shade100,
          radius: 25,
          backgroundImage: NetworkImage(googleSignIn.currentUser!.photoUrl!),
        )
      ),
      body: Column(
        children: [
          _searchField(),
          ListView.builder(
            itemCount: doctorDataList!.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                  children: doctorDataList!.map((x) {
                    return _doctorTile(x);
                  }).toList());
            },
          ),
        ],
      ),
    );
  }
}
