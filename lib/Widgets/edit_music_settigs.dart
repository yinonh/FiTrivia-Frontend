import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:audioplayers/audioplayers.dart';

import '../Providers/music_provider.dart';

class EditMusicSettingsWidget extends StatefulWidget {
  @override
  _EditMusicSettingsWidgetState createState() => _EditMusicSettingsWidgetState();
}

class _EditMusicSettingsWidgetState extends State<EditMusicSettingsWidget> {
  late double volume;
  late bool gameMusicOn;
  late bool backgroundMusicOn;
  late String musicType;
  Map<String, String> musicTypeNames = {
    'metal': 'Metal',
    'rock': 'Rock',
    'pop': 'Pop',
  };
  late String selectedMusicType;
  AudioPlayer previewPlayers = AudioPlayer();
  bool isPlayingPreview = false;


  @override
  void initState() {
    super.initState();
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    volume = musicProvider.volume;
    gameMusicOn = musicProvider.gameMusicOn;
    backgroundMusicOn = musicProvider.backgroundMusicOn;
    musicType = musicProvider.musicType;
    selectedMusicType = musicProvider.musicType;
  }

  @override
  void dispose() {
    previewPlayers.dispose();
    super.dispose();
  }

  void onMusicTypeSelected(String musicType) {
    if (selectedMusicType != musicType) {
      playMusicPreview(musicType);
      setState(() {
        selectedMusicType = musicType;
      });
    }
  }

  Future<void> playMusicPreview(String musicType) async {
    final String musicAsset = 'assets/metal.mp3';
    final Duration previewDuration = Duration(seconds: 5);

    if (previewPlayers.state == PlayerState.playing) {
      await previewPlayers.stop();
    }

    await Provider.of<MusicProvider>(context, listen: false).stopBgMusic();
    await previewPlayers.setVolume(volume);
    setState(() {
      isPlayingPreview = true;
    });
    await previewPlayers.play(DeviceFileSource(musicAsset));
    await previewPlayers.seek(Duration(seconds: 3));
    await Future.delayed(previewDuration);
    await previewPlayers.stop();
    setState(() {
      isPlayingPreview = false;
    });
    await Provider.of<MusicProvider>(context, listen: false).startBgMusic();
  }

  Future<void> saveChanges() async {
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    final uid = FirebaseAuth.instance.currentUser!.uid; // User's UID

    if(!backgroundMusicOn){
      musicProvider.stopBgMusic();
    }

    final newSettings = {
      'volume': volume,
      'gameMusicOn': gameMusicOn,
      'backgroundMusicOn': backgroundMusicOn,
      'musicType': musicType,
    };

    await musicProvider.editMusicSettings(uid, newSettings);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Music settings updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Volume',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: volume,
          min: 0.0,
          max: 1.0,
          onChanged: (newValue) {
            setState(() {
              volume = newValue;
            });
          },
        ),
        SizedBox(height: 16.0),
        CheckboxListTile(
          title: Text('Game Music'),
          value: gameMusicOn,
          onChanged: (newValue) {
            setState(() {
              gameMusicOn = newValue ?? false;
            });
          },
        ),
        SizedBox(height: 16.0),
        CheckboxListTile(
          title: Text('Background Music'),
          value: backgroundMusicOn,
          onChanged: (newValue) {
            setState(() {
              backgroundMusicOn = newValue ?? false;
            });
          },
        ),
        SizedBox(height: 16.0),
        Text(
          'Music Type',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        Row(
          children: musicTypeNames.keys.map((musicType) {
            final bool isSelected = musicType == selectedMusicType;
            return Expanded(
              child: GestureDetector(
                onTap: () => onMusicTypeSelected(musicType),
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: this.isPlayingPreview ? CircularProgressIndicator(color: Colors.white, ) : Text(
                      musicTypeNames[musicType]!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 32.0),
        Center(
          child: ElevatedButton(
            onPressed: saveChanges,
            child: Text('Save Changes'),
          ),
        ),
        SizedBox(height: 32.0),
      ],
    );

  }
}
