import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Image upload to server'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? selectImage;
  String? message = "";
  String url = "https://hoctaptlus.xyz/detectObject";
  String bankName = '';
  String bankNumber = '';
  String userName = '';
  //String url = "http://192.168.1.11:5000/detectObject";
  uploadImage() async {
    bankName = '';
    bankNumber = '';
    userName = '';
    final resquest = http.MultipartRequest("POST", Uri.parse(url));

    final headers = {"Content-type": "multipart/"};

    resquest.files.add(http.MultipartFile('image',
        selectImage!.readAsBytes().asStream(), selectImage!.lengthSync(),
        filename: selectImage!.path.split("/").last));

    resquest.headers.addAll(headers);
    final response = await resquest.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    bankName = resJson['data']['string_bankName'];
    bankNumber = resJson['data']['string_bankNumber'];
    userName = resJson['data']['string_userName'];
    // ignore: avoid_print
    print(resJson['data']['string_bankName']);

    setState(() {});
  }

  Future getImage() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    selectImage = File(pickedImage!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              ' $bankName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              ' $bankNumber',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              ' $userName',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            selectImage == null
                ? const Text("Please pick image to upload")
                : Image.file(selectImage!),
            TextButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                onPressed: uploadImage,
                icon: const Icon(
                  Icons.upload_file,
                  color: Colors.white,
                ),
                label: const Text(
                  "Upload",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
