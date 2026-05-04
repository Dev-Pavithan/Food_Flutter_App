import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../theme/app_theme.dart';
import 'main_screen.dart';
import '../widgets/fade_transition_page.dart';
import '../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLogin = true;
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _showSuccess = false;

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _handleSubmit() async {
    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
        _showSuccess = true;
      });

      // Show success animation for 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        context.read<UserProvider>().setUser(
          _emailController.text.isEmpty ? 'Guest' : _emailController.text,
          _emailController.text.isEmpty,
        );
        Navigator.pushReplacement(
          context,
          FadeRoute(page: const MainScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Blur
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&q=80&w=1000'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _showSuccess ? _buildSuccessState() : _buildLoginForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer Glow
            TweenAnimationBuilder(
              duration: const Duration(seconds: 2),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3 * value),
                        blurRadius: 40 * value,
                        spreadRadius: 10 * value,
                      )
                    ],
                  ),
                );
              },
            ),
            
            // Animated Logo
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Container(
                height: 140,
                width: 140,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 50),
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: const Column(
            children: [
              Text(
                'Success!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Taking you to delicious food...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 60),
        
        // Animated Progress Bar
        SizedBox(
          width: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(30, 40, 30, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo (No circle now)
          Hero(
            tag: 'logo',
            child: Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          // Glassmorphic Card
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isLogin ? 'Welcome Back!' : 'Create Account',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isLogin 
                        ? 'Glad to see you again! Please login to your account.' 
                        : 'Fill in the details below to get started.',
                      style: TextStyle(color: AppTheme.textLight.withOpacity(0.8), fontSize: 14),
                    ),
                    const SizedBox(height: 30),
                    
                    if (!_isLogin) ...[
                      _buildTextField('Full Name', Icons.person_outline, _nameController),
                      const SizedBox(height: 15),
                    ],
                    
                    _buildTextField('Email Address', Icons.email_outlined, _emailController),
                    const SizedBox(height: 15),
                    
                    _buildTextField('Password', Icons.lock_outline, _passwordController, isPassword: true),
                    
                    if (_isLogin)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                    
                    if (!_isLogin) ...[
                      const SizedBox(height: 15),
                      _buildTextField('Confirm Password', Icons.lock_reset, _confirmPasswordController, isPassword: true),
                    ],
                    
                    const SizedBox(height: 25),
                    
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                        ),
                        child: _isLoading 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(_isLogin ? 'Login' : 'Sign Up', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    
                    const SizedBox(height: 25),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLogin ? "Don't have an account? " : "Already have an account? ",
                          style: const TextStyle(color: AppTheme.textLight, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: _toggleForm,
                          child: Text(
                            _isLogin ? "Register" : "Login",
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
          
          const SizedBox(height: 30),
          
          // Social Logins
          const Text(
            'Or connect with',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(Icons.g_mobiledata, Colors.white),
              const SizedBox(width: 20),
              _socialIcon(Icons.apple, Colors.white),
              const SizedBox(width: 20),
              _socialIcon(Icons.facebook, Colors.white),
            ],
          ),
          
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => _handleSubmit(), // Guest mode
            child: const Text(
              'Continue as Guest',
              style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        style: const TextStyle(color: AppTheme.textDark, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppTheme.textLight.withOpacity(0.6), fontSize: 14),
          prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 22),
          suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppTheme.textLight,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon, Color color) {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: 30),
      ),
    );
  }
}
