import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../Providers/user_provider.dart';
import '../Providers/music_provider.dart';
import '../Widgets/edit_music_settigs.dart';
import '../Widgets/profile_image.dart';

class UserDetailsScreen extends StatefulWidget {
  static const routeName = '/edit_user';

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool _isUpdatingPassword = false;
  bool _isUpdatingUserDetails = false;
  final _userDetailsFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void initState() {
    _fetchUserDetails();
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _userNameController.text = userData['userName'] ?? '';
          _emailController.text = user.email ?? '';
        });
      }
    }
  }

  Future<void> _updateUserDetails() async {
    if (!_userDetailsFormKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isUpdatingUserDetails = true;
    });
    _userDetailsFormKey.currentState!.save();
    try {
      bool success = await Provider.of<UserProvider>(context, listen: false)
          .updateUserDetails(_userNameController.text, _emailController.text);
      if (success) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              AppLocalizations.of(context).translate('Details Updated'),
            ),
            content: Text(
              AppLocalizations.of(context).translate(
                  'Your user details has been updated successfully.'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  AppLocalizations.of(context).translate('OK'),
                ),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)
                  .translate('Failed to update user details.'),
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).translate('An error occurred.'),
          ),
        ),
      );
    } finally {
      setState(() {
        _isUpdatingUserDetails = false;
      });
    }
  }

  Future<void> _updatePassword() async {
    if (!_passwordFormKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isUpdatingPassword = true;
    });
    _passwordFormKey.currentState!.save();
    try {
      bool success = await Provider.of<UserProvider>(context, listen: false)
          .updatePassword(
              _currentPasswordController.text, _newPasswordController.text);
      if (success) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              AppLocalizations.of(context).translate('Password Updated'),
            ),
            content: Text(AppLocalizations.of(context)
                .translate('Your user details has been updated successfully.')),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  AppLocalizations.of(context).translate('OK'),
                ),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              AppLocalizations.of(context).translate('Password Update Failed'),
            ),
            content: Text(
              AppLocalizations.of(context).translate(
                  'Failed to update the password. Please try again.'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  AppLocalizations.of(context).translate('OK'),
                ),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(AppLocalizations.of(context).translate('Error')),
          content: Text(
              AppLocalizations.of(context).translate('An error occurred.')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text(AppLocalizations.of(context).translate('OK')),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isUpdatingPassword = false;
      });
    }
  }

  Widget _buildUpdateUserDetailsForm() {
    return Form(
      key: _userDetailsFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _userNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)
                    .translate('Please enter your user name');
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).translate('User Name'),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)
                    .translate('Please enter your email');
              } else if (!EmailValidator.validate(value)) {
                return AppLocalizations.of(context).translate('Email invalid');
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).translate('Email'),
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isUpdatingUserDetails ? null : _updateUserDetails,
            child: _isUpdatingUserDetails
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text(
                    AppLocalizations.of(context).translate('Save Changes'),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdatePasswordForm() {
    return Form(
      key: _passwordFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _currentPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)
                    .translate('Please enter your password');
              }
              return null;
            },
            obscureText: true,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)
                  .translate('Please enter your password'),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: _newPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)
                    .translate('Please enter a new password');
              } else if (value.length < 6) {
                return AppLocalizations.of(context)
                    .translate('Password should be at least 6 characters');
              }
              return null;
            },
            obscureText: true,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).translate('New Password'),
            ),
          ),
          SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isUpdatingPassword ? null : _updatePassword,
            child: _isUpdatingPassword
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text(
                    AppLocalizations.of(context).translate('Save Changes'),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Provider.of<MusicProvider>(context, listen: false).startBgMusic();
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            AppLocalizations.of(context).translate('Edit Details'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                AppLocalizations.of(context).translate('Update Profile Image'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ProfileScreen(),
              SizedBox(height: 32),
              Text(
                AppLocalizations.of(context).translate('Update User Details'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildUpdateUserDetailsForm(),
              SizedBox(height: 32),
              Divider(),
              SizedBox(height: 32),
              Text(
                AppLocalizations.of(context).translate('Update Password'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildUpdatePasswordForm(),
              SizedBox(height: 32),
              Text(
                AppLocalizations.of(context).translate('Music Settings'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              EditMusicSettingsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
