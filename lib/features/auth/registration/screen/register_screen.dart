import 'package:home_haven/core/util/export.dart';
import 'package:home_haven/features/auth/registration/controller/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.put(RegisterController());
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<RegisterController>(
          builder: (_) => Padding(
            padding: EdgeInsets.all(17),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColor,
                    ),
                  ),
                  Text(
                    "Fill in your details below to get started on a seamless shopping experience.",
                    style: TextStyle(
                      color: AppColors.neutral70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  CustomTextField(
                    hintText: "Name",
                    controller: nameController,
                    prefixIcon: Image.asset(AppIcons.person),
                  ),
                  const SizedBox(height: 22),
                  CustomTextField(
                    hintText: "Email",
                    controller: emailController,
                    prefixIcon: Image.asset(AppIcons.email),
                  ),
                  const SizedBox(height: 22),
                  CustomTextField(
                    hintText: "Password",
                    controller: passwordController,
                    prefixIcon: Image.asset(AppIcons.lock),
                    suffixIcon: IconButton(
                      onPressed: controller.showPassword,
                      icon: Icon(
                        controller.hidenPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    obscureText: controller.hidenPassword,
                  ),
                  const SizedBox(height: 22),
                  CustomTextField(
                    hintText: "Confirm Password",
                    controller: confirmPasswordController,
                    prefixIcon: Image.asset(AppIcons.lock),
                    suffixIcon: IconButton(
                      onPressed: controller.showConfirmPassword,
                      icon: Icon(
                        controller.hidenConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                    obscureText: controller.hidenConfirmPassword,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Text(
                        "Role: ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 10),
                      DropdownButton<String>(
                        value: controller.selectedRole,
                        items: [
                          DropdownMenuItem(
                              value: "customer", child: Text("Customer")),
                          DropdownMenuItem(
                              value: "admin", child: Text("Admin")),
                        ],
                        onChanged: (value) {
                          if (value != null) controller.selectedRole = value;
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  controller.isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : CustomButton(
                          text: "Create Account",
                          onTap: () {
                            if (nameController.text.isEmpty ||
                                emailController.text.isEmpty ||
                                passwordController.text.isEmpty ||
                                confirmPasswordController.text.isEmpty) {
                              Get.snackbar("Error", "Please fill all field",
                                  duration: Duration(seconds: 4));
                              return;
                            } else if (passwordController.text !=
                                confirmPasswordController.text) {
                              Get.snackbar("Error", "Password don't match",
                                  duration: Duration(seconds: 4));
                              return;
                            }
                            controller.registorUser(
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              role: controller.selectedRole,
                            );
                          },
                        ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "I have a account?",
                        style: TextStyle(fontSize: 17),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Get.offAllNamed(RouterConstant.loginScreen);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
