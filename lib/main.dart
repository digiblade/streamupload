import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File video;
  String response = "";
  int flag = 0;
  ImagePicker img = new ImagePicker();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(response),
                RaisedButton(
                  onPressed: () async {
                    await pickVideo();
                    startUpload();
                  },
                  child: Text("Upload Video"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickVideo() async {
    dynamic videoData = await img.getVideo(source: ImageSource.gallery);
    setState(() {
      video = File(videoData.path);
    });
  }

  uploadData(String fileName, File file) async {
    Dio dio = new Dio();
    dynamic base64Image = base64Encode(file.readAsBytesSync());
    dynamic responseData = await dio.post(
      "https://digiblade.in/upload/video.php",
      data: {
        "image": base64Image,
        "name": fileName,
      },
      onSendProgress: (int sent, int total) {
        setStatus(
            "send:" + sent.toString() + "% total:" + total.toString() + "%");
      },
    );
    if (responseData.statusCode == 200) {
      setStatus("Done");
    } else {
      setStatus("Something went wrong");
    }
  }

  void startUpload() {
    setStatus('Uploading Image...');
    setState(() {
      flag = 1;
    });
    if (null == video) {
      print("::1");
      setStatus("errMessage");
      return;
    }
    String fileName = video.path.split('/').last;
    print("path :::: " + video.toString());
    uploadData(fileName, video);
  }

  setStatus(String s) {
    setState(() {
      response = s;
    });
  }
}
