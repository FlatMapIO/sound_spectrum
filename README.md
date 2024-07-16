# sound_spectrum

A Flutter package for visualizing audio data in a customizable and interactive way.

**Current Status**: This package is not yet published on pub.dev. The reason for this is that `sound_spectrum` currently depends on the `flutter_soloud` package, which is only available as a Git source. We plan to publish `sound_spectrum` on pub.dev once `flutter_soloud` is officially released.


## Features

- Visualize audio data with customizable bar graphs.
- Configurable parameters for noise threshold, band count, and more.
- Example application to demonstrate usage.

<video width="600" controls>
  <source src="assets/example.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>



## Getting Started

Add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  sound_spectrum:
    git: https://github.com/FlatMapIO/sound_spectrum.git

```

see [example/lib/main.dart](example/lib/main.dart) for a complete example.