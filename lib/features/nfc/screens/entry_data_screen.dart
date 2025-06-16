// ignore_for_file: avoid_print, library_private_types_in_public_api, non_constant_identifier_names
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

class NFCReaderWriter extends StatefulWidget {
  const NFCReaderWriter({super.key});
  @override
  _NFCReaderWriterState createState() => _NFCReaderWriterState();
}
class _NFCReaderWriterState extends State<NFCReaderWriter> {
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
  final _EmergenceContact = TextEditingController();
  final _MedicalController = TextEditingController();
  final _TreatmentController = TextEditingController();
  final _allergiesController = TextEditingController();
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
        final emergencyContactRecord = NdefRecord.createText(_EmergenceContact.text);
        final MedicalRecord = NdefRecord.createText(_MedicalController.text);
        final TreatmentsRecord = NdefRecord.createText(_TreatmentController.text);
        final encryptedUrl = encryptData(_allergiesController.text.trim(), "");
        final xRaysRecord = NdefRecord.createText(encryptedUrl);
        final message = NdefMessage([
          idRecord, // 0 - ID
          nameRecord, // 1 - Full Name
          birthDateRecord, // 2 - Birth Date
          addressRecord, // 3 - Address
          bloodTypeRecord, // 4 - Blood Type
          emergencyContactRecord, // 5 - Emergency Contact
          MedicalRecord, // 6 - Allergies & Conditions
          TreatmentsRecord, // 7 - treatments
          xRaysRecord, // 8 - x-rays examinations
        ]);

        await ndef.write(message);
        print('Data written successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data written successfully')),
        );
        // After the NFC write operation is successful, show the dialog
        showDataDialog(context); // Show the success dialog after the write operation
      } catch (e) {
        print('Error writing to NFC tag: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to write data')),
        );
      }
    });
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
                controller: _EmergenceContact,
                hintText:
                    getLang(context, "enter_emergency_contact"),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                inputFormatters: [],
              ),
              Gap(8.h),
              Text(
                getLang(context, "Allergies & Conditions"),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Gap(5.h),
              AppTextFormField(
                controller: _MedicalController,
                hintText: getLang(
                    context, "Enter_Allergies_Conditions"),
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
                controller: _TreatmentController,
                hintText: getLang(context, "treatment_hint"),
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