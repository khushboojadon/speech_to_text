// // import 'package:flutter/material.dart';
// // import 'dart:async';
// // import 'package:speech_to_text/speech_to_text.dart';
// // import 'package:speech_to_text/speech_recognition_result.dart';
// // import 'package:speech_to_text/speech_recognition_error.dart';

// // void main() => runApp(MyApp());

// // class MyApp extends StatefulWidget {
// //   @override
// //   _MyAppState createState() => _MyAppState();
// // }

// // class _MyAppState extends State<MyApp> {
// //   bool _hasSpeech = false;
// //   String lastWords = "Reply";
// //   String lastError = "";
// //   String lastStatus = "";
// //   final SpeechToText speech = SpeechToText();

// //   @override
// //   void initState() {
// //     super.initState();
// //     initSpeechState();
// //   }

// //   Future<void> initSpeechState() async {
// //     bool hasSpeech = await speech.initialize(
// //         onError: errorListener, onStatus: statusListener);

// //     if (!mounted) return;
// //     setState(() {
// //       _hasSpeech = hasSpeech;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: Scaffold(
// //           appBar: AppBar(
// //             title: const Text('Speech to Text Example'),
// //           ),
// //           body: Column(children: [
// //             Expanded(
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: <Widget>[
// //                   Center(
// //                     child: IconButton(
// //                       icon: Icon(Icons.mic),
// //                       onPressed: startListening,
// //                     ),
// //                   ),
// //                   Center(
// //                     child: IconButton(
// //                       icon: Icon(Icons.cancel),
// //                       onPressed: cancelListening,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             Expanded(
// //               child: Column(
// //                 children: <Widget>[
// //                   Center(
// //                     child: Text(lastWords),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ])),
// //     );
// //   }

// //   void startListening() {
// //     lastWords = "";
// //     lastError = "";
// //     speech.listen(onResult: resultListener);
// //     setState(() {});
// //   }

// //   void stopListening() {
// //     speech.stop();
// //     setState(() {});
// //   }

// //   void cancelListening() {
// //     speech.cancel();
// //     setState(() {
// //       lastWords = '';
// //     });
// //   }

// //   void resultListener(SpeechRecognitionResult result) {
// //     setState(() {
// //       lastWords = "${result.recognizedWords}";
// //     });
// //   }

// //   void errorListener(SpeechRecognitionError error) {
// //     setState(() {
// //       lastError = "${error.errorMsg} - ${error.permanent}";
// //     });
// //   }

// //   void statusListener(String status) {
// //     setState(() {
// //       lastStatus = "$status";
// //     });
// //   }
// // }
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// enum TtsState { playing, stopped }

// class _MyAppState extends State<MyApp> {
//   FlutterTts flutterTts;
//   dynamic languages;
//   String language;
//   double volume = 0.5;
//   double pitch = 1.0;
//   double rate = 0.5;

//   String _newVoiceText;

//   TtsState ttsState = TtsState.stopped;

//   get isPlaying => ttsState == TtsState.playing;

//   get isStopped => ttsState == TtsState.stopped;

//   @override
//   initState() {
//     super.initState();
//     initTts();
//   }

//   initTts() {
//     flutterTts = FlutterTts();

//     _getLanguages();

//     flutterTts.setStartHandler(() {
//       setState(() {
//         print("playing");
//         ttsState = TtsState.playing;
//       });
//     });

//     flutterTts.setCompletionHandler(() {
//       setState(() {
//         print("Complete");
//         ttsState = TtsState.stopped;
//       });
//     });

//     flutterTts.setErrorHandler((msg) {
//       setState(() {
//         print("error: $msg");
//         ttsState = TtsState.stopped;
//       });
//     });
//   }

//   Future _getLanguages() async {
//     languages = await flutterTts.getLanguages;
//     if (languages != null) setState(() => languages);
//   }

//   Future _speak() async {
//     await flutterTts.setVolume(volume);
//     await flutterTts.setSpeechRate(rate);
//     await flutterTts.setPitch(pitch);

//     if (_newVoiceText != null) {
//       if (_newVoiceText.isNotEmpty) {
//         var result = await flutterTts.speak(_newVoiceText);
//         if (result == 1) setState(() => ttsState = TtsState.playing);
//       }
//     }
//   }

//   Future _stop() async {
//     var result = await flutterTts.stop();
//     if (result == 1) setState(() => ttsState = TtsState.stopped);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     flutterTts.stop();
//   }

//   List<DropdownMenuItem<String>> getLanguageDropDownMenuItems() {
//     var items = List<DropdownMenuItem<String>>();
//     for (String type in languages) {
//       items.add(DropdownMenuItem(value: type, child: Text(type)));
//     }
//     return items;
//   }

//   void changedLanguageDropDownItem(String selectedType) {
//     setState(() {
//       language = selectedType;
//       flutterTts.setLanguage(language);
//     });
//   }

//   void _onChange(String text) {
//     setState(() {
//       _newVoiceText = text;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//             appBar: AppBar(
//               title: Text('Flutter TTS'),
//             ),
//             body: SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Column(children: [
//                   _inputSection(),
//                   _btnSection(),
//                   languages != null ? _languageDropDownSection() : Text(""),
//                   _buildSliders()
//                 ]))));
//   }

//   Widget _inputSection() => Container(
//       alignment: Alignment.topCenter,
//       padding: EdgeInsets.only(top: 25.0, left: 25.0, right: 25.0),
//       child: TextField(
//         onChanged: (String value) {
//           _onChange(value);
//         },
//       ));

//   Widget _btnSection() => Container(
//       padding: EdgeInsets.only(top: 50.0),
//       child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//         _buildButtonColumn(
//             Colors.green, Colors.greenAccent, Icons.play_arrow, 'PLAY', _speak),
//         _buildButtonColumn(
//             Colors.red, Colors.redAccent, Icons.stop, 'STOP', _stop)
//       ]));

//   Widget _languageDropDownSection() => Container(
//       padding: EdgeInsets.only(top: 50.0),
//       child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         DropdownButton(
//           value: language,
//           items: getLanguageDropDownMenuItems(),
//           onChanged: changedLanguageDropDownItem,
//         )
//       ]));

//   Column _buildButtonColumn(Color color, Color splashColor, IconData icon,
//       String label, Function func) {
//     return Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           IconButton(
//               icon: Icon(icon),
//               color: color,
//               splashColor: splashColor,
//               onPressed: () => func()),
//           Container(
//               margin: const EdgeInsets.only(top: 8.0),
//               child: Text(label,
//                   style: TextStyle(
//                       fontSize: 12.0,
//                       fontWeight: FontWeight.w400,
//                       color: color)))
//         ]);
//   }

//   Widget _buildSliders() {
//     return Column(
//       children: [_volume(), _pitch(), _rate()],
//     );
//   }

//   Widget _volume() {
//     return Slider(
//         value: volume,
//         onChanged: (newVolume) {
//           setState(() => volume = newVolume);
//         },
//         min: 0.0,
//         max: 1.0,
//         divisions: 10,
//         label: "Volume: $volume");
//   }

//   Widget _pitch() {
//     return Slider(
//       value: pitch,
//       onChanged: (newPitch) {
//         setState(() => pitch = newPitch);
//       },
//       min: 0.5,
//       max: 2.0,
//       divisions: 15,
//       label: "Pitch: $pitch",
//       activeColor: Colors.red,
//     );
//   }

//   Widget _rate() {
//     return Slider(
//       value: rate,
//       onChanged: (newRate) {
//         setState(() => rate = newRate);
//       },
//       min: 0.0,
//       max: 1.0,
//       divisions: 10,
//       label: "Rate: $rate",
//       activeColor: Colors.green,
//     );
//   }
// }
  
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medcorder_audio/medcorder_audio.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MedcorderAudio audioModule = new MedcorderAudio();
  bool canRecord = false;
  double recordPower = 0.0;
  double recordPosition = 0.0;
  bool isRecord = false;
  bool isPlay = false;
  double playPosition = 0.0;
  String file = "";

  @override
  initState() {
    super.initState();
    audioModule.setCallBack((dynamic data) {
      _onEvent(data);
    });
    _initSettings();
  }

  Future _initSettings() async {
    final String result = await audioModule.checkMicrophonePermissions();
    if (result == 'OK') {
      await audioModule.setAudioSettings();
      setState(() {
        canRecord = true;
      });
    }
    return;
  }

  Future _startRecord() async {
    try {
      DateTime time = new DateTime.now();
      setState(() {
        file = time.millisecondsSinceEpoch.toString();
      });
      final String result = await audioModule.startRecord(file);
      setState(() {
        isRecord = true;
      });
      print('startRecord: ' + result);
    } catch (e) {
      file = "";
      print('startRecord: fail');
    }
  }

  Future _stopRecord() async {
    try {
      final String result = await audioModule.stopRecord();
      print('stopRecord: ' + result);
      setState(() {
        isRecord = false;
      });
    } catch (e) {
      print('stopRecord: fail');
      setState(() {
        isRecord = false;
      });
    }
  }

  Future _startStopPlay() async {
    if (isPlay) {
      await audioModule.stopPlay();
    } else {
      await audioModule.startPlay({
        "file": file,
        "position": 0.0,
      });
    }
  }

  void _onEvent(dynamic event) {
    if (event['code'] == 'recording') {
      double power = event['peakPowerForChannel'];
      setState(() {
        recordPower = (60.0 - power.abs().floor()).abs();
        recordPosition = event['currentTime'];
      });
    }
    if (event['code'] == 'playing') {
      String url = event['url'];
      setState(() {
        playPosition = event['currentTime'];
        isPlay = true;
      });
    }
    if (event['code'] == 'audioPlayerDidFinishPlaying') {
      setState(() {
        playPosition = 0.0;
        isPlay = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Audio example app'),
        ),
        body: new Center(
          child: canRecord
              ? new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new InkWell(
                      child: new Container(
                        alignment: FractionalOffset.center,
                        child: new Text(isRecord ? 'Stop' : 'Record'),
                        height: 40.0,
                        width: 200.0,
                        color: Colors.blue,
                      ),
                      onTap: () {
                        if (isRecord) {
                          _stopRecord();
                        } else {
                          _startRecord();
                        }
                      },
                    ),
                    new Text('recording: ' + recordPosition.toString()),
                    new Text('power: ' + recordPower.toString()),
                    new InkWell(
                      child: new Container(
                        margin: new EdgeInsets.only(top: 40.0),
                        alignment: FractionalOffset.center,
                        child: new Text(isPlay ? 'Stop' : 'Play'),
                        height: 40.0,
                        width: 200.0,
                        color: Colors.blue,
                      ),
                      onTap: () {
                        if (!isRecord && file.length > 0) {
                          _startStopPlay();
                        }
                      },
                    ),
                    new Text('playing: ' + playPosition.toString()),
                  ],
                )
              : new Text(
                  'Microphone Access Disabled.\nYou can enable access in Settings',
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }
}