import 'dart:io';

import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/controller/auth_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/controller/signup_from_provider.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/models/signup_response.dart';
import 'package:taxi_booking/core/routes/driver_app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/di/service.dart';

class DocumentUploadView extends ConsumerStatefulWidget {
  final bool withCar;

  const DocumentUploadView({super.key, required this.withCar});

  @override
  ConsumerState<DocumentUploadView> createState() => _DocumentUploadViewState();
}

class _DocumentUploadViewState extends ConsumerState<DocumentUploadView> {
  final ImagePicker _picker = ImagePicker();

  // Personal / driver documents
  File? driverLicenseFront;
  File? driverLicenseBack;
  File? driverPermitFront;
  File? driverPermitBack;
  File? selfie;
  File? idFront;
  File? idBack;

  // Business documents
  File? operatingLicenseDocument;
  File? commercialInsuranceCertificate;
  File? companyRegistrationCertificate;
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      driverLicenseFront = File(
        "/data/user/0/com.drivertexibooking.app.taxi_booking/cache/scaled_56.jpg",
      );
      driverLicenseBack = File(
        "/data/user/0/com.drivertexibooking.app.taxi_booking/cache/scaled_56.jpg",
      );
      driverPermitFront = File(
        "/data/user/0/com.drivertexibooking.app.taxi_booking/cache/scaled_56.jpg",
      );
      driverPermitBack = File(
        "/data/user/0/com.drivertexibooking.app.taxi_booking/cache/scaled_56.jpg",
      );
      selfie = File(
        "/data/user/0/com.drivertexibooking.app.taxi_booking/cache/scaled_56.jpg",
      );
      idFront = File(
        "/data/user/0/com.drivertexibooking.app.taxi_booking/cache/scaled_56.jpg",
      );
      idBack = File(
        "/data/user/0/com.drivertexibooking.app.taxi_booking/cache/scaled_56.jpg",
      );

      // Business documents
      operatingLicenseDocument = File(
        "/data/user/0/com.drivertexibooking.app.taxi_booking/cache/scaled_56.jpg",
      );
      commercialInsuranceCertificate = File(
        "/data/user/0/com.drivertexibooking.app.taxi_booking/cache/scaled_56.jpg",
      );
      companyRegistrationCertificate = File(
        "/data/user/0/com.drivertexibooking.app.taxi_booking/cache/scaled_56.jpg",
      );
    }
  }

  Future<void> _pickImage(
    Function(File) setFile, {
    ImageSource source = ImageSource.gallery,
  }) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setFile(File(pickedFile.path));
    }
  }

  Widget _buildDocumentTile(String title, File? file, Function() onPick) {
    return GestureDetector(
      onTap: onPick,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child:
                  file != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          file,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )
                      : const Icon(
                        Icons.upload_file,
                        size: 40,
                        color: Colors.grey,
                      ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: CommonStyle.textStyleMedium(size: 16)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _submit() async {
    // Validate required fields

    if (driverLicenseFront == null ||
        driverLicenseBack == null ||
        driverPermitFront == null ||
        driverPermitBack == null ||
        selfie == null ||
        idFront == null ||
        idBack == null) {
      CustomToast.showToast(message: "Please upload all required documents");
      return;
    }

    if (widget.withCar) {
      if (operatingLicenseDocument == null ||
          commercialInsuranceCertificate == null ||
          companyRegistrationCertificate == null) {
        CustomToast.showToast(message: "Please upload all business documents");
        return;
      }
    }

    final formNotifier = ref.read(signupFormProvider.notifier);
    final formData = ref.read(signupFormProvider);

    // Update uploaded files
    formNotifier.updateDocuments(
      driverLicenseFront: driverLicenseFront,
      driverLicenseBack: driverLicenseBack,
      driverPermitFront: driverPermitFront,
      driverPermitBack: driverPermitBack,
      selfie: selfie,
      idFront: idFront,
      idBack: idBack,
      operatingLicenseDocument: operatingLicenseDocument,
      commercialInsuranceCertificate: commercialInsuranceCertificate,
      companyRegistrationCertificate: companyRegistrationCertificate,
    );

    await ref
        .watch(authControllerProvider.notifier)
        .signup(formData, widget.withCar);
  }

  @override
  Widget build(BuildContext context) {
    // Listen for changes to react
    ref.listen<AsyncValue<dynamic>>(authControllerProvider, (previous, next) {
      next.when(
        data: (data) {
          if (data != null && data is SignupResponse) {
            // Success: show snackbar and navigate
            ref
                .watch(snackbarServiceProvider)
                .showSuccess("Otp sent sucessfully!");
            Future.microtask(
              () => context.push(DriverAppRoutes.emailVerificationView),
            );
          }
        },
        loading: () {},
        error: (error, stackTrace) {
          ref
              .watch(snackbarServiceProvider)
              .showError( error.toString());
        },
      );
    });

    return Scaffold(
      appBar: CustomAppBar(title: "Upload Documents"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Driver Documents",
              style: CommonStyle.textStyleLarge(size: 20),
            ),
            _buildDocumentTile(
              "Driver License Front",
              driverLicenseFront,
              () => _pickImage(
                (file) => setState(() => driverLicenseFront = file),
              ),
            ),
            _buildDocumentTile(
              "Driver License Back",
              driverLicenseBack,
              () => _pickImage(
                (file) => setState(() => driverLicenseBack = file),
              ),
            ),
            _buildDocumentTile(
              "Driver Permit Front",
              driverPermitFront,
              () => _pickImage(
                (file) => setState(() => driverPermitFront = file),
              ),
            ),
            _buildDocumentTile(
              "Driver Permit Back",
              driverPermitBack,
              () =>
                  _pickImage((file) => setState(() => driverPermitBack = file)),
            ),
            // Selfie pick specifically from camera
            _buildDocumentTile(
              "Selfie",
              selfie,
              () => _pickImage(
                (file) => setState(() => selfie = file),
                source: ImageSource.camera, // force camera
              ),
            ),
            _buildDocumentTile(
              "ID Front",
              idFront,
              () => _pickImage((file) => setState(() => idFront = file)),
            ),
            _buildDocumentTile(
              "ID Back",
              idBack,
              () => _pickImage((file) => setState(() => idBack = file)),
            ),

            if (widget.withCar) ...[
              const SizedBox(height: 20),
              Text(
                "Business Documents",
                style: CommonStyle.textStyleLarge(size: 20),
              ),
              _buildDocumentTile(
                "Operating License",
                operatingLicenseDocument,
                () => _pickImage(
                  (file) => setState(() => operatingLicenseDocument = file),
                ),
              ),
              _buildDocumentTile(
                "Commercial Insurance",
                commercialInsuranceCertificate,
                () => _pickImage(
                  (file) =>
                      setState(() => commercialInsuranceCertificate = file),
                ),
              ),
              _buildDocumentTile(
                "Company Registration Certificate",
                companyRegistrationCertificate,
                () => _pickImage(
                  (file) =>
                      setState(() => companyRegistrationCertificate = file),
                ),
              ),
            ],

            const SizedBox(height: 30),
            CustomButton(
              title: "Submit",
              isLoading: ref.read(authControllerProvider).isLoading,
              onTap: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
