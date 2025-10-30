import 'package:castle/Controlls/AuthController/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Colors/Colors.dart' as AppColors;

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  AuthController controller = Get.put(AuthController());
  RxBool hide = true.obs;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo with 3D floating effect
                //

                SizedBox(height: screenHeight * 0.3),

                // Welcome text with gradient
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          AppColors.containerColor,
                          AppColors.shadeColor,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        "Welcome to castle",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Simplify your service flow — from request to completion",
                      style: GoogleFonts.poppins(
                        color: AppColors.containerColor.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.06),

                // Email field with 3D effect
                _buildTextField(
                  context: context,
                  controller: controller.userNameController,
                  label: "Email/Username",
                  icon: Icons.email_outlined,
                  isPassword: false,
                ),

                SizedBox(height: 20),

                // Password field with 3D effect
                Obx(() => _buildTextField(
                      context: context,
                      controller: controller.passwordController,
                      label: "Password",
                      icon: Icons.lock_outline,
                      isPassword: hide.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          hide.value ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.containerColor,
                        ),
                        onPressed: () => hide.value = !hide.value,
                      ),
                    )),

                SizedBox(height: 10),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "Forgot password?",
                      style: GoogleFonts.poppins(
                        color: AppColors.containerColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.1),

                // Sign in button with 3D effect
                Obx(
                  () => controller.isLoading.value
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.buttonColor,
                          ),
                        )
                      : MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () async =>
                                await controller.loginWithUserName(),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.buttonColor,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.containerColor
                                        .withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  // onTap: () async => await controller.loginUser(),
                                  child: Center(
                                    child: Text(
                                      "SIGN IN",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),

                SizedBox(height: screenHeight * 0.03),

                // Divider with "OR" text
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isPassword,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadeColor,
            blurRadius: 8,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.poppins(
          color: AppColors.containerColor,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            color: AppColors.containerColor,
          ),
          prefixIcon: Icon(
            icon,
            color: AppColors.containerColor,
            size: 20,
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: AppColors.shadeColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.shadeColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColors.buttonColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context,
      {required IconData icon, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.containerColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadeColor,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: AppColors.secondaryColor,
            size: 24,
          ),
        ),
      ),
    );
  }
}
