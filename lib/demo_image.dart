import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class DemoML extends StatefulWidget {
  const DemoML({Key? key}) : super(key: key);

  //const Demo_Ml({ Key? key }) : super(key: key);

  @override
  State<DemoML> createState() => _DemoMLState();
}

class _DemoMLState extends State<DemoML> {
  bool textScanning = false;
  XFile? imageFile;
  String scannedText = "";

  pickImageFromGallery() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          imageFile = pickedImage;
        });
        getRecognisedText(imageFile!);
      }
    } catch (e) {
      setState(() {
        textScanning = false;
        imageFile = null;
        scannedText = "Error occurred while scanning";
      });
    }
  }

  pickImageFromCamera() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        setState(() {
          imageFile = pickedImage;
        });
        getRecognisedText(imageFile!);
      }
    } catch (e) {
      setState(() {
        textScanning = false;
        imageFile = null;
        scannedText = "Error occurred while scanning";
      });
    }
  }

  getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = TextRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    // await textDetector.close();
    var resultText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        // for (TextElement element in line.elements) {
        //   resultText += element.text + " ";
        // }
        resultText += line.text + "\n";
      }
      // resultText += "\n";
    }
    setState(() {
      textScanning = false;
      scannedText = resultText;
    });
    print(scannedText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          !textScanning && imageFile != null
              ? SizedBox(
                  height: 300,
                  child: Image.file(File(imageFile!.path)),
                )
              : textScanning
                  ? Container(
                      color: Colors.white,
                      alignment: Alignment.center,
                      height: 300,
                      child: const CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      height: 300,
                      color: Colors.grey[200],
                      child: const Text("No Image")),
          const SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF0170d0))),
              child: ElevatedButton(
                onPressed: () {
                  pickImageFromGallery();
                  setState(() {
                    textScanning = true;
                  });
                },
                child: const Text(
                  "Gallery",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                style: ElevatedButton.styleFrom(
                    primary: const Color(0xFF0170d0),
                    //  primary: Color(0xFF0170d0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            ),
            const SizedBox(width: 5),
            Container(
              width: 100,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.purple)),
              child: ElevatedButton(
                onPressed: () {
                  pickImageFromCamera();
                  setState(() {
                    textScanning = true;
                  });
                },
                child: const Text(
                  "Camera",
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.purple,
                    //  primary: Color(0xFF0170d0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
            )
          ]),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(scannedText))
        ],
      ),
    )));
  }
}
