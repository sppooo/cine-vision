import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum LoginMethod { none, email, facebook }

class _LoginScreenState extends State<LoginScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  LoginMethod _selectedMethod = LoginMethod.none;
  final Map<String, String> _googleAccounts = {
    "udhay2316@gmail.com": "assets/images/user1.jpg",
    "sppoo11@gmail.com": "assets/images/user1.jpg",
    "chmonika01@gmail.com": "assets/images/user1.jpg",
    "rithuja20@gmail.com": "assets/images/user1.jpg",
  };

  @override
  void initState() {
    super.initState();
    _playLoginSound();
  }

  Future<void> _playLoginSound() async {
    await _audioPlayer.play(AssetSource('audio/login_startup.wav'));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.deepOrangeAccent,
      ),
    );
  }

  void _loginWithGoogle() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Choose Google Account"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _googleAccounts.entries.map((entry) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(entry.value),
              ),
              title: Text(entry.key),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  '/home',
                  arguments: {'email': entry.key, 'image': entry.value},
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _validateMobile() {
    String mobile = _mobileController.text.trim();
    if (mobile.length == 10 && RegExp(r'^[0-9]+$').hasMatch(mobile)) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showError("Invalid mobile number. It must be 10 digits.");
    }
  }

  void _validateEmailLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    if (_googleAccounts.containsKey(email) && password == 'password123') {
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {'email': email, 'image': _googleAccounts[email]},
      );
    } else {
      _showError("Invalid email or password.");
    }
  }

  void _validateFacebookLogin() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;
    String? email = _googleAccounts.keys.firstWhere(
          (e) => e.split('@')[0] == username,
      orElse: () => '',
    );

    if (email.isNotEmpty && password == 'password123') {
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {'email': email, 'image': _googleAccounts[email]},
      );
    } else {
      _showError("Invalid Facebook credentials.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Row(
        children: [
          // Left: Larger Lottie Animation
          Expanded(
            flex: 5,
            child: Center(
              child: Lottie.asset(
                'assets/animations/a1.json',
                repeat: true,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),

          // Center: Login Content
          Expanded(
            flex: 5,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          colors: [Colors.deepOrangeAccent, Colors.deepOrange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 30,
                              color: Colors.deepOrangeAccent,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    _buildLoginButton('Continue with Google', FontAwesomeIcons.google, _loginWithGoogle),
                    const SizedBox(height: 20),

                    _buildLoginButton('Login with Email', Icons.email, () {
                      setState(() => _selectedMethod = LoginMethod.email);
                    }),
                    const SizedBox(height: 20),

                    _buildLoginButton('Login with Facebook', FontAwesomeIcons.facebookF, () {
                      setState(() => _selectedMethod = LoginMethod.facebook);
                    }),
                    const SizedBox(height: 30),

                    Text('OR', style: TextStyle(color: Colors.deepOrange[200], fontSize: 14)),
                    const SizedBox(height: 20),

                    _buildMobileLogin(),
                    const SizedBox(height: 30),

                    if (_selectedMethod == LoginMethod.email) _buildEmailLoginForm(),
                    if (_selectedMethod == LoginMethod.facebook) _buildFacebookLoginForm(),

                    const SizedBox(height: 30),
                    Text(
                      'I agree to the Terms & Conditions & Privacy Policy',
                      style: TextStyle(color: Colors.deepOrange[200], fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right spacer (optional)
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  Widget _buildLoginButton(String label, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: 300,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepOrange[200],
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
        ),
      ),
    );
  }

  Widget _buildMobileLogin() {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Colors.deepOrange[200]),
            decoration: InputDecoration(
              prefixText: '+91 ',
              prefixStyle: TextStyle(color: Colors.deepOrange[200]),
              hintText: 'Enter your number',
              hintStyle: TextStyle(color: Colors.deepOrange[200]),
              border: const UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: _validateMobile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange[200],
              ),
              child: const Text('Login with Mobile', style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailLoginForm() {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            style: TextStyle(color: Colors.deepOrange[200]),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.deepOrange[200]),
              border: const UnderlineInputBorder(),
            ),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(color: Colors.deepOrange[200]),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.deepOrange[200]),
              border: const UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: _validateEmailLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange[200],
              ),
              child: const Text('Login', style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacebookLoginForm() {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            style: TextStyle(color: Colors.deepOrange[200]),
            decoration: InputDecoration(
              labelText: 'Username',
              labelStyle: TextStyle(color: Colors.deepOrange[200]),
              border: const UnderlineInputBorder(),
            ),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(color: Colors.deepOrange[200]),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.deepOrange[200]),
              border: const UnderlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: _validateFacebookLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange[200],
              ),
              child: const Text('Login', style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }
}
