import 'dart:convert'; // لدعم UTF-8
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nfc_project/features/nfc/screens/verifyotppage.dart';
import '../../../componnents/applocal.dart';

class ReadResult extends StatefulWidget {
  const ReadResult({super.key, required this.nfcData});
  final String nfcData;
  @override
  State<ReadResult> createState() => _ReadResultState();
}
class _ReadResultState extends State<ReadResult> {
  TextEditingController decryptedController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("Raw NFC Data: ${widget.nfcData}");
    final dataList = widget.nfcData.split('\n').map((data) {
      final separatorIndex = data.indexOf(':');
      if (separatorIndex != -1) {
        final label = data.substring(0, separatorIndex).trim();
        final value =
            utf8.decode(data.substring(separatorIndex + 1).trim().codeUnits);
        print("Parsed Label: $label, Parsed Value: $value");
        return {"label": label, "value": value};
      } else {
        print("Skipping invalid data: $data");
        return {"label": "Unknown", "value": data.trim()};
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(getLang(context, "NFC_Data")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: SvgPicture.asset('assets/images/information_page.svg',
                  height: 100),
            ),
            const SizedBox(height: 0.0),
            Expanded(
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final field = dataList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: _buildReadOnlyField(
                      context,
                      _getTranslatedLabel(context, field['label']!),
                      field['value']!,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTranslatedLabel(BuildContext context, String label) {
    switch (label.toLowerCase()) {
      case "id":
        return getLang(context, "id");
      case "full name":
        return getLang(context, "full_name");
      case "birthdate":
        return getLang(context, "birth_date");
      case "address":
        return getLang(context, "address");
      case "bloodtype":
        return getLang(context, "blood_type");
      case "emergency contact":
        return getLang(context, "emergency_contact");
      case "allergies_conditions":
        return getLang(context, "medical_conditions_label");
      case "treatments":
        return getLang(context, "treatments_label");
      case "x-rays and examinations":
        return getLang(context,"x_rays_examinations_label");
      case "extract time":
        return getLang(context, "extract_time_label");
      default:
        return label;
    }}
  Widget _buildReadOnlyField(BuildContext context, String label, String value) {
    final isUrlField = label.toLowerCase().contains("X-rays and Examinations");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            suffixIcon: isUrlField
                ? IconButton(
                    icon: Icon(Icons.language, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Verifyotppage(passedString: value),
                        ),
                      );
                    },
                  )
                : null,
          ),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
  bool _isArabic(String text) {
    return RegExp(r'^[\u0600-\u06FF]').hasMatch(text);
  }
}