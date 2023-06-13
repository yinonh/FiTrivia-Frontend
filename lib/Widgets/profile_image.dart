import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../l10n/app_localizations.dart';
import '../Providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile_image';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  Uint8List? _imageBytes;
  final picker = ImagePicker();
  late UserProvider user_provider =
      Provider.of<UserProvider>(context, listen: false);

  String _userID = FirebaseAuth.instance.currentUser!.uid;
  final storage = FirebaseStorage.instance;
  late Reference _imageRef;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageRef = storage.ref().child('Profile images/$_userID.jpg');
    checkExistingProfileImage();
  }

  Future<void> checkExistingProfileImage() async {
    setState(() {
      _isLoading = true; // Show progress indicator
    });
    String? url = await user_provider.checkExistingProfileImage(_userID);

    if (url != null) {
      setState(() {
        _image = null;
        _imageBytes = null;
      });
      await loadImageFromUrl(url);
    }
    setState(() {
      _isLoading = false; // Hide progress indicator
    });
  }

  Future<void> loadImageFromUrl(String imageUrl) async {
    setState(() {
      _isLoading = true; // Show progress indicator
    });
    Uint8List? imageBytes = await user_provider.loadImageFromUrl(imageUrl);

    if (mounted) {
      setState(() {
        _image = null;
        _imageBytes = imageBytes;
      });
    }
    setState(() {
      _isLoading = false; // Hide progress indicator
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imageBytes = null;
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _imageBytes = null;
      }
    });
  }

  Future getImage() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var f = await image.readAsBytes();
      setState(() {
        _image = null;
        _imageBytes = f;
      });
    }
  }

  Future uploadImageToFirebase(BuildContext context) async {
    setState(() {
      _isLoading = true; // Show progress indicator
    });

    if (await user_provider.uploadImageToFirebase(
        context, _image, _imageBytes, _userID)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)
              .translate('Image uploaded successfully')),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('Server Error')),
        ),
      );
    }

    setState(() {
      _isLoading = false; // Hide progress indicator
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
              onTap: (kIsWeb) ? getImage : null,
              child: ClipOval(
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    _image != null || _imageBytes != null
                        ? _image != null
                            ? Image.file(
                                _image!,
                                fit: BoxFit.cover,
                              )
                            : Image.memory(
                                _imageBytes!,
                                fit: BoxFit.cover,
                              )
                        : FutureBuilder(
                            future: _imageRef.getDownloadURL(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                final url = snapshot.data as String?;
                                if (url != null) {
                                  return Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                  );
                                }
                              }
                              return Icon(
                                Icons.person,
                                size: 100,
                                color: colorScheme.secondary,
                              );
                            },
                          ),
                    if (_isLoading) // Show progress indicator
                      CircularProgressIndicator(
                        strokeWidth: 15,
                      ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: getImageFromCamera,
                  child: Icon(Icons.camera_alt),
                ),
                ElevatedButton(
                  onPressed: getImageFromGallery,
                  child: Icon(Icons.photo_library),
                ),
              ],
            ),
          // if (kIsWeb)
          //   ElevatedButton(
          //     onPressed: getImage,
          //     child: Text('Select Image'),
          //   ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => uploadImageToFirebase(context),
            child: Text(
                AppLocalizations.of(context).translate('Set as Profile Image')),
          ),
        ],
      ),
    );
  }
}
