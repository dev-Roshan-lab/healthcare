import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart';

class CovidPage extends StatefulWidget {
  @override
  _CovidPageState createState() => _CovidPageState();
}

class _CovidPageState extends State<CovidPage> {

  String? name;
  String condition = '';
  bool loading = false;

  getname() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString('username');
    });
  }

  getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;
      firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
      File toUpload = File(file.path!);
      try {
        final databaseReference = FirebaseDatabase.instance.reference();
        await firebase_storage.FirebaseStorage.instance.ref('drding-covid/$name').putFile(toUpload);
        String url = await firebase_storage.FirebaseStorage.instance.ref('drding-covid/$name').getDownloadURL();
        await databaseReference.child('drding-covid/$name').update({
          'audio':url
        });
        Response response = await get(Uri.parse('https://covid-detections.herokuapp.com/predict/$name'));
        print(response.body);
        setState(() {
          condition = response.body;
          loading = false;
        });
      } catch (e) {
        print('error $e');
      }
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getname();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          "Covid-19 cough check",
          style: GoogleFonts.merriweather(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            child: SvgPicture.asset('assets/img/covid.svg', height: 350),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              height: 50.0,
              width: 220.0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0.0, 20.0),
                    blurRadius: 30.0,
                    color: Colors.black12,
                  ),
                ],
                color: Theme.of(context).secondaryHeaderColor == Colors.black ? Colors.white : Theme.of(context).secondaryHeaderColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  topLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                //   borderRadius:
                //       BorderRadius.circular(25.0),
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  getFile();
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 70.0,
                      width: 170.0,
                      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0.0),
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10.0),
                        child: Text(
                          'Upload audio',
                          style: GoogleFonts.nunito(
                            color:Theme.of(context).primaryColor,fontSize: 15,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          topLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(200.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Icon(FontAwesome.picture_o,color:Theme.of(context).primaryColor == Colors.white ? Colors.black:Theme.of(context).primaryColor ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          loading ? SpinKitRipple(color: Colors.lightBlueAccent,) :
          Padding(
            padding: const EdgeInsets.only(left:8.0,top:15,bottom:15),
            child: condition != null ? Container(
              height: 50.0,
              width: 220.0,
              decoration: BoxDecoration(
                color: condition == 'negative' ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: condition == '' ? Colors.transparent : Colors.blueGrey,width: 0.2),
              ),
              child: Center(
                child: Text(
                  condition.isEmpty ? '' : condition,
                  style: GoogleFonts.nunito(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ) : Container(),
          ),
          Spacer(),
          Divider(color: Colors.blue,thickness: 15,),
          Divider(color: Colors.lightBlue.shade300,thickness: 15,),
        ],
      ),
    );
  }
}
