import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_time_chat/global.dart';
import 'package:real_time_chat/services/database.dart';

class NewUserWelcome extends StatefulWidget {
  const NewUserWelcome({Key key}) : super(key: key);

  @override
  _NewUserWelcomeState createState() => _NewUserWelcomeState();
}

class _NewUserWelcomeState extends State<NewUserWelcome> {
  bool hasPicture = false;
  final ImagePicker picker = ImagePicker();
  File _img;

  Future<void> pickImage() async {
    try {
      final PickedFile pickedFile =
          await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final File _image = File(pickedFile.path);
        if (_image != null) {
          setState(() {
            _img = _image;
            hasPicture = true;
          });
          EasyLoading.showToast('Successfully Added Image');
        } else {
          EasyLoading.showToast('Cropped Image Failed');
        }
      }
    } catch (e) {
      EasyLoading.showError('Uploading Photo Failed');
      print(e);
    }
  }

  Future<void> _uploadPic(File img) async {
    try {
      if (hasPicture) {
        DatabaseService().uploadProfilePicture(_img);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _getProfilePicture() async {
    if (hasPicture) {
      Navigator.of(context).pop();
    } else {
      await pickImage();
      EasyLoading.show(status: 'Uploading...');
      await _uploadPic(_img);
      EasyLoading.showToast('Completed',
          toastPosition: EasyLoadingToastPosition.bottom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              hasPicture
                  ? Container(
                      width: 180,
                      height: 180,
                      child: ClipOval(
                        child: Image.file(
                          _img,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: _getProfilePicture,
                      child: Container(
                        padding: const EdgeInsets.all(30.0),
                        decoration: BoxDecoration(
                          color: primaryBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_a_photo,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
              //General Welcome
              _generalWelcome(context),
              //RULES
              //Continue Button
              _addBtn(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addBtn(BuildContext context) {
    return GestureDetector(
      onTap: _getProfilePicture,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: primaryBlue,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            hasPicture ? 'Done' : 'Pick Image',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _generalWelcome(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Align(
        alignment: Alignment.center,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Profile Picture\n',
            style: TextStyle(
              fontSize: 26.0,
              color: Colors.black,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold,
            ),
            children: <TextSpan>[
              TextSpan(
                text:
                    'You should add a profile picture to make sure everyone can recognize you.',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
