# sound_spectrum


**WARN: flutter_soloud [removes audio capture completely](https://github.com/alnitak/flutter_soloud/pull/106), so this library will not work properly.**

A Flutter package for visualizing audio data in a customizable and interactive way.

**Current Status**: This package is not yet published on pub.dev. The reason for this is that `sound_spectrum` currently depends on the `flutter_soloud` package, which is only available as a Git source. We plan to publish `sound_spectrum` on pub.dev once `flutter_soloud` is officially released.


## Features

- Visualize audio data with customizable bar graphs.
- Configurable parameters for noise threshold, band count, and more.
- Example application to demonstrate usage.


https://github.com/user-attachments/assets/bafae32e-0ba0-4b61-9f4c-d34ef624f8c0



## Getting Started

Add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  sound_spectrum:
    git: https://github.com/FlatMapIO/sound_spectrum.git
    ref: main

```

see [example/lib/main.dart](example/lib/main.dart) for a complete example.
