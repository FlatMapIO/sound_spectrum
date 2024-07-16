library sound_spectrum;

import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'dart:math' as math;

class AudioVisualizerPainter extends CustomPainter {
  final AudioData audioData;
  final double noiseThreshold;
  final int frequencyBands;
  final double minAmplitude;
  final double bandWidthFactor;
  final double maxAmplitudeFactor;

  AudioVisualizerPainter({
    required this.audioData,
    this.noiseThreshold = 0.01,
    this.frequencyBands = 32,
    this.minAmplitude = 8.0,
    this.bandWidthFactor = 0.5,
    this.maxAmplitudeFactor = 0.8,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final bandWidth = size.width / frequencyBands;
    final maxAmplitude = size.height * maxAmplitudeFactor;

    for (int i = 0; i < frequencyBands; i++) {
      // 反转索引，高频在中间
      int reversedIndex = frequencyBands ~/ 2 - (i - frequencyBands ~/ 2).abs();
      var sample = audioData
          .getLinearFft(SampleLinear(reversedIndex * 256 ~/ frequencyBands));

      sample = sample < noiseThreshold
          ? 0
          : (sample - noiseThreshold) / (1 - noiseThreshold);

      ///             ┌┐
      ///          ┌┐ ││ ┌┐
      /// ┌┐ ┌┐ ┌┐ ││ ││ ││ ┌┐ ┌┐ ┌┐
      /// └┘ └┘ └┘ ││ ││ ││ └┘ └┘ └┘
      ///          └┘ ││ └┘
      ///             └┘
      double gaussianMultiplier =
          math.exp(-math.pow(2 * i / frequencyBands - 1, 2) / 0.2);
      sample *= gaussianMultiplier;

      final barHeight = minAmplitude + (maxAmplitude - minAmplitude) * sample;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          i * bandWidth,
          (size.height - barHeight) / 2, // 居中对齐
          bandWidth * bandWidthFactor,
          barHeight,
        ),
        Radius.circular(bandWidth * 0.4),
      );

      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
