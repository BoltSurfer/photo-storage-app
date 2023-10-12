import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'bottomappbar.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Open route'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecondRoute()),
            );
          },
        ),
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String> receiptData = {}; // Map to hold receipt data

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<String?> _loadSingleData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
    // Removed the irrelevant lines from this function.
  }
  Future<void> _displayTextInputDialog(BuildContext context, String key) async {

    return showDialog(
        context: context,
        builder: (context) {
          TextEditingController customController = TextEditingController();
          return AlertDialog(
            title: Text('Enter details for Receipt'),
            content: TextField(
              controller: customController,
              decoration: InputDecoration(hintText: "Enter your text here"),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.red),
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white
                ),
                child: Text('OK'),
                onPressed: () {
                  String key = 'WhatIsThis'; // Replace 'SomeKey' with the appropriate key for this receipt
                  _saveData(key, customController.text);
                  print(customController.text.toString());
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < 20; i++) {
        receiptData['Receipt ${i + 1}'] =
            prefs.getString('Receipt ${i + 1}') ?? '';
      }
    });
  }

  _saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value); // SORT!!!
  }

  /*_showDialog(String key) async {
    TextEditingController customController = TextEditingController();
    customController.text = receiptData[key] ?? '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(key),
          content: TextField(
            controller: customController,
          ),
          actions: [
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  receiptData[key] = customController.text;
                });
                _saveData(key, customController.text);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }*/

    @override
    Widget build(BuildContext context) {
      var screenHeight = MediaQuery
          .of(context)
          .size
          .height;

      return Scaffold(
        appBar: AppBar(
          title: const Text('GoTally MVP Alpha'),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Pinned Receipts',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: screenHeight / 5,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 160.0,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    15.0), // Adjust as needed
                              ),
                              child: Center(
                                child: Text('Pinned Receipt ${index + 1}'),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'assets/gotally_logo_no_text_colours.png', width: 150.0,
                    height: 150.0,),
                ]
            ),
            Align(
              alignment: const Alignment(0, -.08),
              child: FloatingActionButton(
                onPressed: () /*async*/ {
                  /*
                final cameras = await availableCameras();
                final firstCamera = cameras.first;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TakePictureScreen(camera: firstCamera)),
                );
              */
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.camera),
              ),
            ),
            const Align(
              alignment: Alignment(0, -0.23),
              child: Text(
                'Click to Scan',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Align(
                alignment: Alignment(0, 0.15),
                child: Text('All Receipts',
                  style: TextStyle(fontSize: 24),)
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 1.65 * screenHeight / 5, // height 2/5 of the screen
                child: ListView.separated(
                    itemCount: 20,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Receipt ${index + 1}'),
                        onTap: () {
                          _displayTextInputDialog(context, 'Receipt ${index + 1}');
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    }
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const DemoBottomAppBar(
            isElevated: true, isVisible: true),
      );
    }
  }




