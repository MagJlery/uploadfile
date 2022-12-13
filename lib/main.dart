// import 'package:file_picker/file_picker.dart';
import 'dart:html';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'מגנוליה',
      theme: ThemeData(
      primaryColor:Color.fromARGB(255, 157, 123, 144),
      fontFamily:'Rubik'
       // primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  void sendSalesmanLists() async {
    Uri url =
        Uri.https("api.magnolia.co.il", "/NilyRestApi/api/Salesman/SendList");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      Text('המייל נשלח בהצלחה!');
    }
    print(response);
  }

//פונקציה שנותנת אופציה לבחור קובץ
  void openFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: "קובץ אקסל",
    );
    if (result != null) {
      //לשנות לניתוב של השרת ולא למקומי
             //https://api.magnolia.co.il/NilyRestApi/api/ExtraSalesMan/upload
     var url= "https://api.magnolia.co.il/NilyRestApi/api/ExtraSalesMan/upload";
    // var url = 'https://localhost:7227/api/ExtraSalesMan/upload';

      var request = http.MultipartRequest("POST", Uri.parse(url));
      PlatformFile file = result.files.first;
      List<int> fileBytes = result.files.first.bytes as List<int>;
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: file.name,
        ),
      );
      request.headers.addAll(
        {
          'Content-Type': 'application/json',
        },
      );

      try {
        var streamedResponse = await request.send();
        var result2 = await http.Response.fromStream(streamedResponse);
        var value = (result2.body);
      } catch (e) {
        //print(e);
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("מגנוליה שרותים לאקסטרה",textAlign: TextAlign.center)
        ,centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('assets/logo.png', width: 300,),
              Image.asset('assets/extraLogo.png', width: 300,),
            ],
          ),

          const Text('ברוכה הבאה למגנוליה',style:TextStyle(fontSize: 25),),
          Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                const SizedBox(height: 30),
                FloatingActionButton.extended(
                  onPressed: () {
                    sendSalesmanLists();
                  },
                  label: const Text('בקשה לקבלת רשימת עובדי מגנוליה במייל'),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 30),
                FloatingActionButton.extended(
                  onPressed: () {
                    openFile();
                  },
                  label: const Text('העלאת קובץ עובדי חברת אקסטרה'),
                  backgroundColor: Theme.of(context).primaryColor,
                //  backgroundColor: Color.fromARGB(255, 157, 123, 144),
                  //(255, 207, 191, 198)
                  //157, 123, 144
                ),
              ])),
        ],
      ),
    );
  }
}
