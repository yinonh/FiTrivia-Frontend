import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class MusicProvider with ChangeNotifier {
  AudioPlayer bgMusicPlayer = AudioPlayer();
  AudioPlayer clockPlayer = AudioPlayer();
  AudioPlayer trainPlayer = AudioPlayer();

  get volume => 0.7;
  get gameMusicOn => true;
  get backgroundMusicOn => true;
  get musicType => "metal";
  get trainMusicFile => DeviceFileSource('assets/metal.mp3');
  get backgroundMusicFile => DeviceFileSource('assets/background.mp3');
  get clockMusicFile => DeviceFileSource('assets/bellSound.mp3');

  Future<void> startTrainMusic() async {
    await trainPlayer.play(trainMusicFile);
  }

  Future<void> stopTrainMusic() async {
    await trainPlayer.stop();
  }

  Future<void> fullTrainVolume() async {
    await trainPlayer.setVolume(1);
  }

  Future<void> lowTrainVolume() async {
    await trainPlayer.setVolume(0.3);
  }

  Future<void> pauseBgMusic() async {
    await bgMusicPlayer.pause();
  }

  Future<void> startClockMusic() async {
    await clockPlayer.play(clockMusicFile);
  }

  Future<void> stopClockMusic() async {
    await clockPlayer.stop();
  }

  Future<void> startBgMusic() async {
    bgMusicPlayer.setReleaseMode(ReleaseMode.loop);
    await bgMusicPlayer.play(backgroundMusicFile);
  }

  Future<void> resumeBgMusic() async {
    await bgMusicPlayer.resume();
  }
}
