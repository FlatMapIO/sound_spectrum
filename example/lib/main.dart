import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:sound_spectrum/sound_spectrum.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize the player
  await SoLoud.instance.init().then(
    (_) {
      debugPrint('player started');
      SoLoud.instance.setVisualizationEnabled(true);
      SoLoud.instance.setGlobalVolume(1);
      SoLoud.instance.setMaxActiveVoiceCount(32);
    },
    onError: (Object e) {
      debugPrint('player starting error: $e');
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Visualizer Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const SoundSpectrumDemo(),
    );
  }
}

class SoundSpectrumDemo extends StatefulWidget {
  const SoundSpectrumDemo({super.key});

  @override
  State<SoundSpectrumDemo> createState() => _SoundSpectrumDemoState();
}

class _SoundSpectrumDemoState extends State<SoundSpectrumDemo>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late AudioData _audioData;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _audioData = AudioData(GetSamplesFrom.microphone, GetSamplesKind.linear);
    _ticker = createTicker(_onTick);
    _startCapture();
  }

  void _onTick(Duration elapsed) {
    if (_isRecording) {
      setState(() {
        _audioData.updateSamples();
      });
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _audioData.dispose();
    _stopCapture();
    super.dispose();
  }

  void _startCapture() async {
    var status = await Permission.microphone.status;
    debugPrint('Current microphone permission status: $status');
    status = await Permission.microphone.request();
    debugPrint('Microphone permission status after request: $status');
    if (status != PermissionStatus.granted) {
      debugPrint('Microphone permission not granted');
      return;
    }
    if (!_isRecording) {
      debugPrint('Initializing capture');
      final initResult = SoLoudCapture.instance.init();
      debugPrint('Capture init result: $initResult');
      if (initResult == CaptureErrors.captureNoError) {
        debugPrint('Starting capture');
        final startResult = SoLoudCapture.instance.startCapture();
        debugPrint('Capture start result: $startResult');
        if (startResult == CaptureErrors.captureNoError) {
          setState(() {
            _isRecording = true;
            _ticker.start();
          });
          debugPrint('Recording started');
        } else {
          debugPrint('Failed to start capture: $startResult');
        }
      } else {
        debugPrint('Failed to initialize capture: $initResult');
      }
    }
  }

  void _stopCapture() {
    if (_isRecording) {
      SoLoudCapture.instance.stopCapture();
      setState(() {
        _isRecording = false;
        _ticker.stop();
      });
    }
  }

  void _toggleRecording() {
    if (_isRecording) {
      _stopCapture();
    } else {
      _startCapture();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Visualizer Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 150,
              child: CustomPaint(
                painter: AudioVisualizerPainter(
                  audioData: _audioData,
                  frequencyBands: 32,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleRecording,
              child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
          ],
        ),
      ),
    );
  }
}
