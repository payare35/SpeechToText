import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,

        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  void listen() async {
    
    
    if (!isListening) {
      
      bool available = await _speechToText.initialize(
          onError: (val) => print("Error: $val"),
          onStatus: (val) => print("Status: $val"));

      if (available) {
        
        setState(() {
          isListening = true;
        });
        _speechToText.listen(onResult: (val) {
          setState(() {
            text = val.recognizedWords;
          });
          if (val.hasConfidenceRating && val.confidence > 0) {
            setState(() {
              confidence = val.confidence;
            });
          }
        });
      }
    } else {
      setState(() {
        isListening = false;
      });
      _speechToText.stop();
    }
  }

  
  stt.SpeechToText _speechToText;
  bool isListening = false;
  String text = "Press the button and Start Speaking";
  double confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confidence: ${(confidence * 100.0).toStringAsFixed(1)}%"),
        centerTitle: true,
      ),
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
            child: isListening ? Icon(Icons.mic) : Icon(Icons.mic_none),
            onPressed: listen),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
            padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
            child: Text(
              text,
              style:GoogleFonts.quicksand(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 25.0
              ) ,
            ),
            ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
