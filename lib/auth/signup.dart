import 'dart:io';

import 'package:chat_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../utils/custom_color.dart';
import '../utils/global_methods.dart';

class SignUp extends StatefulWidget {
  //const SignUp({ Key? key }) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _displayNameController =
      TextEditingController(text: '');
  final TextEditingController _emailTextController =
      TextEditingController(text: '');
  final TextEditingController _phoneNumberController =
      TextEditingController(text: '');
  final TextEditingController _passTextController =
      TextEditingController(text: '');
  final TextEditingController _positionCPTextController =
      TextEditingController(text: '');

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  final FocusNode _positionCPFocusNode = FocusNode();

  bool _obscureText = true;
  final _signUpFormKey = GlobalKey<FormState>();
  File? imageFile;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? imageUrl;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailTextController.dispose();
    _phoneNumberController.dispose();
    _passTextController.dispose();
    _positionCPTextController.dispose();

    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _passFocusNode.dispose();
    _positionCPFocusNode.dispose();
    super.dispose();
  }

  void _submitFormOnSignUp() async {
    final isValid = _signUpFormKey.currentState!.validate();
    if (isValid) {
      //if (imageFile == null) {
      //  GlobalMethod.showErrorDialog(
      //      error: 'Please pick an image', ctx: context);
      //  return;
      //}

      setState(() {
        _isLoading = true;
      });

      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailTextController.text.trim().toLowerCase(),
            password: _passTextController.text.trim());
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        //final ref = FirebaseStorage.instance
        //    .ref()
        //    .child('userImages')
        //    .child(_uid + '.jpg');
        //await ref.putFile(imageFile!);
        //imageUrl = await ref.getDownloadURL();
        FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'createdAt': Timestamp.now(),
          'designation': _positionCPTextController.text,
          'email': _emailTextController.text,
          'display_name': _displayNameController.text,
          'last_seen': Timestamp.now(),
          'password': _passTextController.text,
          'phone': _phoneNumberController.text,
          'presence': true,
          'profile_pic': 'imageUrl',
          'role': '',
          'uid': _uid,
        });
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } on FirebaseException catch (error) {
        GlobalMethod.showErrorDialog(error: error.message!, ctx: context);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Dialog(
          insetPadding: const EdgeInsets.all(0.0),
          backgroundColor: CustomColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      width: Constants.kDefaultSizeWidth,
                      color: CustomColors.primaryColor,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'SignUp',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                  color: Colors.white, fontSize: 28),
                            ),
                            const SizedBox(height: 10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Already have an account',
                                    style: GoogleFonts.openSans(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  const TextSpan(text: '    '),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.canPop(context)
                                          ? Navigator.pop(context)
                                          : null,
                                    text: 'Login',
                                    style: GoogleFonts.openSans(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue.shade300,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildSignupForm(),
                            const SizedBox(height: 40),
                            _isLoading
                                ? const Center(
                                    child: SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : MaterialButton(
                                    elevation: 0,
                                    minWidth: double.maxFinite,
                                    height: 50,
                                    onPressed: _submitFormOnSignUp,
                                    color: CustomColors.logoGreen,
                                    child: Text('SignUp',
                                        style: GoogleFonts.openSans(
                                            color: Colors.white, fontSize: 16)),
                                    textColor: Colors.white,
                                  ),

                            //MaterialButton(
                            //    onPressed: _submitFormOnSignUp,
                            //    color: Colors.pink.shade700,
                            //    elevation: 8,
                            //    shape: RoundedRectangleBorder(
                            //        borderRadius: BorderRadius.circular(13)),
                            //    child: Padding(
                            //      padding: const EdgeInsets.symmetric(
                            //          vertical: 14),
                            //      child: Row(
                            //        mainAxisAlignment:
                            //            MainAxisAlignment.center,
                            //        children: [
                            //          Text(
                            //            'SignUp',
                            //            style: GoogleFonts.openSans(
                            //                color: Colors.white,
                            //                fontWeight: FontWeight.bold,
                            //                fontSize: 20),
                            //          ),
                            //          SizedBox(
                            //            width: 8,
                            //          ),
                            //          Icon(
                            //            Icons.person_add,
                            //            color: Colors.white,
                            //          ),
                            //        ],
                            //      ),
                            //    ),
                            //  )
                          ]))))),
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imageFile == null
                        ? WebsafeSvg.asset(
                            "assets/Icons/avatar.svg",
                            width: 25,
                          )
                        //Image.network(
                        //    'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
                        //    fit: BoxFit.fill,
                        //  )
                        : Image.file(
                            imageFile!,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    _showImageDialog();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      border: Border.all(width: 2, color: Colors.white),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        imageFile == null
                            ? Icons.add_a_photo
                            : Icons.edit_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          // display name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: CustomColors.secondaryColor,
                border: Border.all(color: Colors.blue)),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_emailFocusNode),
              keyboardType: TextInputType.name,
              controller: _displayNameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return "This Field is missing";
                } else {
                  return null;
                }
              },
              style: GoogleFonts.openSans(color: Colors.white),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  labelText: 'Display name',
                  labelStyle: GoogleFonts.openSans(color: Colors.white),
                  icon: const Icon(Icons.account_circle, color: Colors.white),
                  border: InputBorder.none),
            ),
          ),
          const SizedBox(height: 20),
          //Email
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: CustomColors.secondaryColor,
                border: Border.all(color: Colors.blue)),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              controller: _emailTextController,
              validator: (value) => GlobalMethod.validateEmail(value!),
              style: GoogleFonts.openSans(color: Colors.white),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  labelText: 'Email Address',
                  labelStyle: GoogleFonts.openSans(color: Colors.white),
                  icon: const Icon(Icons.email, color: Colors.white),
                  border: InputBorder.none),
            ),
          ),
          const SizedBox(height: 20),
          // phone number
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: CustomColors.secondaryColor,
                border: Border.all(color: Colors.blue)),
            child: TextFormField(
              focusNode: _phoneNumberFocusNode,
              textInputAction: TextInputAction.next,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_passFocusNode),
              keyboardType: TextInputType.phone,
              controller: _phoneNumberController,
              validator: (value) => GlobalMethod.validatePhone(value!),
              //onChanged: (v) {
              //  print(' Phone number ${_phoneNumberController.text}');
              //},
              style: GoogleFonts.openSans(color: Colors.white),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  labelText: 'Phone Number',
                  labelStyle: GoogleFonts.openSans(color: Colors.white),
                  icon: const Icon(Icons.phone, color: Colors.white),
                  border: InputBorder.none),
            ),
          ),
          const SizedBox(height: 20),
          //Password
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: CustomColors.secondaryColor,
                border: Border.all(color: Colors.blue)),
            child: TextFormField(
              textInputAction: TextInputAction.next,
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(_positionCPFocusNode),
              focusNode: _passFocusNode,
              obscureText: _obscureText,
              keyboardType: TextInputType.visiblePassword,
              controller: _passTextController,
              validator: (value) => GlobalMethod.validatePassword(value!),
              style: GoogleFonts.openSans(color: Colors.white),
              decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  labelText: 'Password',
                  labelStyle: GoogleFonts.openSans(color: Colors.white),
                  icon: const Icon(Icons.lock, color: Colors.white),
                  border: InputBorder.none),
            ),
          ),
          const SizedBox(height: 20),
          //Position in the company
          GestureDetector(
            onTap: () {
              _showTaskCategoriesDialog();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                  color: CustomColors.secondaryColor,
                  border: Border.all(color: Colors.blue)),
              child: TextFormField(
                enabled: false,
                textInputAction: TextInputAction.done,
                onEditingComplete: () => _submitFormOnSignUp,
                focusNode: _positionCPFocusNode,
                keyboardType: TextInputType.name,
                controller: _positionCPTextController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "This field is missing";
                  } else {
                    return null;
                  }
                },
                style: GoogleFonts.openSans(color: Colors.white),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    labelText: 'Position in the company',
                    labelStyle: GoogleFonts.openSans(color: Colors.white),
                    icon: const Icon(Icons.cases_sharp, color: Colors.white),
                    border: InputBorder.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Please choose an option'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    _getFromCamera();
                  },
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        'Camera',
                        style: GoogleFonts.openSans(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.image,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        'Gallery',
                        style: GoogleFonts.openSans(color: Colors.purple),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    // setState(() {
    //   imageFile = File(pickedFile!.path);
    // });
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    // setState(() {
    //   imageFile = File(pickedFile!.path);
    // });
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    File? croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath, maxHeight: 1080, maxWidth: 1080);
    if (croppedImage != null) {
      setState(() {
        imageFile = croppedImage;
      });
    }
  }

  void _showTaskCategoriesDialog() {
    bool jobItem = false;
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Choose Your Designation',
              style: TextStyle(fontSize: 20, color: Colors.pink.shade800),
            ),
            content: SizedBox(
              width: Constants.kDefaultSizeWidth * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: Constants.jobsList.length,
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _positionCPTextController.text =
                              Constants.jobsList[index];
                          jobItem = true;
                        });
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: (jobItem)
                                ? Colors.green.shade200
                                : Colors.red.shade200,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Constants.jobsList[index],
                              style: const TextStyle(
                                  color: CustomColors.darkBlue,
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }
}
