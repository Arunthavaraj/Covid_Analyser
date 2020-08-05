import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text(
                'Covid Analyser',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.userNurse),
                  onPressed: () {},
                ),
              ],
              elevation: 0,
              backgroundColor: Color(0xFF1b1e44),
              brightness: Brightness.dark,
              textTheme: TextTheme(
                title: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
            body: Center(child: MyImagePicker())));
  }
}

class MyImagePicker extends StatefulWidget {
  @override
  MyImagePickerState createState() => MyImagePickerState();
}

class MyImagePickerState extends State {
  File imageURI;
  String result;
  String path;

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imageURI = image;
      path = image.path;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageURI = image;
      path = image.path;
    });
  }

  Future classifyImage() async {
    await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
    var output = await Tflite.runModelOnImage(path: path);

    setState(() {
      result = output.toString();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              imageURI == null
                  ? Text('No image selected.',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ))
                  : Image.file(imageURI,
                      width: 300, height: 200, fit: BoxFit.cover),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                  child: RaisedButton.icon(
                    onPressed: () => getImageFromCamera(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    label: Text('Click Here To Select Image From Camera'),
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                    textColor: Colors.white,
                    color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                    elevation: 5.0,
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: RaisedButton.icon(
                    onPressed: () => getImageFromGallery(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    label: Text('Click Here To Select Image From Gallery'),
                    icon: Icon(
                      Icons.image,
                      color: Colors.white,
                    ),
                    textColor: Colors.white,
                    color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
                  child: RaisedButton.icon(
                    onPressed: () => classifyImage(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    label: Text('Classify Image'),
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    textColor: Colors.white,
                    color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                  )),
              result == null ? Text('Result') : Text(result)
            ])));
  }
}
