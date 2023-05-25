import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class MusicProvider with ChangeNotifier {
  final AudioPlayer bgMusicPlayer = AudioPlayer();
  final AudioPlayer clockPlayer = AudioPlayer();
  final AudioPlayer trainPlayer = AudioPlayer();
  final AudioPlayer cheeringPlayer = AudioPlayer();

  double volume = 0.7;
  bool gameMusicOn = false;
  bool backgroundMusicOn = true;
  String musicType = "metal";

  Future<void> fetchMusicSettings(String uid) async {
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        final musicSettings = userDoc.data()?['musicSettings'];

        if (musicSettings != null && musicSettings is Map) {
          volume = musicSettings['volume'] ?? volume;
          gameMusicOn = musicSettings['gameMusicOn'] ?? gameMusicOn;
          backgroundMusicOn =
              musicSettings['backgroundMusicOn'] ?? backgroundMusicOn;
          musicType = musicSettings['musicType'] ?? musicType;
        }
      }
    } catch (error) {
      print('Failed to fetch music settings: $error');
    }
  }

  Future<void> editMusicSettings(
      String uid, Map<String, dynamic> newSettings) async {
    try {
      final userDoc = FirebaseFirestore.instance.collection('Users').doc(uid);

      await userDoc.update({'musicSettings': newSettings});

      // Update the provider properties
      if (newSettings.containsKey('volume')) {
        volume = newSettings['volume'];
      }
      if (newSettings.containsKey('gameMusicOn')) {
        gameMusicOn = newSettings['gameMusicOn'];
      }
      if (newSettings.containsKey('backgroundMusicOn')) {
        backgroundMusicOn = newSettings['backgroundMusicOn'];
      }
      if (newSettings.containsKey('musicType')) {
        musicType = newSettings['musicType'];
      }

      notifyListeners();
    } catch (error) {
      print('Failed to edit music settings: $error');
    }
  }

  get trainMusicFile => DeviceFileSource('assets/$musicType.mp3');

  get backgroundMusicFile => DeviceFileSource('assets/background.mp3');

  get clockMusicFile => DeviceFileSource('assets/bellSound.mp3');

  get cheeringFile => DeviceFileSource('assets/cheering.mp3');

  Future<void> startTrainMusic() async {
    if (gameMusicOn) {
      trainPlayer.setVolume(volume);
      trainPlayer.setReleaseMode(ReleaseMode.loop);
      await trainPlayer.play(DeviceFileSource('assets/$musicType.mp3'));
    }
  }

  Future<void> startCheeringMusic() async {
    if (gameMusicOn) {
      cheeringPlayer.setVolume(volume);
      await cheeringPlayer.play(cheeringFile);
    }
  }

  Future<void> startBgMusic() async {
    bgMusicPlayer.setVolume(volume);
    if ((bgMusicPlayer.state != PlayerState.playing) && backgroundMusicOn) {
      bgMusicPlayer.setReleaseMode(ReleaseMode.loop);
      await bgMusicPlayer.play(backgroundMusicFile);
    }

  }

  Future<void> stopCheeringMusic() async {
    await cheeringPlayer.stop();
  }

  Future<void> stopBgMusic() async {
    await bgMusicPlayer.stop();
  }

  Future<void> stopTrainMusic() async {
    await trainPlayer.stop();
  }

  Future<void> fullTrainVolume() async {
    await trainPlayer.setVolume(volume);
  }

  Future<void> changeTempVolume(double volume) async {
    await bgMusicPlayer.setVolume(volume);
  }

  Future<void> lowTrainVolume() async {
    await trainPlayer.setVolume(volume * 0.4);
  }

  Future<void> pauseBgMusic() async {
    await bgMusicPlayer.pause();
  }

  Future<void> startClockMusic() async {
    if (gameMusicOn) {
      clockPlayer.setVolume(volume);
      await clockPlayer.play(clockMusicFile);
    }
  }

  Future<void> stopClockMusic() async {
    await clockPlayer.stop();
  }

  Future<void> resumeBgMusic() async {
    if ((bgMusicPlayer.state != PlayerState.playing) && backgroundMusicOn) {
      await bgMusicPlayer.resume();
    }
  }
}
