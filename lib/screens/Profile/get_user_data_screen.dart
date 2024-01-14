import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maanecommerceui/custom_widgets/my_widgets.dart';
import 'package:maanecommerceui/screens/Start%20Screens/splash_screen.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/profile_provider.dart';
import '../../repos/get_profile_repo.dart';

class UserDetailsInput extends StatefulWidget {
  const UserDetailsInput({super.key, this.fullName});

  final String? fullName;

  @override
  State<UserDetailsInput> createState() => _UserDetailsInputState();
}

class _UserDetailsInputState extends State<UserDetailsInput> {
  final User? _user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final UtilManager utilManager = UtilManager();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController landMarkController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  String homeOrOfficeVar = "Home";
  String selectedCode = "+880";
  File? selectedImageFile;
  String? networkImage;

  @override
  void initState() {
    super.initState();
    if (!(Provider.of<ProfileProvider>(context, listen: false).firstLoad)) {
      UserModel user =
          Provider.of<ProfileProvider>(context, listen: false).user;

      networkImage = user.image;
      fullNameController.text = user.fullName ?? "";
      emailController.text = user.email ?? "";
      addressController.text = user.address ?? "";
      selectedCode = (user.mobileNumber ?? "+880~").split("~")[0];
      mobileNumberController.text =
          (user.mobileNumber ?? "+880~").split("~")[1];
      landMarkController.text = user.landMark ?? "";
      provinceController.text = user.province ?? "";
      cityController.text = user.city ?? "";
      areaController.text = user.area ?? "";
      homeOrOfficeVar = user.homeOrOffice ?? "";
    } else {
      Provider.of<ProfileProvider>(context, listen: false).firstLoad =
          false;
      fullNameController.text = widget.fullName ?? "";
      emailController.text = _user?.email ?? "";
    }
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    emailController.dispose();
    addressController.dispose();
    mobileNumberController.dispose();
    landMarkController.dispose();
    provinceController.dispose();
    cityController.dispose();
    areaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: screenSize.width,
          height: screenSize.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: userDetailsForm(screenSize: screenSize),
          ),
        ),
      ),
    );
  }

  Widget userDetailsForm({required Size screenSize}) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          utilManager.customButton(
            width: 150,
            height: 150,
            color: const Color.fromARGB(255, 253, 247, 247),
            onTap: () async {
              selectedImageFile = await pickImage();
              setState(() {});
            },
            child: (networkImage ?? "").isNotEmpty
                ? Image.network(networkImage!)
                : selectedImageFile != null
                    ? Image.file(selectedImageFile!)
                    : const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.black54,
                      ),
          ),
          const SizedBox(height: 20),
          // Name Field
          utilManager.customTextField(
            labelText: "Full Name",
            hintText: "Mansur Nadim",
            controller: fullNameController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.person_3_outlined),
            validator: _validateInput,
          ),
          const SizedBox(height: 10),
          utilManager.customTextField(
            labelText: "Email Address",
            hintText: "example@email.com",
            enabled: false,
            controller: emailController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.email_outlined),
            validator: _validateInput,
          ),
          const SizedBox(height: 10),
          utilManager.customTextField(
            labelText: "Address",
            hintText: "100, Some road, Kolabagan, Dhaka - 1205",
            controller: addressController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.location_on_outlined),
            validator: _validateInput,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: screenSize.width,
            child: Row(
              children: [
                // Dropdown menu for phone codes
                Container(
                  alignment: Alignment.center,
                  width: screenSize.width * 0.20,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 253, 247, 247),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton(
                    value: selectedCode,
                    onChanged: (newValue) {
                      selectedCode = newValue!;
                      setState(() {});
                    },
                    items: const [
                      DropdownMenuItem(value: "+880", child: Text("+880")),
                      DropdownMenuItem(value: "+91", child: Text("+91")),
                      DropdownMenuItem(value: "+7", child: Text("+7")),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // Custom text field
                SizedBox(
                  width: screenSize.width * 0.65,
                  child: utilManager.customTextField(
                    labelText: "Mobile Number",
                    hintText: "+8809648657894",
                    controller: mobileNumberController,
                    hintColor: Colors.black54,
                    labelColor: Colors.black54,
                    fillColor: const Color.fromARGB(255, 253, 247, 247),
                    enabledBorderColor: Colors.transparent,
                    focusedColor: const Color.fromARGB(255, 50, 194, 122),
                    prefixIcon: const Icon(Icons.local_phone_outlined),
                    validator: _validateInput,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          utilManager.customTextField(
            labelText: "Land Mark",
            hintText: "Near that palm tree is our village...",
            controller: landMarkController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.landscape_outlined),
          ),
          const SizedBox(height: 10),
          utilManager.customTextField(
            labelText: "Province",
            hintText: "Dhaka",
            controller: provinceController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.zoom_out_map),
          ),
          const SizedBox(height: 10),
          utilManager.customTextField(
            labelText: "City",
            hintText: "Dhaka",
            controller: cityController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.location_city_outlined),
          ),
          const SizedBox(height: 10),
          utilManager.customTextField(
            labelText: "Area",
            hintText: "Kolabagan",
            controller: areaController,
            hintColor: Colors.black54,
            labelColor: Colors.black54,
            fillColor: const Color.fromARGB(255, 253, 247, 247),
            enabledBorderColor: Colors.transparent,
            focusedColor: const Color.fromARGB(255, 50, 194, 122),
            prefixIcon: const Icon(Icons.area_chart_outlined),
          ),
          const SizedBox(height: 10),
          homeOrOffice(width: screenSize.width),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: utilManager.customTextButton(
              buttonText: "Save Data",
              fontSize: 20,
              height: 50,
              width: screenSize.width,
              textColor: Colors.white,
              splashColor: Colors.white,
              color: _user != null
                  ? const Color.fromARGB(255, 50, 194, 122)
                  : Colors.black26,
              borderRadius: 80,
              onTap: _user != null
                  ? () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  try {
                    String downloadUrl = "";
                    if (selectedImageFile != null) {
                      Reference storage = FirebaseStorage.instance.ref();
                      var snapshot = await storage
                          .child("Profile Pictures/${_user!.uid}")
                          .putFile(selectedImageFile!);
                      downloadUrl = await snapshot.ref.getDownloadURL();
                    }
                    EasyLoading.showSuccess('Signed up');
                    UserModel data = UserModel(
                      image: downloadUrl.isEmpty
                          ? (networkImage ?? "")
                          : downloadUrl,
                      fullName: fullNameController.text,
                      email: emailController.text,
                      userStat: 'admin',///TODO: Change this to "General"
                      address: addressController.text,
                      mobileNumber:
                      ("$selectedCode~${mobileNumberController.text}"),
                      landMark: landMarkController.text,
                      province: provinceController.text,
                      city: cityController.text,
                      area: areaController.text,
                      homeOrOffice: homeOrOfficeVar,
                    );
                    EasyLoading.show(status: "Uploading...");
                    postUserData(userModel: data);
                    if (context.mounted) {
                      Provider.of<ProfileProvider>(context, listen: false)
                          .updateUserData();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SplashScreen(),
                          ),
                          ModalRoute.withName('/'));
                    }
                  } catch (e) {
                    EasyLoading.showError(e.toString());
                  }
                }
              }
                  : () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<File?> pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image != null) {
        File imageFile = File(image.path);
        return imageFile;
      } else {
        return null;
      }
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
    return null;
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  Widget homeOrOffice({required double width}) {
    return SizedBox(
      width: width,
      child: utilManager.customRadioList(
        title: "It's:",
        value: homeOrOfficeVar,
        maxWidth: width,
        maxHeight: 100,
        height: 60,
        boxColor: const Color.fromARGB(255, 253, 247, 247),
        selectedColor: const Color.fromARGB(255, 50, 194, 122),
        unselectedColor: Colors.white,
        borderRadius: BorderRadius.circular(10),
        groupItems: ["Home", "Office"],
        onChanged: (value) {
          homeOrOfficeVar = value;
          setState(() {});
        },
      ),
    );
  }
}
