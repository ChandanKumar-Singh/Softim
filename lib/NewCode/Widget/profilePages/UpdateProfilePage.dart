import 'dart:io';
import 'package:crm_application/NewCode/Provider/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int? userId;
  late String username;
  String? phone;
  var authToken, email = ''; //address='Please fill the address';
  late SharedPreferences prefs;
  bool _isLoading = false;
  File? _image;
  final picker = ImagePicker();

  final _phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  var images = '';
  String? userProfile, address;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkState();
  }
  @override
  void dispose() {
    // TODO: implement initState
    super.dispose();

  }
  void checkState() async {
    prefs = await SharedPreferences.getInstance();
    setState(
      () {
        userId = prefs.getInt('userId')!;
        username = prefs.getString('username')!;
        email = prefs.getString('email')!;
        emailController.text = email;
        phone = prefs.getString('contact')!;
        _phoneController.text = phone!;
        address = prefs.getString('address');
        _addressController.text = address!;
        authToken = prefs.getString('token');
        userProfile = prefs.getString('profile_image');
      },
    );

    debugPrint('CheckUserId : $userId');
  }

  // Future<void> uploadImage() async {
  //   var url = ApiManager.BASE_URL + ApiManager.updateProfileInfo;
  //   final headers = {
  //     'Authorization-token': '3MPHJP0BC63435345341',
  //     'Authorization': 'Bearer $authToken',
  //     'Accept': 'application/json',
  //   };
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse(url),
  //   );
  //   request.files
  //       .add(await http.MultipartFile.fromPath('user_profile', _image!.path));
  //   request.fields['user_id'] = userId.toString();
  //   request.headers.addAll(headers);
  //   var res = await request.send();
  //   var responseData = await res.stream.toBytes();
  //   var result = String.fromCharCodes(responseData);
  //   log('ImageResponse : ${result.toString()}');
  //   var imageResponse = json.decode(result.toString());
  //   var success = imageResponse['success'];
  //   var data = imageResponse['data'];
  //   if (success == 200) {
  //     setState(
  //       () {
  //         var images = data['user_profile'];
  //         prefs.setString('image', images);
  //       },
  //     );
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('success'),
  //       ),
  //     );
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const ProfilePage(),
  //       ),
  //     );
  //   } else {
  //     setState(
  //       () {
  //         _isLoading = false;
  //       },
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('error'),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: themeColor,
        titleSpacing: 0,
        title: const Text(
          "Update Profile",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<AuthProviders>(
          builder: (context, authProvider, child) => Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: userProfile == null
                            ? Image.asset(
                                'assets/images/person.jpeg',
                                scale: 3,
                              )
                            : SizedBox(
                                height: 85.h,
                                width: 80.w,
                                child: Image.network(
                                  userProfile!,
                                  // height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User ID : ${userId.toString()}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "User Name : $username ",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Email Id',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      readOnly: false,
                      controller: emailController,
                      // initialValue: email,
                      decoration: InputDecoration(
                          fillColor: Colors.grey[150],
                          filled: true,
                          hintText: email,
                          prefixIcon: const Icon(Icons.email),
                          border: const OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Phone',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: _phoneController,
                      decoration: InputDecoration(
                          fillColor: Colors.grey[150],
                          filled: true,
                          labelText: phone.toString(),
                          prefixIcon: const Icon(Icons.edit),
                          border: const OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Password',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: passwordController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[150],
                        filled: true,
                        labelText: 'Create new password here',
                        prefixIcon: const Icon(Icons.edit),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Confirm Password',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[150],
                        filled: true,
                        labelText: 'Enter same password as above',
                        prefixIcon: const Icon(Icons.edit),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: const [
                        Text(
                          'Address',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[150],
                        filled: true,
                        labelText: address ?? 'Please fill the address',
                        //'Please fill the address',
                        prefixIcon: const Icon(Icons.edit),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        print(_isLoading);
                        if (emailController.text.isEmpty) {
                          Fluttertoast.showToast(msg: 'Please enter an email.');
                        } else if (_phoneController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Please enter a contact number.');
                        } else if (passwordController.text.isNotEmpty &&
                            passwordController.text !=
                                confirmPasswordController.text) {
                          Fluttertoast.showToast(
                              msg: 'Password didn\'t matched.');
                        } else if (_addressController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Please enter your address');
                        } else {
                          // print('inited');
                          await authProvider
                              .updateProfileInfo(
                                userId.toString(),
                                username,
                                emailController.text,
                                _phoneController.text,
                                passwordController.text,
                                _addressController.text,
                                authToken.toString(),
                                context,
                              )
                              .then((value) => print(
                                  '---------------------------- updated profile info'))
                              .then((value) => setState(() {
                                    _isLoading = false;
                                  }));
                        }
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B2A98),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: !_isLoading
                            ? const Center(
                                child: Text(
                                  "UPDATE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          // uploadImage();
          debugPrint('Image path : ${_image!.path.toString()}');
        } else {
          debugPrint("No image selected");
        }
      });
    } catch (e) {
      debugPrint("Image picker error $e");
    }
  }

  Future getImageWithCamera() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 90);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      // uploadImage();
    } else {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image selected'),
          ),
        );
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Pick From Gallery'),
                      onTap: () {
                        _pickImage();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      getImageWithCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
