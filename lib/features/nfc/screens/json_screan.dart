// ignore_for_file: camel_case_types, library_private_types_in_public_api, non_constant_identifier_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_project/core/utils/app_text_style.dart';
import 'package:nfc_project/core/utils/color_manger.dart';
import 'package:nfc_project/core/utils/image_manger.dart';
import 'package:nfc_project/core/widgets/app_text_form_field.dart';
import 'package:nfc_project/features/nfc/methods/methods.dart';
import '../../../componnents/applocal.dart';
import '../../../core/widgets/app_text_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

class json_screen extends StatefulWidget {
  const json_screen({super.key});
  @override
  _json_screenState createState() => _json_screenState();
}
class _json_screenState extends State<json_screen> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedBloodType;
  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  final _emergencyContactController = TextEditingController();
  final _medicalController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _extractedtimeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    NfcManager.instance.isAvailable().then((available) {
      if (!available) {
        print('NFC is not available on this device');
      }
    });
  }

  void _writeData() async {
    startNfcSession(onTagDiscovered: (ndef) async {
      try {
        final idRecord = NdefRecord.createText(_idController.text);
        final nameRecord = NdefRecord.createText(_nameController.text);
        final birthDateRecord = NdefRecord.createText(_birthDateController.text);
        final addressRecord = NdefRecord.createText(_addressController.text);
        final bloodTypeRecord = NdefRecord.createText(_selectedBloodType ?? '');
        final emergencyContactRecord = NdefRecord.createText(_emergencyContactController.text);
        final MedicalRecord = NdefRecord.createText(_medicalController.text);
        final TreatmentRecord = NdefRecord.createText(_treatmentController.text);
        final encryptedUrl = encryptData(_allergiesController.text.trim(), "");
        final xRaysRecord = NdefRecord.createText(encryptedUrl);
        final Extracted_Date = NdefRecord.createText(_extractedtimeController.text);
        final message = NdefMessage([
          idRecord, // 0 - ID
          nameRecord, // 1 - Full Name
          birthDateRecord, // 2 - Birth Date
          addressRecord, // 3 - Address
          bloodTypeRecord, // 4 - Blood Type
          emergencyContactRecord, // 5 - Emergency Contact
          MedicalRecord, // 6 - Allergies & Conditions
          TreatmentRecord, // 7 - treatments
          Extracted_Date, // 8 - Extracted Date
          xRaysRecord, // 9 - x-rays examinations
        ]);
        await ndef.write(message);
        print('Data written successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data written successfully')),
        );
        showDataDialog(
            context);
      } catch (e) {
        print('Error writing to NFC tag: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to write data')),
        );
      }
    });
  }

  Future<void> _selectAndReadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null && result.files.single.path != null) {
      try {
        String fileContent =
            await File(result.files.single.path!).readAsString();
        Map<String, dynamic> jsonData = jsonDecode(fileContent.trim());
        setState(() {
          _idController.text = jsonData['NationalId'] ?? '';
          _nameController.text = jsonData['FullName'] ?? '';
          _birthDateController.text = jsonData['BirthDate'] ?? '';
          _addressController.text = jsonData['Address'] ?? '';
          _selectedBloodType = jsonData['BloodType'];
          _emergencyContactController.text = jsonData['ContactNo'] ?? '';
          _medicalController.text = jsonData['Diagnosis'] ?? '';
          _treatmentController.text = jsonData['Treatment'] ?? '';
          _extractedtimeController.text = jsonData['Extracted_Date'] ?? '';
          _allergiesController.text = jsonData['ImageUrl'] ?? '';
        });
      } 
      catch (e) {
        print('Error reading JSON file: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid JSON file')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getLang(context, "enter_patient_info")),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(5.h),
              Center(
                child: SvgPicture.asset('assets/images/information_page.svg',
                    height: 70),
              ),
              Gap(5.h),
              Text(
                getLang(context, "id"),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Gap(5.h),
              TextField(
                controller: _idController,
                keyboardType: TextInputType.number,
                maxLength: 14,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: getLang(context, "enter_your_id"),
                  counterText: '',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 12.0),
                  hintStyle: TextStyle(
                      fontSize: 12.0),
                  labelStyle: TextStyle(
                      fontSize: 14.0),
                ),
                style: TextStyle(
                    fontSize: 14.0),
              ),
              Gap(5.h),
              Text(
                getLang(context, "name"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Gap(5.h),
              AppTextFormField(
                controller: _nameController,
                hintText: getLang(context, "enter_full_name"),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                inputFormatters: [],
              ),
              Gap(8.h),
              Text(
                getLang(context, "birth_date"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Gap(5.h),
              AppTextFormField(
                controller: _birthDateController,
                suffixIcon: Icon(Icons.calendar_month_rounded),
                hintText: getLang(context, "enter_birth_date"),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _birthDateController.text =
                          "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
                inputFormatters: [],
              ),
              Gap(8.h),
              Text(
                getLang(context, "address"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Gap(5.h),
              AppTextFormField(
                controller: _addressController,
                hintText: getLang(context, "enter_address"),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                inputFormatters: [],
              ),
              Gap(8.h),
              Text(
                getLang(context, "blood_type"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Gap(5.h),
              DropdownButtonFormField<String>(
                value: _selectedBloodType,
                hint: Text(
                  getLang(context, "select_blood_type"),
                  style: TextStyles.font14LightGrayRegular,
                ),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ColorsManager.lighterGray,
                      width: 1.3,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 1.3,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                items: _bloodTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 12)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedBloodType = newValue;
                  });
                },
              ),
              Gap(8.h),
              Text(
                getLang(context, "emergency_contact"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Gap(5.h),
              AppTextFormField(
                controller: _emergencyContactController,
                hintText:
                    getLang(context, "enter_emergency_contact"),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                inputFormatters: [],
              ),
              Gap(8.h),
              Text(
                getLang(context, "allergies_conditions_label"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Gap(5.h),
              AppTextFormField(
                controller: _medicalController,
                hintText:
                    getLang(context, "allergies_conditions_hint"),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                inputFormatters: [],
              ),
              Gap(8.h),
              Text(
                getLang(context, "treatments_label"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Gap(5.h),
              AppTextFormField(
                controller: _treatmentController,
                hintText: getLang(context, "treatment_hint"),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                inputFormatters: [],
              ),
              Gap(8.h),
              Text(
                getLang(context, "extract_time_label"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Gap(5.h),
              AppTextFormField(
                controller: _extractedtimeController,
                hintText: getLang(context, "extract_time_hint"),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                inputFormatters: [],
              ),
              Gap(8.h),
              Text(
                getLang(context, "x_rays_exams"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Gap(5.h),
              AppTextFormField(
                controller: _allergiesController,
                hintText: getLang(context, "enter_xrays_url"),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                inputFormatters: [],
              ),
              Gap(8.h),
              SizedBox(height: 8),
              CustomElevatedButton(
                text: getLang(context, "Select_JSON_file"),
                onPressed: _selectAndReadFile,
              ),
              Gap(8.h),
              SizedBox(height: 8),
              CustomElevatedButton(
                text: getLang(context, "write_nfc_tagg"),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      _writeData();
                      return Scaffold(
                        body: SizedBox(
                          height: 180.h,
                          width: ScreenUtil().screenWidth,
                          child: Column(
                            children: [
                              Text(
                                'Waiting NFC',
                                style: TextStyles.font24BlueBold,
                              ),
                              Lottie.asset(ImageManager.nfcScanningAnimation),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDropdown(String label, String? value, List<String> items,
    void Function(String?) onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      const Gap(5),
      DropdownButtonFormField<String>(
        value: value,
        hint: Text("Select $label"),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(fontSize: 12)));
        }).toList(),
        onChanged: onChanged,
      ),
      const Gap(10),
    ],
  );
}