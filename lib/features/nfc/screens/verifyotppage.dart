// ignore_for_file: library_private_types_in_public_api, use_super_parameters, prefer_const_constructors_in_immutables, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:nfc_project/componnents/applocal.dart';
import 'package:url_launcher/url_launcher.dart';
import '../methods/methods.dart';

class Verifyotppage extends StatefulWidget {
  final String passedString;
  Verifyotppage({Key? key, required this.passedString}) : super(key: key);
  @override
  _Verifyotppage createState() => _Verifyotppage();
}
class _Verifyotppage extends State<Verifyotppage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String actualOtp = '';
  String username = 'hussinibrahim043@gmail.com';
  String password = 'ynmp gtww ejzs eklm';
  String generateOTP() {
    return (1000 +
            (999999 - 1000) *
                (DateTime.now().millisecondsSinceEpoch % 1000 / 1000))
        .toStringAsFixed(0);
  }

  void sendOTP(String recipientEmail, String otp) async {
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Smart Medical Card')
      ..recipients.add(recipientEmail)
      ..subject = 'Your OTP Code'
      ..text =
          'Code generated successfully :)\nThis code is strictly confidential. Please do not share it with anyone.\nOTP code is: $otp';
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(getLang(context, "otp_sent")
                .replaceFirst("{email}", recipientEmail))),
      );
    } catch (e) {
      print('Message not sent: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(getLang(context, "failed_send_otp"))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child:
                      SvgPicture.asset('assets/images/authentication_namy.svg'),
                ),
                Text(
                  getLang(context, "verification_title"),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  getLang(context, "enter_email_and_otp"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: getLang(context, "email_address"),
                    hintText: getLang(context, "enter_email"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    suffixIcon: ElevatedButton(
                      onPressed: () {
                        if (emailController.text.trim().isNotEmpty) {
                          actualOtp = generateOTP();
                          sendOTP(emailController.text.trim(), actualOtp);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    getLang(context, "please_enter_email"))),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        getLang(context, "send_code"),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: getLang(context, "otp"),
                    hintText: getLang(context, "enter_otp"),
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    String enteredOtp = otpController.text.trim();
                    if (enteredOtp.isNotEmpty && enteredOtp == actualOtp) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text(getLang(context, "otp_verified_success"))),
                      );
                      final nonee = decryptData(widget.passedString);
                      final url = widget.passedString;
                      final Uri _url = Uri.parse(nonee);
                      if (!await launchUrl(_url)) {
                        throw Exception('Could not launch $_url');
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(getLang(context, "invalid_otp"))),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A5AE0),
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    getLang(context, "verify_otp"),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Extra padding for spacing
              ],
            ),
          ),
        ),
      ),
    );
  }
}