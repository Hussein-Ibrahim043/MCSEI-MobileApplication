// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nfc_project/features/nfc/screens/select.dart';
import '../../core/utils/image_manger.dart';
import '../../core/widgets/app_text_button.dart';
import '../../componnents/applocal.dart';

class GetStartedScreen extends StatefulWidget {
  final Function(String) changeLanguage;
  const GetStartedScreen({super.key, required this.changeLanguage});
  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  String selectedLanguage = 'العربية';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 400.h,
                width: double.infinity,
                child: Image.asset(
                  ImageManager.getStarted,
                  fit: BoxFit.contain,
                ),
              ),
              Gap(30.h),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.language,
                        size: 28.sp,
                        color: const Color.fromARGB(255, 13, 13, 14),
                      ),
                      Gap(10.w),
                      Text(
                        getLang(context, "select_language"),
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color.fromARGB(255, 13, 13, 14),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Gap(20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedLanguage = getLang(context, "arabic");
                          });
                          // Change the language to Arabic
                          widget.changeLanguage('ar');
                        },
                        child: Text(
                          'العربية', // Display Arabic text on button
                          style: TextStyle(
                            fontSize: 18.sp,
                            color:
                                selectedLanguage == getLang(context, "arabic")
                                    ? Colors.blueAccent
                                    : Colors.black,
                            fontWeight:
                                selectedLanguage == getLang(context, "arabic")
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        '|',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedLanguage = getLang(context, "english");
                          });
                          // Change the language to English
                          widget.changeLanguage('en');
                        },
                        child: Text(
                          getLang(context, "english"),
                          style: TextStyle(
                            fontSize: 18.sp,
                            color:
                                selectedLanguage == getLang(context, "english")
                                    ? Colors.blueAccent
                                    : Colors.black,
                            fontWeight:
                                selectedLanguage == getLang(context, "english")
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Gap(50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 68.h,
                  child: CustomElevatedButton(
                    text: getLang(context, "get_started"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SelectMethod()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}