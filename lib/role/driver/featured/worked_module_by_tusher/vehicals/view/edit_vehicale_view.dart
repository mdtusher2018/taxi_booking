import 'dart:io';
import 'package:flutter/material.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/resource/common_widget/custom_button.dart';
import 'package:taxi_booking/resource/common_widget/custom_text_field_with_label.dart';
import 'package:taxi_booking/resource/utilitis/custom_toast.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/controller/edit_vehicale_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/edit_vehical_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/model/vehicale_details_response.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/widget/add_edit_view_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class EditVehicleView extends ConsumerStatefulWidget {
  final VehicleData vehicle;
  const EditVehicleView({super.key, required this.vehicle});

  @override
  ConsumerState<EditVehicleView> createState() => _EditVehicleViewState();
}

class _EditVehicleViewState extends ConsumerState<EditVehicleView> {
  final ImagePicker _picker = ImagePicker();

  // Vehicle info
  final vehicleMakeController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final colorController = TextEditingController();
  final registrationNumberController = TextEditingController();
  final seatsController = TextEditingController();

  // Documents
  File? registrationDocument;
  File? technicalInspectionCertificate;
  File? insuranceDocument;

  // Images
  File? frontImage;
  File? rearImage;
  File? interiorImage;

  @override
  void initState() {
    super.initState();
    vehicleMakeController.text = widget.vehicle.vehicleMake;
    modelController.text = widget.vehicle.model;
    yearController.text = widget.vehicle.year.toString();
    colorController.text = widget.vehicle.color;
    registrationNumberController.text = widget.vehicle.registrationNumber;
    seatsController.text = widget.vehicle.numberOfSeats.toString();
  }

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
        .read(editVehicalControllerProvider.notifier)
        .editVehical(
          vehicleMake: vehicleMakeController.text.trim(),
          model: modelController.text.trim(),
          year: int.parse(yearController.text),
          color: colorController.text.trim(),
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
    final state = ref.watch(editVehicalControllerProvider);
    ref.listen<AsyncValue<EditVehicleResponse?>>(
      editVehicalControllerProvider,
      (previous, next) {
        next.when(
          data: (data) {
            if (data != null) {
              context.pop();
              CustomToast.showToast(
                message: "Vehicle updated successfully",
                isError: false,
              );
            }
          },
          error: (error, stackTrace) {
            CustomToast.showToast(message: error.toString(), isError: true);
          },
          loading: () {},
        );
      },
    );

    return Scaffold(
      appBar: CustomAppBar(title: "Edit Vehicle"),
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

            /// 📸 Vehicle Images
            sectionTitle("Vehicle Photos"),
            card(
              Column(
                children: [
                  documentTile(
                    title: "Front View",
                    file: frontImage,
                    url:
                        frontImage == null ? widget.vehicle.photos.front : null,
                    onTap:
                        () => _pickImage((f) => setState(() => frontImage = f)),
                  ),
                  documentTile(
                    title: "Rear View",
                    file: rearImage,
                    url: rearImage == null ? widget.vehicle.photos.rear : null,
                    onTap:
                        () => _pickImage((f) => setState(() => rearImage = f)),
                  ),
                  documentTile(
                    title: "Interior",
                    file: interiorImage,
                    url:
                        interiorImage == null
                            ? widget.vehicle.photos.interior
                            : null,
                    onTap:
                        () => _pickImage(
                          (f) => setState(() => interiorImage = f),
                        ),
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
