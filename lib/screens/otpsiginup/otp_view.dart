import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'otp_controller.dart';
import '../../../../appColors/appColors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          "Confirmation",
          style: TextStyle(
            fontWeight: FontWeight.w900, 
            color: Color(0xFF003317),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomAction(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            RichText(
              text: TextSpan(
                text: "Un code à 6 chiffres a été envoyé au ",
                style: const TextStyle(color: Colors.grey, fontSize: 15, height: 1.5),
                children: [
                  TextSpan(
                    text: controller.phone,
                    style: TextStyle(color: AppColors.generalColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 45),

            _buildOtpInputField(),

            const SizedBox(height: 25),
            
            Center(
              child: TextButton(
                onPressed: () => print("Renvoyer le code"),
                style: TextButton.styleFrom(foregroundColor: AppColors.generalColor),
                child: const Text(
                  "Je n'ai pas reçu de code",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildBottomAction() {
    return Padding(
      padding: EdgeInsets.only(
        left: 25, 
        right: 25, 
        bottom: MediaQuery.of(Get.context!).viewInsets.bottom > 0 ? 20 : 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSubmitButton(),
         
        ],
      ),
    );
  }

Widget _buildOtpInputField() {
    const double otpSpacing = 10.0; 
    return Center(
      child: Container(
        width: 200, 
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.generalColor.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: TextField(
          controller: controller.otpController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          autofocus: true,
          maxLength: 6,
          style: const TextStyle(
            fontSize: 26, 
            letterSpacing: otpSpacing, 
            fontWeight: FontWeight.w900,
            color: Color(0xFF003317),
          ),
          decoration: InputDecoration(
            hintText: "••••••", 
            hintStyle: TextStyle(
              color: Colors.grey.shade300, 
              letterSpacing: otpSpacing,
              fontSize: 20
            ),
            counterText: "", 
            contentPadding: const EdgeInsets.only(
              top: 20, 
              bottom: 20, 
              left: otpSpacing 
            ),
            border: InputBorder.none, 
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
    
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: controller.verifyOtp,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.generalColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
          ),
          child: const Text(
            "VALIDER LE CODE",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1),
          ),
        ),
      ),
    );
  }
}