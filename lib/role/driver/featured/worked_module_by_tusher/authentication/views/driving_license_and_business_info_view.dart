import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_text_field_with_label.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/controller/signup_from_provider.dart';
import 'package:taxi_booking/core/routes/driver_app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/authentication/models/business_type_model.dart';

class DrivingLicenseAndBusinessInfoView extends ConsumerStatefulWidget {
  const DrivingLicenseAndBusinessInfoView({super.key, required this.withCar});

  final bool withCar; // show business license only if true

  @override
  ConsumerState<DrivingLicenseAndBusinessInfoView> createState() =>
      _DrivingLicenseAndBusinessInfoViewState();
}

class _DrivingLicenseAndBusinessInfoViewState
    extends ConsumerState<DrivingLicenseAndBusinessInfoView> {
  // Driver License fields
  final TextEditingController driverLicenseNumberController =
      TextEditingController(
        text: kDebugMode ? 'D123456789' : null, // Dummy data in debug mode
      );
  final TextEditingController personalIdController = TextEditingController(
    text: kDebugMode ? 'D123456789' : null, // Dummy data in debug mode
  );

  final TextEditingController organizationNumberController =
      TextEditingController(
        text: kDebugMode ? 'ORG1234567' : null, // Dummy data in debug mode
      );
  final TextEditingController taxIdController = TextEditingController(
    text: kDebugMode ? 'TAX123456789' : null, // Dummy data in debug mode
  );
  final TextEditingController licenseNumberController = TextEditingController(
    text: kDebugMode ? 'BL123456' : null, // Dummy data in debug mode
  );
  final TextEditingController issuingMunicipalityController =
      TextEditingController(
        text: kDebugMode
            ? 'City of Exampletown'
            : null, // Dummy data in debug mode
      );
  final TextEditingController licenseExpiryDateController =
      TextEditingController();
  DateTime? licenseExpiryDate;
  // City field (as per your example)
  final TextEditingController cityController = TextEditingController(
    text: kDebugMode ? 'Dhaka' : null, // Dummy data in debug mode
  );
  final List<BusinessTypeItem> businessTypes = [
    BusinessTypeItem(
      label: "Sole Proprietorship",
      value: "sole_proprietorship",
    ),
    BusinessTypeItem(label: "Limited Company", value: "limited_company"),
    BusinessTypeItem(
      label: "Employed Under Company",
      value: "employed_under_company",
    ),
  ];

  BusinessTypeItem? selectedBusinessType;

  @override
  void dispose() {
    driverLicenseNumberController.dispose();
    licenseExpiryDateController.dispose();

    organizationNumberController.dispose();
    taxIdController.dispose();
    licenseNumberController.dispose();
    issuingMunicipalityController.dispose();
    super.dispose();
  }

  Future<void> _pickLicenseExpiryDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(9999),
    );
    if (pickedDate != null) {
      licenseExpiryDate = pickedDate;
      licenseExpiryDateController.text =
          "${pickedDate.day.toString().padLeft(2, '0')}/"
          "${pickedDate.month.toString().padLeft(2, '0')}/"
          "${pickedDate.year}";
    }
  }

  void _submit() {
    String driverLicenseNumber = driverLicenseNumberController.text.trim();
    String finalLicenseExpiryDate = (licenseExpiryDate != null)
        ? licenseExpiryDate!.toIso8601String()
        : "";

    // Trim business license field
    String organizationNumber = organizationNumberController.text.trim();
    String taxId = taxIdController.text.trim();
    String licenseNumber = licenseNumberController.text.trim();
    String issuingMunicipality = issuingMunicipalityController.text.trim();

    // Validate driver license fields
    if (driverLicenseNumber.isEmpty) {
      CustomToast.showToast(message: 'Please enter driver license number');
      return;
    }

    // Validate business license fields only if withCar == true
    if (widget.withCar) {
      if (selectedBusinessType == null) {
        CustomToast.showToast(message: 'Please select a business type');
        return;
      }
      if (organizationNumber.isEmpty) {
        CustomToast.showToast(message: 'Please enter organization number');
        return;
      }
      if (taxId.isEmpty) {
        CustomToast.showToast(message: 'Please enter tax ID');
        return;
      }
      if (licenseNumber.isEmpty) {
        CustomToast.showToast(message: 'Please enter license number');
        return;
      }
      if (issuingMunicipality.isEmpty) {
        CustomToast.showToast(message: 'Please enter issuing municipality');
        return;
      }
      if (finalLicenseExpiryDate.isEmpty) {
        CustomToast.showToast(message: 'Please enter license expiry date');
        return;
      }
    }

    final formNotifier = ref.read(signupFormProvider.notifier);
    formNotifier.updateDrivingAndBusinessInfo(
      driverLicenseNumber: driverLicenseNumberController.text,
      licenseExpiryDate: finalLicenseExpiryDate,
      personalId: personalIdController.text.trim(),
      businessType: widget.withCar ? selectedBusinessType!.value : null,
      organizationNumber: widget.withCar
          ? organizationNumberController.text
          : null,
      taxId: widget.withCar ? taxIdController.text : null,
      licenseNumber: widget.withCar ? licenseNumberController.text : null,
      issuingMunicipality: widget.withCar
          ? issuingMunicipalityController.text
          : null,
      withCar: widget.withCar,
    );

    context.push(
      DriverAppRoutes.documentUploadView,
      extra: {'withCar': widget.withCar},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'License & Business Details'),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Driver License Section
            Text(
              "Driver License Details",
              style: CommonStyle.textStyleLarge(size: 20),
            ),
            const SizedBox(height: 12),
            CustomTextFieldWithLabel(
              label: "Driver License Number",
              hint: "Enter your driver license number",
              controller: driverLicenseNumberController,
            ),
            if (!widget.withCar) ...[
              const SizedBox(height: 12),
              CustomTextFieldWithLabel(
                label: "Personal Id",
                hint: "Enter your personal id",
                controller: personalIdController,
              ),
            ],

            const SizedBox(height: 20),

            // Business License Section (conditional)
            if (widget.withCar) ...[
              Text(
                "Business License Details",
                style: CommonStyle.textStyleLarge(size: 20),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 1),
                ),
                child: DropdownButton<BusinessTypeItem>(
                  isExpanded: true, // 👈 THIS IS THE KEY
                  value: selectedBusinessType,
                  hint: const Text("Select a business type"),
                  underline: const SizedBox(),
                  onChanged: (value) {
                    setState(() {
                      selectedBusinessType = value;
                    });
                  },
                  items: businessTypes.map((item) {
                    return DropdownMenuItem<BusinessTypeItem>(
                      value: item,
                      child: Text(item.label),
                    );
                  }).toList(),
                ),
              ),

              CustomTextFieldWithLabel(
                label: "Organization Number",
                hint: "e.g. ORG-558899",
                controller: organizationNumberController,
              ),
              CustomTextFieldWithLabel(
                label: "Tax ID",
                hint: "e.g. TAX-442211",
                controller: taxIdController,
              ),
              CustomTextFieldWithLabel(
                label: "License Number",
                hint: "e.g. LIC-224466",
                controller: licenseNumberController,
              ),
              CustomTextFieldWithLabel(
                label: "Issuing Municipality",
                hint: "e.g. London Municipality",
                controller: issuingMunicipalityController,
              ),
              GestureDetector(
                onTap: () => _pickLicenseExpiryDate(context),
                child: AbsorbPointer(
                  child: CustomTextFieldWithLabel(
                    label: "License Expiry Date",
                    hint: "DD/MM/YYYY",
                    controller: licenseExpiryDateController,
                    suffixIcon: const Icon(Icons.calendar_month),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Submit Button
            CustomButton(title: 'Next', onTap: _submit),
          ],
        ),
      ),
    );
  }
}
