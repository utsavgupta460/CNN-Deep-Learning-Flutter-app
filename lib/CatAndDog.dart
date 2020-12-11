import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class CatAndDog extends StatefulWidget {
  @override
  _CatAndDogState createState() => _CatAndDogState();
}

class _CatAndDogState extends State<CatAndDog> {
  bool _loading = true;
  File _image;
  List _output;
  var val_per;
  String str;
  final picker = ImagePicker();

@override
  void initState(){
   super.initState();
   loadModel();
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        threshold: 0.2,
        imageMean: 0.0,
        imageStd: 225.0);
    setState(() {
      _output=output;
      var val_per=_output[0]['confidence'];
     str=val_per.toString().substring(2,4);
      _loading=false;
    });
  }
  loadModel()async{
    await Tflite.loadModel(model: 'assets/model.tflite',labels: 'assets/labels.txt',numThreads: 1,useGpuDelegate: false,isAsset: true);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
  pickImage()async{
  var image=await picker.getImage(source: ImageSource.camera);
  if(image==null)
    {
      return null;
    }
  setState(() {
    _image=File(image.path);_loading=false;
    _loading=false;
   classifyImage(_image);
  });

  }
  pickGalleryImage()async{
    var image=await picker.getImage(source: ImageSource.gallery);
    if(image==null)
    {
      return null;
    }
    setState(() {
      _image=File(image.path);
      classifyImage(_image);
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "CNN Model Deep Learning",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            // fontFamily: 'Pacifico',
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                'Cat & Dog Classification',
                style: TextStyle(
                    fontFamily: 'Pacifico', color: Colors.blue, fontSize: 30),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: _loading
                  ? Container(
                      child: Column(
                        children: <Widget>[
                          Image(
                            image: AssetImage('images/cat and dog.jpg'),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    )
                  : Container(
                      child: Column(children: <Widget>[
                      Container(
                        height: 250,
                        child: Image.file(_image),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _output != null ? Text('${_output[0]['label']}  ${str}% ',style: TextStyle(color: Colors.blue,fontSize: 20),) : Container(),
                    ])),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    iconSize: 40,
                    icon: Icon(Icons.camera_alt),
                    color: Colors.white,
                    onPressed: pickImage,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    iconSize: 40,
                    icon: Icon(Icons.photo),
                    color: Colors.white,
                    onPressed: pickGalleryImage,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
