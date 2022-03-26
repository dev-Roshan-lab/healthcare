import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health/authentication/createAcc.dart';
import 'package:health/pages/profile.dart';
import 'package:health/src/model/dactor_model.dart';
import 'package:health/src/theme/extention.dart';
import 'package:health/src/theme/light_color.dart';
import 'package:health/src/theme/text_styles.dart';
import 'package:health/src/theme/theme.dart';
import 'package:health/startpage.dart';
import 'package:health/widgets/UserInfo.dart';
import 'package:health/widgets/utils.dart';
import 'package:http/http.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

bool langChanged=false;
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterTts flutterTts = FlutterTts();
  String? username;
  String? imgUrl;
  List? doctorMapList;
  String title="Hello,";
  String search="Search";
  String title1="AI Prediction";
  String title2="Consult a Doctor";
  String tb="TB Prediction";
  String skincancer="Skin Cancer Prediction";
  String covid="Covid-19 Prediction";
  String symp = "Symptom Prediction";
  String nearby="Nearby Hospitals";
  String? customBio = "Staying healthy!";
  String fromLanguageCode='en';
  String toLanguage='ta';
  final fieldText = TextEditingController();
  List<DoctorModel>? doctorDataList;
  final searchControl = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final translator = GoogleTranslator();

  @override
  void initState() {
    getUserInfo();
    super.initState();
    sendRequest();
  }

  translateText() async {
    langChanged ? await translator.translate(title, from: fromLanguageCode, to: toLanguage).then((value) {
      title = value.text;
      //setState(() {});
    }) : null;
    langChanged ? await translator.translate("Search", from: fromLanguageCode, to: toLanguage).then((value) {
      search = value.text;
      //setState(() {});
    }) : null;
    langChanged ? await translator.translate(title1, from: fromLanguageCode, to: toLanguage).then((value) {
      title1 = value.text;
    }):null;
    langChanged ? await translator.translate(tb, from: fromLanguageCode, to: toLanguage).then((value) {
      tb = value.text;
    }):null;
    langChanged ? await translator.translate(skincancer, from: fromLanguageCode, to: toLanguage).then((value) {
      skincancer = value.text;
    }):null;
    langChanged ? await translator.translate(covid, from: fromLanguageCode, to: toLanguage).then((value) {
      covid = value.text;
    }):null;
    langChanged ? await translator.translate(symp, from: fromLanguageCode, to: toLanguage).then((value) {
      symp = value.text;
    }):null;
    langChanged ? await translator.translate(nearby, from: fromLanguageCode, to: toLanguage).then((value) {
      nearby = value.text;
    }):null;
    langChanged ? await translator.translate(title2, from: fromLanguageCode, to: toLanguage).then((value) {
      title2 = value.text;
    }):null;
  }

  sendRequest() async {
    Response response = await get(Uri.parse('https://csv2api.herokuapp.com/api/v1?url=https://raw.githubusercontent.com/dev-Roshan-lab/healthcare/main/data.csv'));
    Map fetchedData = jsonDecode(response.body);
    doctorMapList = fetchedData["results"];
    doctorDataList = doctorMapList!.map((x) => DoctorModel.fromJson(x)).toList();
    setState(() {});
    print(doctorMapList);
  }

  getUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    username = preferences.get('username') as String?;
    imgUrl = preferences.get('imgurl') as String?;
    if (preferences.containsKey('bio')) {
      customBio = preferences.get('bio') as String?;
    }
    setState(() {
      username = preferences.get('username') as String?;
      imgUrl = preferences.get('imgurl') as String?;
      UserInformation().imgurl = imgUrl;
      UserInformation().username = username;
    });
    print('img url $imgUrl');
    UserInformation().imgurl = imgUrl;
    UserInformation().username = username;
    if (username == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return CreateAccount();
      }));
    }
  }

  Widget _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor:Theme.of(context).primaryColor,
      leading: IconButton(
        icon: Icon(Icons.short_text, color: Theme.of(context).secondaryHeaderColor,),
        onPressed: () {
          _scaffoldKey.currentState!.openDrawer();
        },
        ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundColor: Colors.lightBlue.shade100,
            radius: 25,
            backgroundImage: NetworkImage(googleSignIn.currentUser!.photoUrl!),
          ),
        ),
        IconButton(
            icon: Icon(Icons.language),
            onPressed: () {
              showDialog(
                  context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Choose language'),
                    actions: [
                      TextButton(
                        child: Text('English'),
                        onPressed: () async {
                          setState(() {
                            fromLanguageCode = toLanguage;
                            toLanguage = 'en';
                            langChanged = true;
                          });
                          await translateText();
                          Navigator.pop(context);
                          setState(() {});
                        },
                      ),
                      TextButton(
                        child: Text('Hindi'),
                        onPressed: () async {
                          setState(() {
                            fromLanguageCode = toLanguage;
                            toLanguage = 'hi';
                            langChanged = true;
                          });
                          await translateText();
                          Navigator.pop(context);
                          setState(() {});
                        },
                      ),
                      TextButton(
                        child: Text('Tamil'),
                        onPressed: () async {
                          setState(() {
                            fromLanguageCode = toLanguage;
                            toLanguage = 'ta';
                            langChanged = true;
                          });
                          await translateText();
                          Navigator.pop(context);
                          setState(() {});
                        },
                      ),
                    ],
                  );
                },
              );
            }
        )
      ],
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
       Text(title, style: GoogleFonts.ubuntu(color: Colors.grey)),
        Text(username == null ? "" : username!,
            style: GoogleFonts.merriweather(fontSize: 30,color: Theme.of(context).secondaryHeaderColor)),
      ],
    ).p16;
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
          hintText: search,
          hintStyle: TextStyles.body.subTitleColor,
          suffixIcon: SizedBox(
              width: 50,
              child: IconButton(icon: Icon(Icons.cancel,color: Theme.of(context).secondaryHeaderColor,), onPressed: () {
                searchControl.clear();
                doctorDataList = doctorMapList!.map((x) => DoctorModel.fromJson(x)).toList();
              },)),
        ),
        onChanged: (v) {
          //added search
          if (v == null || v == '') {
            doctorDataList = doctorMapList!.map((x) => DoctorModel.fromJson(x)).toList();
          } else {
            for (int i = 0; i< doctorDataList!.length; i++) {
              if (!doctorDataList![i].type!.toLowerCase().contains(v.toLowerCase())) {
                doctorDataList!.removeAt(i);
              }
            }
          }
        },
      ),
    );
  }

  Widget _category() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10, right: 16, left: 16, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title1,
                  style: GoogleFonts.merriweather(fontSize: 20,color: Theme.of(context).secondaryHeaderColor,)),
            ],
          ),
        ),
        SizedBox(
          height: AppTheme.fullHeight(context) * .28,
          width: AppTheme.fullWidth(context),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              GestureDetector(
                onTapCancel:() async {
                  await flutterTts.speak(tb);
                },
                child: Tooltip(
                  message: tb,
                  verticalOffset: 50,
                  child: Container(
                    child: _categoryCard(tb, "",
                        color: LightColor.green, lightColor: LightColor.lightGreen),
                  ).ripple(() {
                    Navigator.pushNamed(
                      context,
                      "/TBPage",
                    );
                  }),
                ),
              ),
              GestureDetector(
                onTapCancel:() async {
                  await flutterTts.speak(skincancer);
                },
                child: Tooltip(
                  message: skincancer,
                  verticalOffset: 50,
                  child: Container(
                    child: _categoryCard(skincancer, "",
                        color: LightColor.skyBlue,
                        lightColor: LightColor.lightBlue),
                  ).ripple(() {
                    Navigator.pushNamed(context, "/SkinPage");
                  }),
                ),
              ),
              GestureDetector(
                onTapCancel:() async {
                  await flutterTts.speak(covid);
                },
                child: Tooltip(
                  message: covid,
                  verticalOffset: 50,
                  child: Container(
                    child: _categoryCard(covid, "",
                        color: LightColor.orange,
                        lightColor: LightColor.lightOrange),
                  ).ripple(() {
                    Navigator.pushNamed(
                      context,
                      "/CovidPage",
                    );
                  }),
                ),
              ),
              GestureDetector(
                onTapCancel:() async {
                  await flutterTts.speak(symp);
                },
                child: Tooltip(
                  message: symp,
                  verticalOffset: 50,
                  child: Container(
                    child: _categoryCard(symp, "",
                        color: Colors.red,
                        lightColor: Colors.redAccent),
                  ).ripple(() {
                    Navigator.pushNamed(
                      context,
                      "/SympPage",
                    );
                  }),
                ),
              ),
              GestureDetector(

                onTapCancel:() async {
                  await flutterTts.speak(nearby);
                },child: Tooltip(
                  message: nearby,
                  verticalOffset: 50,
                  child: Container(
                    child: _categoryCard(nearby, "",
                        color: Colors.yellow, lightColor: Colors.yellowAccent),
                  ).ripple(() async {
                    MapsLauncher.launchQuery('Hospitals nearby');
                  }),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _categoryCard(String title, String subtitle,
      {Color? color, required Color lightColor}) {
    TextStyle titleStyle = TextStyles.title.bold.white;
    TextStyle subtitleStyle = TextStyles.body.bold.white;
    if (AppTheme.fullWidth(context) < 392) {
      titleStyle = TextStyles.body.bold.white;
      subtitleStyle = TextStyles.bodySm.bold.white;
    }
    return AspectRatio(
      aspectRatio: 6 / 8,
      child: Container(
        height: 280,
        width: AppTheme.fullWidth(context) * .3,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
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
                                  fontSize: 15, fontWeight: FontWeight.bold))
                          .hP8,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      child: Text(
                        subtitle,
                        style: subtitleStyle,
                      ).hP8,
                    ),
                  ],
                ).p16
              ],
            ),
          ),
        ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  Widget _doctorsList() {

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title2,
                  style: GoogleFonts.merriweather(fontSize: 20,color: Theme.of(context).secondaryHeaderColor,)),
              IconButton(
                  icon: Icon(
                    Icons.rotate_right_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {

                  })
              // .p(12).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
            ],
          ).hP16,
          doctorDataList == null ? SpinKitRipple(color: Colors.lightBlue,) : getdoctorWidgetList()
        ],
      ),
    );
  }

  Widget getdoctorWidgetList() {

    return Column(
        children: doctorDataList!.map((x) {
      return _doctorTile(x);
    }).toList());
  }

  Widget _doctorTile(DoctorModel model) {
    langChanged ? translator.translate(model.name!, from: fromLanguageCode, to: toLanguage).then((value) {
      model.name = value.text;
    }):null;
    langChanged ? translator.translate(model.type!, from: fromLanguageCode, to: toLanguage).then((value) {
      model.type = value.text;
    }):null;
    setState(() {});
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
                  style: GoogleFonts.marmelad(color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text(
                model.type!,
                style: TextStyles.bodySm.subTitleColor.bold,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar() as PreferredSizeWidget?,
      backgroundColor:Theme.of(context).primaryColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _header(),
                _searchField(),
                _category(),
              ],
            ),
          ),
          _doctorsList()
        ],
      ),
      drawer: new Drawer(
        child: ListView(
          children: [
            Container(
              color: Colors.lightBlue[300],
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, right: 250.0),
                    child: Icon(
                      Icons.format_quote_outlined,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: customBio == ""
                        ? Text("Staying healthy!",
                            style: GoogleFonts.quicksand(
                                fontSize: 25, fontWeight: FontWeight.w600))
                        : Text("$customBio",
                            style: GoogleFonts.quicksand(
                                fontSize: 25, fontWeight: FontWeight.w600)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 250.0),
                    child: Icon(
                      Icons.format_quote_outlined,
                      size: 20,
                    ),
                  ),
                  Container(
                    color: Colors.lightBlue[300],
                    padding: EdgeInsets.only(top: 10, bottom: 15, left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return EditProfile();
                            }));
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                  radius: 25,
                                  backgroundImage: (imgUrl
                                          .toString()
                                          .contains('com.rachinc.respic')
                                      ? FileImage(
                                          File(imgUrl.toString()),
                                        )
                                      : CachedNetworkImageProvider(
                                          imgUrl == null
                                              ? username.toString()[0]
                                              : imgUrl!)) as ImageProvider<Object>?,
                                  child: imgUrl == null
                                      ? Text("${username.toString()[0]}")
                                      : null),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SizedBox(
                                      width: 200,
                                      child: Text('${username}',
                                          style: GoogleFonts.merriweather(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return EditProfile();
                            }));
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 20),
                              CircleAvatar(
                                  radius: 17,
                                  backgroundImage: (imgUrl
                                          .toString()
                                          .contains('com.rachinc.respic')
                                      ? FileImage(
                                          File(imgUrl.toString()),
                                        )
                                      : CachedNetworkImageProvider(
                                          imgUrl == null
                                              ? username.toString()[0]
                                              : imgUrl!)) as ImageProvider<Object>?,
                                  child: imgUrl == null
                                      ? Text("${username.toString()[0]}")
                                      : null),
                              SizedBox(
                                width: 50,
                              ),
                              Text('Profile',
                                  style: GoogleFonts.ubuntu(fontSize: 20))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'appointments');
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 20),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Icon(
                                  Icons.message_outlined,
                                  size: 28,
                                  color: Colors.blueGrey.shade600,
                                ),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Text('Appointments',
                                  style: GoogleFonts.ubuntu(fontSize: 20)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Utils.openEmail(
                              toEmail: 'contact@respic.ml',
                              subject: 'Subject',
                              body: 'Enter your requests, queries here!\n',
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 20),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Icon(
                                  Icons.contact_mail_outlined,
                                  size: 28,
                                  color: Colors.blueGrey.shade600,
                                ),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Text('Contact us',
                                  style: GoogleFonts.ubuntu(fontSize: 20)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print('lauch link');
                          },
                          child: Row(
                            children: [
                              SizedBox(width: 20),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Icon(
                                  Icons.star_rate_rounded,
                                  size: 32,
                                  color: const Color(0xffFFD700),
                                ),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Text('Rate the app',
                                  style: GoogleFonts.ubuntu(fontSize: 20)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: customBio!.length < 60
                        ? const EdgeInsets.only(
                            top: 210.0, left: 50, right: 50)
                        : const EdgeInsets.only(
                            top: 210.0, left: 50, right: 50),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 20),
                            IconButton(
                                icon: Icon(
                                  FontAwesome.globe,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Utils.openLink(url: 'https://respic.ml');
                                }),
                            IconButton(
                                icon: Icon(
                                  FontAwesome.instagram,
                                  color: Colors.pink,
                                ),
                                onPressed: () {
                                  Utils.openLink(
                                      url:
                                          'https://instagram.com/respic.ml?igshid=ae7jq1hbzz35');
                                }),
                            IconButton(
                                icon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.blueGrey,
                                ),
                                onPressed: () {
                                  Utils.openEmail(
                                    toEmail: 'contact@respic.ml',
                                    subject: 'Subject',
                                    body:
                                        'Enter your requests, queries here!\n',
                                  );
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              //TODO: privacy policy

                              if (await canLaunch(
                                  'https://respic.ml/#/privacy-policy')) {
                                launch(
                                  'https://respic.ml/#/privacy-policy', //change it to diff url
                                );
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Oops! Something seems wrong",
                                    textColor: Colors.white,
                                    backgroundColor: Colors.black);
                              }
                            },
                            child: Text(
                              'Privacy Policy',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (await canLaunch(
                                  'https://respic.ml/#/privacy-policy')) {
                                launch(
                                  'https://respic.ml/#/terms-and-conditions',
                                );
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Oops! Something seems wrong",
                                    textColor: Colors.white,
                                    backgroundColor: Colors.black);
                              }
                            },
                            child: Text(
                              'Terms and Conditions',
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
