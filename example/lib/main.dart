import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String? platformVersion;

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Screenshot(
          controller: screenshotController,
          child: Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Running on: $_platformVersion\n',
                  textAlign: TextAlign.center,
                ),
                RaisedButton(
                  onPressed: () async {
                    final file =
                        await ImagePicker().getImage(source: ImageSource.gallery);
                    SocialShare.shareInstagramStory(
                      mediaPath: file!.path,
                      backgroundTopColor: "#ffffff",
                      backgroundBottomColor: "#000000",
                      attributionURL: "https://deep-link-url",
                    ).then((data) {
                      print(data);
                    });
                  },
                  child: Text("Share On Instagram Story"),
                ),
                RaisedButton(
                  onPressed: () async {
                    final file =
                        await ImagePicker().getImage(source: ImageSource.gallery);
                    final tempDir = await getTemporaryDirectory();
                    await screenshotController
                        .captureAndSave(tempDir.path)
                        .then((imagePath) async {
                      SocialShare.shareInstagramStoryWithSticker(
                        stickerPath: imagePath!,
                        backgroundTopColor: "#ffffff",
                        backgroundBottomColor: "#000000",
                        attributionURL: "https://deep-link-url",
                        mediaPath: file!.path,
                        mediaType: ShareMediaType.image,
                      ).then((data) {
                        print(data);
                      });
                    });
                  },
                  child: Text("Share On Instagram Story image with sticker"),
                ),
                RaisedButton(
                  onPressed: () async {
                    final file =
                        await ImagePicker().getVideo(source: ImageSource.gallery);

                    final tempDir = await getTemporaryDirectory();

                    await screenshotController
                        .captureAndSave(tempDir.path)
                        .then((imagePath) async {
                      SocialShare.shareInstagramStoryWithSticker(
                        stickerPath: imagePath!,
                        backgroundTopColor: "#ffffff",
                        backgroundBottomColor: "#000000",
                        attributionURL: "https://deep-link-url",
                        mediaPath: file!.path,
                        mediaType: ShareMediaType.video,
                      ).then((data) {
                        print(data);
                      });
                    });
                  },
                  child: Text("Share On Instagram Story video with sticker"),
                ),
                RaisedButton(
                  onPressed: () async {
                    final tempDir = await getTemporaryDirectory();
                    await screenshotController
                        .captureAndSave(tempDir.path)
                        .then((imagePath) async {
                      //facebook appId is mandatory for andorid or else share won't work
                      Platform.isAndroid
                          ? SocialShare.shareFacebookStory(
                                  imagePath!, "#ffffff", "#000000", "https://google.com",
                                  appId: "xxxxxxxxxxxxx")
                              .then((data) {
                              print(data);
                            })
                          : SocialShare.shareFacebookStory(
                                  imagePath!, "#ffffff", "#000000", "https://google.com")
                              .then((data) {
                              print(data);
                            });
                    });
                  },
                  child: Text("Share On Facebook Story"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.copyToClipboard(
                      "This is Social Share plugin",
                    ).then((data) {
                      print(data);
                    });
                  },
                  child: Text("Copy to clipboard"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.shareTwitter("This is Social Share twitter example",
                            hashtags: ["hello", "world", "foo", "bar"],
                            url: "https://google.com/#/hello",
                            trailingText: "\nhello")
                        .then((data) {
                      print(data);
                    });
                  },
                  child: Text("Share on twitter"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.shareSms("This is Social Share Sms example",
                            url: "\nhttps://google.com/", trailingText: "\nhello")
                        .then((data) {
                      print(data);
                    });
                  },
                  child: Text("Share on Sms"),
                ),
                RaisedButton(
                  onPressed: () async {
                    final tempDir = await getTemporaryDirectory();
                    await screenshotController
                        .captureAndSave(tempDir.path)
                        .then((imagePath) async {
                      SocialShare.shareOptions(
                        'hello world',
                        imagePath: imagePath!,
                      ).then((data) {
                        print(data);
                      });
                    });
                  },
                  child: Text("Share Options"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.shareWhatsapp("Hello World \n https://google.com")
                        .then((data) {
                      print(data);
                    });
                  },
                  child: Text("Share on Whatsapp"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.shareTelegram("Hello World \n https://google.com")
                        .then((data) {
                      print(data);
                    });
                  },
                  child: Text("Share on Telegram"),
                ),
                RaisedButton(
                  onPressed: () async {
                    SocialShare.checkInstalledAppsForShare().then((data) {
                      print(data.toString());
                    });
                  },
                  child: Text("Get all Apps"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
