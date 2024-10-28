import 'dart:math';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter_application/models/heart_rate.dart';
import 'package:flutter_application/utils/db_helper.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'history_view.dart';
import '../components/chart.dart';
import '../models/sensor.dart';

class HeartPage extends StatefulWidget {
  const HeartPage({super.key});

  @override
  State<HeartPage> createState() => _HeartPageState();
}

class _HeartPageState extends State<HeartPage> {
  bool _toggled = false;
  CameraController? _controller;

  final List<HeartRateRecord> _history = [];

  final List<SensorValue> _data = <SensorValue>[];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.low,
        enableAudio: false
      );
      await _controller?.initialize();
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _toggleFlash(bool status) async {
    if (_controller != null) {
      await _controller!.setFlashMode(
        status ? FlashMode.torch : FlashMode.off,
      );
    }
  }

  void _startMeasurement() async {
    _toggleFlash(true);
    _data.clear();
    await Future.delayed(const Duration(seconds: 1));
    _controller?.startImageStream(_processImage);
    //Stop Measure after 15 seconds
    _measurementLoop();
  }
  
  void _stopMeasurement() async {
    await _controller?.stopImageStream();
    _toggleFlash(false);
    _calculateHeartRate();
  }

  void _processImage(CameraImage image) {
    final now = DateTime.now();
    double avgRedValue = _calculateAverageRed(image);
    setState(() {
      _data.add(SensorValue(time: now, value: avgRedValue));
    });
  }

  double _calculateAverageRed(CameraImage image) {
    // For BGRA8888 format
    double sumRed = 0;
    int count = 0;
    final bytes = image.planes[0].bytes;

    for (int i = 0; i < bytes.length; i += 4 * 10) {
      final int r = bytes[i + 2]; // Red channel in BGRA8888
      sumRed += r;
      count++;
    }

    if (count == 0) return 0;

    return sumRed / count;
  }

  void _calculateHeartRate() {
  if (_data.isEmpty) {
    _showSnackBar('Error', "No Data Was Collected", ContentType.failure);
    return;
  }

  final durationInSeconds = _data.last.time.difference(_data.first.time).inSeconds;
  if (durationInSeconds == 0) {
    _showSnackBar('Warning', "Measurement Was Too Short", ContentType.warning);
    return;
  }

  double thresholdValue = _data.map((e) => e.value).reduce(max) * 0.8;
  int beats = 0;
  for (int i = 1; i < _data.length - 1; i++) {
    if (_data[i].value > _data[i - 1].value &&
        _data[i].value > _data[i + 1].value &&
        _data[i].value > thresholdValue) {
      beats++;
    }
  }

  final bpm = ((beats / durationInSeconds) * 60).toInt();

  if (bpm > 0) {
    final record = HeartRateRecord(
      bpm: bpm,
      dateTime: DateTime.now(),
      dataPoints: List<SensorValue>.from(_data),
    );

    List<Map<String, dynamic>> dataPointsAsMap = record.dataPoints.map((sensorValue) {
      return {
        'time': sensorValue.time.toIso8601String(),
        'value': sensorValue.value,
      };
    }).toList();
    DatabaseHelper().insertHeartRate(record.bpm, record.dateTime, dataPointsAsMap);
    setState(() {
      _history.add(record);
    });

    _showSnackBar('Success', "Heart Beat Rate: $bpm", ContentType.success);
  } else {
    _showSnackBar('Error', "Failed to calculate BPM", ContentType.failure);
  }
}

void _showSnackBar(String title, String message, ContentType contentType) {
  final snackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    duration: Duration(seconds: 2),
    content: AwesomeSnackbarContent(
      title: title,
      message: message,
      contentType: contentType,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
      appBar: AppBar(
      backgroundColor: const Color.fromRGBO(239, 235, 206, 1),
      title: const Text('Heart Rate Monitor', style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold
      ),),
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryPage(
                  history: _history,
                  onDelete: (index) {
                  setState(() {
                    //
                  });
                  }, 
                  ),
              ),
            );
          },
        ),
      ],
    ),
      body: Stack(
        children: [
          _controller != null && _controller!.value.isInitialized && _toggled
              ? AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: CameraPreview(_controller!),
                )
              : const SizedBox(),
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 90,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Heart Beat Rate',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                _toggled
                                    ? "Cover the camera and the flash with your finger"
                                    : "Camera feed will be displayed here\nCover the camera and the flash with your finger",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )

                      ],
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: size.height * .25,
                      minWidth: size.height * .25,
                    ),
                    margin: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (!_toggled) {
                            _toggled = true;
                            _startMeasurement();
                          } else {
                            //print(_toggled);
                            _toggled = false;
                             _stopMeasurement();
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color.fromRGBO(239, 235, 206, 1),
                        backgroundColor: const Color.fromRGBO(249, 110, 70, 1),
                        elevation: 6,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(20.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _toggled 
                                ? 'Measuring...'
                                : 'Tap here to start',
                            style: const TextStyle(
                              fontSize: 17,
                              color:  Color.fromRGBO(239, 235, 206, 1),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Raleway',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Icon(
                            Icons.favorite_outlined,
                            color:  Color.fromRGBO(239, 235, 206, 1),
                            size: 64,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Expanded(
                  child: _toggled && _data.isNotEmpty
                      ? ChartComp(allData: _data)
                      : const Center(
                          child: Text('Press start to measure your heart rate'),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
 Future<void> _measurementLoop() async {
  const int duration = 15; // Measurement Duration
  for (int i = 0; i < duration; i++) {
    if (!_toggled) {
      break; 
    }
    await Future.delayed(const Duration(seconds: 1)); 
  }

  if (_toggled) {
    setState(() {
      _toggled = false;
    });
     
    _stopMeasurement(); 
    if (_history.isNotEmpty) {
      final lastRecord = _history.last;
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 4),
        content: AwesomeSnackbarContent(
          title: 'Success',
          message: "Heart Beat Rate: ${lastRecord.bpm}",
          contentType: ContentType.success,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

}


