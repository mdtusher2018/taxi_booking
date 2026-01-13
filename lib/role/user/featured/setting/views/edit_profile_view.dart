import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_drop_down_widget.dart';
import 'package:taxi_booking/resource/common_widget/custom_text_field.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final nameController = TextEditingController(text: "John Doe");
  final genderController = TextEditingController(text: "Male");
  final phoneController = TextEditingController(text: "0123456789");
  final emailController = TextEditingController(text: "john@example.com");

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    genderController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Edit Profile', centerTitle: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROFILE IMAGE
            Center(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child:
                        selectedImage != null
                            ? Image.file(
                              selectedImage!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                            : Image.network(
                              "https://i.pravatar.cc/150?img=1",
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(
                          Icons.edit,
                          size: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: height / 40),

            /// NAME
            Text('Name', style: CommonStyle.textStyleMedium()),
            CustomTextField(hint: 'Enter name', controller: nameController),

            SizedBox(height: height / 60),

            /// GENDER
            Text('Gender', style: CommonStyle.textStyleMedium()),
            CustomDropDownWidget(
              items: const ['Male', 'Female'],
              hintText: 'Select Gender',
              onChanged: (value) {
                genderController.text = value ?? '';
              },
            ),

            SizedBox(height: height / 60),

            /// PHONE
            Text('Phone', style: CommonStyle.textStyleMedium()),
            CustomTextField(hint: 'Enter phone', controller: phoneController),

            SizedBox(height: height / 60),

            /// EMAIL
            Text('Email', style: CommonStyle.textStyleMedium()),
            CustomTextField(
              hint: 'Enter email',
              controller: emailController,
              readOnly: true,
            ),

            SizedBox(height: height / 16),

            /// UPDATE BUTTON
            CustomButton(
              title: 'Update',
              onTap: () {
                CustomToast.showToast(message: 'Profile updated successfully');

                Navigator.pop(context);

                debugPrint("Updated Profile:");
                debugPrint("Name: ${nameController.text}");
                debugPrint("Gender: ${genderController.text}");
                debugPrint("Phone: ${phoneController.text}");
                debugPrint("Email: ${emailController.text}");
              },
            ),
          ],
        ),
      ),
    );
  }
}
