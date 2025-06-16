// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:nfc_project/core/utils/image_manger.dart';
import 'package:nfc_project/core/widgets/app_text_button.dart';
import 'package:nfc_project/features/nfc/screens/entry_data_screen.dart';
import 'package:nfc_project/features/nfc/screens/json_screan.dart';
import 'package:nfc_project/features/nfc/screens/read_result.dart';
import 'package:nfc_project/componnents/applocal.dart';
import '../../../core/utils/app_text_style.dart';
import '../methods/methods.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectMethod extends StatefulWidget {
  const SelectMethod({super.key});
  @override
  State<SelectMethod> createState() => _SelectMethodState();
}

class _SelectMethodState extends State<SelectMethod> {
  String? nfcData;
  void readData(BuildContext context) {
    startNfcSession(onTagDiscovered: (ndef) async {
      try {
        if (ndef.cachedMessage != null) {
          final records = ndef.cachedMessage!.records;
          final labels = [
            "ID",
            "Full Name",
            "BirthDate",
            "Address",
            "BloodType",
            "Emergency Contact",
            "Medical Conditions",
            "Treatments",
            "X-rays and examinations"
          ];

          final dataList =
              records.asMap().entries.take(records.length).map((entry) {
            final index = entry.key;
            final record = entry.value;
            final payload = record.payload;
            final languageCodeLength = payload[0];
            final cleanedData = String.fromCharCodes(
              payload.sublist(languageCodeLength + 1),
            );
            final label = index < labels.length ? labels[index] : "Unknown";
            return "$label: $cleanedData";
          }).toList();

          final lastRecord = records.last;
          if (lastRecord.payload.isNotEmpty) {
            final encrypted_data =
                String.fromCharCodes(lastRecord.payload.sublist(1));
          }
          final allData = dataList.join('\n');

          setState(() {
            nfcData = allData;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReadResult(nfcData: nfcData!),
            ),
          );
        } else {
          print('No data found on tag');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No data found on tag')),
          );
        }
      } catch (e) {
        print('Error reading NFC tag: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error reading NFC tag')),
        );
      }
    });
  }

  void _launchGoogleUrl() async {
    final Uri url = Uri.parse('https://eman-saber.github.io/MCSEI/');
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failled $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          getLang(context, "select_method"),
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.language, color: Colors.black),
            onPressed: _launchGoogleUrl,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(66, 245, 242, 242),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Image.asset(ImageManager.medicall,
                    height: 380.h, width: 380.h),
              ),
            ),
            Gap(20.h),
            _buildCustomButton(
              context,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    readData(context);
                    return Scaffold(
                      body: SizedBox(
                        height: 200.h,
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
              text: getLang(context, "read_nfc_tag only"),
            ),
            Gap(20.h),
            _buildCustomButton(
              context,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NFCReaderWriter(),
                  ),
                );
              },
              text: getLang(context, "write_nfc_tag"),
            ),
            Gap(20.h),
            _buildCustomButton(
              context,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => json_screen(),
                  ),
                );
              },
              text: getLang(context, "Write_From_File"),
            ),
            Gap(20.h),
            OutlinedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    clearData(context);
                    return Scaffold(
                      body: SizedBox(
                        height: 200.h,
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
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: Colors.red),
              ),
              child: Text(
                getLang(context, "clear_data"),
                style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildCustomButton(BuildContext context,
    {required VoidCallback onPressed, required String text}) {
  return CustomElevatedButton(
    size: Size(ScreenUtil().screenWidth - 40, 50.h),
    onPressed: onPressed,
    text: text,
  );
}
