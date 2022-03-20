import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

class SympPred extends StatefulWidget {
  @override
  _SympPredState createState() => _SympPredState();
}

class _SympPredState extends State<SympPred> {

  String? sym1 = 'coma';
  String? sym2 = 'back pain';
  String? sym3 = 'chest pain';
  String? sym4 = 'muscle weakness';
  String? sym5 = 'irritability';
  bool loading = false;
  String disease = '';

  var l1=['coma','stomach bleeding','distention of abdomen',
    'history of alcohol consumption','fluid overload','blood in sputum','prominent veins on calf',
    'palpitations','painful walking','pus filled pimples','blackheads','scurring','skin peeling',
    'silver like dusting','small dents in nails','inflammatory nails','blister','red sore around nose',
    'yellow crust ooze'];

  var l2 = ['back pain','constipation','abdominal pain','diarrhoea','mild fever','yellow urine',
    'yellowing of eyes','acute liver failure','fluid overload','swelling of stomach',
    'swelled lymph nodes','malaise','blurred and distorted vision','phlegm','throat irritation',
    'redness of eyes','sinus pressure','runny nose','congestion'];

  var l3 = ['chest pain','weakness in limbs',
    'fast heart rate','pain during bowel movements','pain in anal region','bloody stool',
    'irritation in anus','neck pain','dizziness','cramps','bruising','obesity','swollen legs',
    'swollen blood vessels','puffy face and eyes','enlarged thyroid','brittle nails',
    'swollen extremeties','excessive hunger'];

  var l4 = ['extra marital contacts','drying and tingling lips',
    'slurred speech','knee pain','hip joint pain','muscle weakness','stiff neck','swelling joints',
    'movement stiffness','spinning movements','loss of balance','unsteadiness',
    'weakness of one body side','loss of smell','bladder discomfort','foul smell of urine',
    'continuous feel of urine','passage of gases','internal itching'];

  var l5 = ['toxic look (typhos)',
    'depression','irritability','muscle pain','altered sensorium','red spots over body','belly pain',
    'abnormal menstruation','dischromic  patches','watering from eyes','increased appetite','polyuria','family history','mucoid sputum',
    'rusty sputum','lack of concentration','visual disturbances','receiving blood transfusion',
    'receiving unsterile injections'];

  getResponse() async {
    Response response = await get(Uri.parse('https://symptom-predictor-api.herokuapp.com/rf/$sym1/$sym2/$sym3/$sym4/$sym5'));
    setState(() {
      disease = response.body;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Disease Prediction",
          style: GoogleFonts.merriweather(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Select your symptoms or conditions',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            SizedBox(height: 40,),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: Offset(
                      0, 5
                    )
                  )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    underline: null,
                    value: sym1,
                    items: l1.map((var str) {
                      return DropdownMenuItem(
                        value: str,
                        child: Text(str, style: TextStyle(color: Colors.black),),
                      );
                    }).toList(),
                    onChanged: (dynamic v) {
                      setState(() {
                        sym1 = v;
                      });
                      print(sym1);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(
                            0, 5
                        )
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: sym2,
                    items: l2.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e, style: TextStyle(color: Colors.black),),
                      );
                    }).toList(),
                    onChanged: (dynamic v) {
                      setState(() {
                        sym2 = v;
                      });
                      print(sym2);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(
                            0, 5
                        )
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: sym3,
                    items: l3.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e, style: TextStyle(color: Colors.black),),
                      );
                    }).toList(),
                    onChanged: (dynamic v) {
                      setState(() {
                        sym3 = v;
                      });
                      print(sym3);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(
                            0, 5
                        )
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: sym4,
                    items: l4.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e, style: TextStyle(color: Colors.black),),
                      );
                    }).toList(),
                    onChanged: (dynamic v) {
                      setState(() {
                        sym4 = v;
                      });
                      print(sym4);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(
                            0, 5
                        )
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: sym5,
                    items: l5.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e, style: TextStyle(color: Colors.black),),
                      );
                    }).toList(),
                    onChanged: (dynamic v) {
                      setState(() {
                        sym5 = v;
                      });
                      print(sym5);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 50,),
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
                    getResponse();
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
                            'Predict',
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
            SizedBox(
              height: 20,
            ),
            loading ? SpinKitRipple(color: Colors.lightBlueAccent,) :
            disease != '' ? GestureDetector(
              onTap: () async {
                var url = "https://www.google.com/search?q=$disease";
                if (await canLaunch(url))
                await launch(url);
                else
                // can't launch url, there is some error
                throw "Could not launch $url";
              },
              child: Padding(
                padding: const EdgeInsets.only(left:8.0,top:15,bottom:15),
                child: Container(
                  height: 50.0,
                  width: 220.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blueGrey,width: 0.2),
                  ),
                  child: Center(
                    child: Text(
                      disease,
                      style: GoogleFonts.nunito(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
