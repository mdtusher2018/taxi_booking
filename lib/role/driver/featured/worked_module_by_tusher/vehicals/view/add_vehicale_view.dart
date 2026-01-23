import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_drop_down_widget.dart';
import 'package:taxi_booking/resource/common_widget/custom_text_field_with_label.dart';
import 'package:taxi_booking/resource/utilitis/common_style.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/controller/add_vehical_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/add_vehical_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/widget/add_edit_view_widgets.dart';

class AddVehicleView extends ConsumerStatefulWidget {
  const AddVehicleView({super.key});

  @override
  ConsumerState<AddVehicleView> createState() => _AddVehicleViewState();
}

class _AddVehicleViewState extends ConsumerState<AddVehicleView> {
  final ImagePicker _picker = ImagePicker();

  List<String> carCategory = ["TaxiTil", "Comfort", "Premium", "XL", "Pet"];

  // Vehicle info
  final vehicleMakeController = TextEditingController(
    text: kDebugMode ? 'Toyota' : null,
  );
  final modelController = TextEditingController(
    text: kDebugMode ? 'Corolla' : null,
  );
  final yearController = TextEditingController(
    text: kDebugMode ? '2022' : null,
  );
  final colorController = TextEditingController(
    text: kDebugMode ? 'Red' : null,
  );
  final registrationNumberController = TextEditingController(
    text: kDebugMode ? 'ABC1234' : null,
  );

  final seatsController = TextEditingController(text: kDebugMode ? '5' : null);
  final carCatagoryController = TextEditingController(
    text: kDebugMode ? 'TaxiTil' : null,
  );

  // Documents
  File? registrationDocument;
  File? technicalInspectionCertificate;
  File? insuranceDocument;

  // Images
  File? frontImage;
  File? rearImage;
  File? interiorImage;

  Future<void> _pickImage(Function(File) onPicked) async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (file != null) {
      onPicked(File(file.path));
    }
  }

  void _submit() {
    if (vehicleMakeController.text.isEmpty ||
        modelController.text.isEmpty ||
        yearController.text.isEmpty ||
        carCatagoryController.text.isEmpty ||
        registrationNumberController.text.isEmpty ||
        seatsController.text.isEmpty ||
        registrationDocument == null ||
        technicalInspectionCertificate == null ||
        insuranceDocument == null ||
        frontImage == null ||
        rearImage == null ||
        interiorImage == null) {
      CustomToast.showToast(
        message: "Please complete all required fields",
        isError: true,
      );
      return;
    }

    ref
        .read(addVehicalControllerProvider.notifier)
        .addVehical(
          vehicleMake: vehicleMakeController.text.trim(),
          model: modelController.text.trim(),
          year: int.parse(yearController.text),
          color: colorController.text.trim(),
          catagory: carCatagoryController.text.trim(),
          registrationNumber: registrationNumberController.text.trim(),
          numberOfSeats: int.parse(seatsController.text),

          registrationDocument: registrationDocument!,
          technicalInspectionCertificate: technicalInspectionCertificate!,
          insuranceDocument: insuranceDocument!,

          frontImage: frontImage!,
          rearImage: rearImage!,
          interiorImage: interiorImage!,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addVehicalControllerProvider);
    ref.listen<AsyncValue<AddVehicleResponse?>>(addVehicalControllerProvider, (
      previous,
      next,
    ) {
      next.when(
        data: (data) {
          if (data != null) {
            context.pop();
            CustomToast.showToast(
              message: "Vehicle added successfully",
              isError: false,
            );
          }
        },
        error: (error, stackTrace) {
          CustomToast.showToast(message: error.toString(), isError: true);
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: CustomAppBar(title: "Add Vehicle"),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🚘 Vehicle Info
            sectionTitle("Vehicle Information"),
            card(
              Column(
                children: [
                  CustomTextFieldWithLabel(
                    label: "Vehicle Make",
                    hint: "e.g. Mercedes-Benz",
                    controller: vehicleMakeController,
                  ),
                  CustomTextFieldWithLabel(
                    label: "Model",
                    hint: "e.g. C200",
                    controller: modelController,
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Catagory",
                      style: CommonStyle.textStyleMedium(size: 16),
                    ),
                  ),

                  SizedBox(height: 10),
                  CustomDropDownWidget(
                    items: carCategory,
                    hintText: "Select a catagory",
                    onChanged: (value) {
                      if (value != null) carCatagoryController.text = value;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFieldWithLabel(
                          label: "Year",
                          hint: "2023",
                          keyboardType: TextInputType.number,
                          controller: yearController,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextFieldWithLabel(
                          label: "Color",
                          hint: "Grey",
                          controller: colorController,
                        ),
                      ),
                    ],
                  ),
                  CustomTextFieldWithLabel(
                    label: "Registration Number",
                    hint: "RJN-5544",
                    controller: registrationNumberController,
                  ),
                  CustomTextFieldWithLabel(
                    label: "Number of Seats",
                    hint: "5",
                    keyboardType: TextInputType.number,
                    controller: seatsController,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 📄 Documents
            sectionTitle("Vehicle Documents"),
            card(
              Column(
                children: [
                  documentTile(
                    title: "Registration Document",
                    file: registrationDocument,
                    onTap: () => _pickImage(
                      (f) => setState(() => registrationDocument = f),
                    ),
                  ),
                  documentTile(
                    title: "Technical Inspection Certificate",
                    file: technicalInspectionCertificate,
                    onTap: () => _pickImage(
                      (f) => setState(() => technicalInspectionCertificate = f),
                    ),
                  ),
                  documentTile(
                    title: "Insurance Document",
                    file: insuranceDocument,
                    onTap: () => _pickImage(
                      (f) => setState(() => insuranceDocument = f),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// 📸 Vehicle Images
            sectionTitle("Vehicle Photos"),
            card(
              Column(
                children: [
                  documentTile(
                    title: "Front View",
                    file: frontImage,
                    onTap: () =>
                        _pickImage((f) => setState(() => frontImage = f)),
                  ),
                  documentTile(
                    title: "Rear View",
                    file: rearImage,
                    onTap: () =>
                        _pickImage((f) => setState(() => rearImage = f)),
                  ),
                  documentTile(
                    title: "Interior",
                    file: interiorImage,
                    onTap: () =>
                        _pickImage((f) => setState(() => interiorImage = f)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            CustomButton(
              title: "Add Vehicle",
              isLoading: state.isLoading,
              onTap: _submit,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
