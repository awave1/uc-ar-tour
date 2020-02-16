import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:ezar/style/theme.dart' as MTheme;
import 'package:ezar/utils/swiper.dart';
import 'package:ezar/ui/upload_pics_page.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

class ProfilePage extends StatefulWidget {
  String user_id;

  ProfilePage({this.user_id});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  String _fullName;
  String _profilelink;

  loadData() async {
    print(widget.user_id);
    Response re1 = await Dio()
        .post("https://ez-ar.herokuapp.com/users/getters/getProfile", data: {
      "method": 'getProfile',
      "user_id": widget.user_id,
    });

    Response re2 = await Dio()
        .post("https://ez-ar.herokuapp.com/users/getters/getUserName", data: {
      "method": 'getUserName',
      "user_id": widget.user_id,
    });

    var result1 = json.decode(re1.toString());
    var result2 = json.decode(re2.toString());
    setState(() {
      _fullName = result2['username'];
      _profilelink = result1['profilepicture'];
    });
  }

  @override
  void initState() {
    if (_fullName == null) {
      loadData();
    } else {
      print(_fullName);
      print(_profilelink);
    }

    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height * 0.26,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [
              MTheme.Colors.loginGradientStart,
              MTheme.Colors.loginGradientEnd
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
    );
  }

  Widget _buildProfileImage(Size screensize) {
    if (_profilelink != null) {
      return Center(
        child: new GestureDetector(
          child: Container(
            width: screensize.height * 0.13,
            height: screensize.height * 0.13,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: new CachedNetworkImageProvider(_profilelink),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(80.0),
              border: Border.all(
                color: Colors.white,
                width: 5.0,
              ),
            ),
          ),
          onTap: () {},
        ),
      );
    } else {
      return Center(
        child: new GestureDetector(
          child: Container(
            width: screensize.height * 0.13,
            height: screensize.height * 0.13,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/login_logo.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(80.0),
              border: Border.all(
                color: Colors.white,
                width: 5.0,
              ),
            ),
          ),
          onTap: () {},
        ),
      );
    }
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Spectral',
      color: Colors.white,
      fontSize: 24.0,
      fontWeight: FontWeight.w300,
    );

    if (_fullName != null) {
      return Text(
        _fullName,
        style: _nameTextStyle,
      );
    } else {
      return Text("Loading...", style: _nameTextStyle);
    }
  }

  Widget _buildTabBar() {
    return Container(
      child: new TabBar(
        tabs: <Widget>[
          new Tab(
            text: "Discover",
          ),
          new Tab(
            text: "AR Navigation",
          ),
        ],
        labelColor: Colors.black,
        indicatorColor: Colors.deepOrangeAccent,
      ),
    );
  }

  bool check = true;
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double aHeight;
    aHeight = MediaQuery.of(context).padding.top;

    if (aHeight == 44) {
      aHeight = 10;
    }

    if (aHeight == 0 || aHeight == 20) {
      aHeight = 44;
    }

    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        body: new Column(
          children: <Widget>[
            new Stack(
              children: <Widget>[
                _buildCoverImage(screenSize),
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: aHeight),
                        _buildProfileImage(screenSize),
                        SizedBox(height: 15),
                        _buildFullName(),
                        //SizedBox(height: 15.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _buildTabBar(),
            new Expanded(
              child: new TabBarView(
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new PicSwiper(),
                      SizedBox(
                        height: check
                            ? screenSize.height * 0.1
                            : screenSize.height * 0.18,
                      ),
                      new RaisedButton(
                        child: check
                            ? Text("Open Room Finder")
                            : Text("Close Room Finder"),
                        onPressed: () {
                          if (check == true) {
                            flutterWebviewPlugin.launch(
                              "https://ucmapspro.ucalgary.ca/RoomFinder/",
                              rect: Rect.fromLTWH(
                                  0.0,
                                  0.0,
                                  MediaQuery.of(context).size.width,
                                  screenSize.height * 0.75),
                            );
                            check = false;
                          } else {
                            flutterWebviewPlugin.close();
                            check = true;
                          }

                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      // new CameraApp()
                      new Text("AR Navigation")
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}
