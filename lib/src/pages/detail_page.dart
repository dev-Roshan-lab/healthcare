import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health/src/model/dactor_model.dart';
import 'package:health/src/model/video_call.dart';
import 'package:health/src/theme/extention.dart';
import 'package:health/src/theme/light_color.dart';
import 'package:health/src/theme/text_styles.dart';
import 'package:health/src/theme/theme.dart';
import 'package:health/src/widgets/rating_start.dart';
import 'package:health/widgets/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/googleAuth.dart';
import '../../main.dart';
import 'package:flutter/scheduler.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key? key, this.model}) : super(key: key);
  final DoctorModel? model;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  ClientRole _role = ClientRole.Broadcaster;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DoctorModel? model;
  String? username = '';
  String? imgUrl = '';
  String msg = '';
  final authctrl = TextEditingController();
  String? times = '';
  List appnts = [];
  late Razorpay _razorpay;
  bool success = false;
  late DateTime date;
  List tags = [];

  @override
  void initState() {
    model = widget.model;
    super.initState();
    getName();
    getCloudData();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    username = preferences.getString('username');
    imgUrl = preferences.getString('imgUrl');
    times = preferences.getString('times');
    if (times == null) {
      setState(() {
        times = '0';
      });
    }
    setState(() {
      tags = model!.tags!.split("*");
    });
  }

  getCloudData() async {
    appnts.clear();
    await FirebaseFirestore.instance.collection(model!.name!).get().then((value) {
      setState(() {
        appnts.addAll(value.docs);
      });
    });
    print(appnts);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();

  }
  Future<void> onJoin(String id,BuildContext context) async {
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoCall(
            channelName: id,
            role: ClientRole.Broadcaster,
          ),
        ),
      );
    });
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  void openCheckout(int cost, String? name) async {
    var options = {
      'key': 'rzp_test_421aJpA2JEmGGf',
      'amount': cost,
      'name': name,
      'description': 'Doctor Fees',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
    setState(() {
      success = true;
    });
    final user=await GoogleAuthApi.signIn();
    if(user==null) return;
    await FirebaseFirestore.instance
        .collection(model!.name!)
        .doc('$username-$times')
        .set({
      'cost': '500',
      'doc_id': '$username-$times',
      'img': imgUrl,
      'msg': msg,
      'name': username,
      'status': 'waiting',
      'time': date.toString(),
      'mail': user.email
    }).then((value) async {
      int t = num.parse(times!) as int;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('times', (t + 1).toString());
      getCloudData();
      Fluttertoast.showToast(
          msg: 'Successfully sent request',
          backgroundColor: Colors.green,
          textColor: Colors.green);
      setState(() {
        success = false;
      });
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  Widget _appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        BackButton(color: Theme.of(context).primaryColor),
        IconButton(
            icon: Icon(
              model!.isfavourite! ? Icons.favorite : Icons.favorite_border,
              color: model!.isfavourite! ? Colors.red : LightColor.grey,
            ),
            onPressed: () {
              setState(() {
                model!.isfavourite = !model!.isfavourite!;
              });
            })
      ],
    );
  }
  Widget _categoryCard(String title, String subtitle,
      {Color? color, required Color lightColor, required Color textColor}) {
    TextStyle titleStyle = TextStyles.title.bold.white;
    //TextStyle subtitleStyle = TextStyles.body.bold.white;
    if (AppTheme.fullWidth(context) < 392) {
      titleStyle = TextStyles.body.bold.white;
    }
    return Container(
      height: 280,
      width: 150,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            offset: Offset(4, 4),
            blurRadius: 10,
            color: lightColor.withOpacity(.8),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -20,
                left: -20,
                child: CircleAvatar(
                  backgroundColor: lightColor,
                  radius: 60,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                    child: Text(title,
                        style: GoogleFonts.nunito(
                            fontSize: 15, fontWeight: FontWeight.bold, color: textColor))
                        .hP8,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: Text(
                      subtitle,
                      style: GoogleFonts.nunito(
                          fontSize: 15, color: textColor),
                    ).hP8,
                  ),
                ],
              ).p16
            ],
          ),
        ),
      ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyles.title.copyWith(fontSize: 25).bold;

    TextStyle subtitleStyle = TextStyles.body.bold.white;
    if (AppTheme.fullWidth(context) < 393) {
      subtitleStyle = TextStyles.bodySm.bold.white;
      titleStyle = TextStyles.title.copyWith(fontSize: 23).bold;
    }
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: Image.asset(model!.image!),
            ),
            DraggableScrollableSheet(
              maxChildSize: .8,
              initialChildSize: .70,
              minChildSize: .65,
              builder: (context, scrollController) {
                return Container(
                  height: AppTheme.fullHeight(context) * .6,
                  padding: EdgeInsets.only(
                      left: 19,
                      right: 19,
                      top: 16), //symmetric(horizontal: 19, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(model!.name!,
                                  style: GoogleFonts.marmelad(
                                      color: Theme.of(context).secondaryHeaderColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                             IconButton(
                               icon: Icon(Icons.rotate_right), // coffin ready panniko na vandhu coffin dance song podren
                               // poda curd
                               onPressed: () async => await getCloudData(),
                               color: Colors.white,
                             )
                            ],
                          ),
                          subtitle: Text(
                            model!.type!,
                            style: TextStyles.bodySm.subTitleColor.bold,
                          ),
                        ),
                        Divider(
                          thickness: .3,
                          color: LightColor.grey,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RatingStar(
                              rating: model!.rating,
                            )
                          ],
                        ),
                        Divider(
                          thickness: .3,
                          color: LightColor.grey,
                        ),
                        Text("About", style: titleStyle).vP16,
                        Text(
                          model!.description!,
                          style: TextStyles.bodySm.subTitleColor,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Clinical Focus", style: titleStyle).vP16,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            height: 50,
                            width: AppTheme.fullWidth(context) - 20,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: tags.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left:8.0,top:2,bottom:2),
                                  child: Container(
                                    decoration: BoxDecoration(
                                     color: Theme.of(context).primaryColor == Colors.white ? Colors.grey[100] : Colors.white12,
                                      // boxShadow:[ BoxShadow(
                                      //   color: Colors.blueGrey,
                                      // ),],
                                      // gradient: LinearGradient(colors: [Colors.lightBlueAccent,Colors.blue.withOpacity(0.9)]),
                                      borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.blueGrey,width: 0.2),
                                    ),


                                    child: Padding(
                                      padding: const EdgeInsets.only(left:10,right:10,top:8.0,bottom:8),
                                      child: Center(
                                        child: DottedText(
                                          tags[index],
                                          style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context).secondaryHeaderColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: authctrl,
                          decoration: InputDecoration(
                            suffixIcon: Transform.rotate(
                              angle: 3.92,
                              child: IconButton(
                                icon: Icon(
                                  Icons.add_circle,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  authctrl.clear();
                                },
                              ),
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Enter your message',
                            labelStyle: TextStyle(color: Colors.blueGrey),
                            fillColor: Colors.blueGrey,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          onSubmitted: (tag) {
                            print('--------------tag');
                            print(tag);
                            setState(() {
                              msg = tag;
                            });
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FloatingActionButton(
                                  heroTag: "lol",
                                  child: Icon(Icons.call,color: Theme.of(context).secondaryHeaderColor,),
                                  onPressed: () async {
                                    const url = 'tel:9444160512';
                                    if (await canLaunch(url)) {
                                      launch(url);
                                    }
                                  },
                                  backgroundColor: Colors.lightBlue.withOpacity(0.7),
                                  focusColor: Colors.blue,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                FloatingActionButton(
                                  heroTag: "ogg",
                                  child: Icon(Icons.message,color: Theme.of(context).secondaryHeaderColor,),
                                  onPressed: () async {
                                    print('lol');
                                    const url =
                                        'sms:+919444160512?body=Hello%20Doctor';
                                    if (await canLaunch(url)) {
                                      launch(url);
                                    }
                                  },
                                  backgroundColor: Colors.lightBlue.withOpacity(0.7),
                                  focusColor: Colors.blue,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await DatePicker.showDateTimePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(2020, 5, 5, 20, 50),
                                        maxTime: DateTime(2022, 10, 30, 05, 09),
                                        onConfirm: (time) async {
                                          print('confirm $time');
                                          setState(() {
                                            date = time;
                                          });
                                          scheduleAlarm(date,
                                              'Medical checkup on ${date.toString()} with ${model!.name}');
                                          //fixed opening of checkout even on clicking cancel
                                          openCheckout(5000, model!.name);
                                        });
                                    if (msg == '' || success == false) {
                                    } else {
                                      await getName();
                                    }
                                  },
                                  child: Container(
                                    width: 220,
                                    height: 45,
                                    decoration:BoxDecoration(gradient: LinearGradient(colors: [Colors.lightBlueAccent,Colors.blue.withOpacity(0.8)]),borderRadius: BorderRadius.circular(10)),

                                    child: Center(
                                      child: Text(
                                        "Make an appointment",
                                        style: GoogleFonts.nunito(fontSize: 12,color: Colors.white),
                                      ).p(10),
                                    ),
                                  ),
                                ),
                              ],
                            ).vP16,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(2),
                          child: SizedBox(
                            height: 100,
                            child: ListView.builder(
                              itemCount: appnts.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemBuilder: (context, int) {
                                return  appnts[int]
                                ["status"] ==
                                    'waiting' ? _categoryCard(appnts[int]["status"].toString().toUpperCase(), appnts[int]["msg"],color: Colors.yellow, lightColor: Colors.yellowAccent, textColor: Colors.black) : _categoryCard(appnts[int]["status"].toString().toUpperCase(), appnts[int]["msg"],color: LightColor.green, lightColor: LightColor.lightGreen, textColor: Colors.green).ripple(() {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Accept appointment?',
                                            style: GoogleFonts.merriweather(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: Text(
                                            'Your appointment has been accepted by the doctor and you may join the video call now. Stay healthy!',
                                            style: GoogleFonts.raleway(),
                                          ),
                                          actions: [
                                            FlatButton(
                                                child: Text('Join video call',style:GoogleFonts.nunito(color: Colors.green)),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  onJoin('skr-sln-tmo',context);
                                                }),
                                            FlatButton(
                                                child: Text('Close',style:GoogleFonts.nunito(color:Theme.of(context).secondaryHeaderColor)),
                                                onPressed: () {

                                                  Navigator.pop(context);
                                                }
                                            ),
                                          ],
                                        );
                                      });
                                      // Navigator.pushNamed(context, '/BreakOutRoombu');

                                    });

                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            _appbar(),
          ],
        ),
      ),
    );
  }

  void scheduleAlarm(
      DateTime scheduledNotificationDateTime, String alarmInfo) async {
    print('doing alaram-----------');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'Channel for Alarm notification',
      icon: 'ic_launcher',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .schedule(0, 'Office', alarmInfo, scheduledNotificationDateTime,
            platformChannelSpecifics)
        .then((value) => print('----------------------value'));
  }
}
