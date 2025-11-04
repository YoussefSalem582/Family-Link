import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/auth_viewmodel.dart';
import 'widgets/custom_text_field.dart';

class SignupView extends GetView<AuthViewModel> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                // Back button
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
                SizedBox(height: 20),
                // App Logo
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/app_logo.png',
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Title
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sign up to get started with Family Link',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 40),
                // Name field
                CustomTextField(
                  controller: controller.signupNameController,
                  hintText: 'Enter your full name',
                  labelText: 'Full Name',
                  prefixIcon: Icons.person_outline,
                ),
                SizedBox(height: 16),
                // Email field
                CustomTextField(
                  controller: controller.signupEmailController,
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                // Password field
                Obx(
                  () => CustomTextField(
                    controller: controller.signupPasswordController,
                    hintText: 'Create a password',
                    labelText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: controller.obscurePassword.value,
                    suffixIcon: IconButton(
                      onPressed: controller.togglePasswordVisibility,
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Confirm Password field
                Obx(
                  () => CustomTextField(
                    controller: controller.signupConfirmPasswordController,
                    hintText: 'Confirm your password',
                    labelText: 'Confirm Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: controller.obscureConfirmPassword.value,
                    suffixIcon: IconButton(
                      onPressed: controller.toggleConfirmPasswordVisibility,
                      icon: Icon(
                        controller.obscureConfirmPassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Family Code field (optional)
                CustomTextField(
                  controller: controller.signupFamilyCodeController,
                  hintText: 'Enter family code (optional)',
                  labelText: 'Family Code (Optional)',
                  prefixIcon: Icons.family_restroom_rounded,
                ),
                SizedBox(height: 12),
                // Family code info
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 14,
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Have a family code? Enter it to join your family group',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                // Terms and conditions
                Text(
                  'By creating an account, you agree to our',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        // Show terms
                        Get.snackbar(
                          'Terms & Conditions',
                          'View terms (UI Only)',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      ' and ',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[500] : Colors.grey[600],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Show privacy policy
                        Get.snackbar(
                          'Privacy Policy',
                          'View privacy policy (UI Only)',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // Signup button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Theme.of(
                          context,
                        ).primaryColor.withOpacity(0.6),
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDark ? Colors.grey[800] : Colors.grey[300],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'or sign up with',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: isDark ? Colors.grey[800] : Colors.grey[300],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // Social signup buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildSocialButton(
                        context: context,
                        icon: Icons.g_mobiledata_rounded,
                        label: 'Google',
                        onPressed: controller.loginWithGoogle,
                        isDark: isDark,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildSocialButton(
                        context: context,
                        icon: Icons.apple_rounded,
                        label: 'Apple',
                        onPressed: controller.loginWithApple,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14),
        side: BorderSide(color: isDark ? Colors.grey[800]! : Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: isDark ? Colors.white : Colors.black87),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
