import 'package:flutter/material.dart';
import 'main.dart'; // gọi đến ph_shop()
import 'dart:async';

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  int _countdown = 4;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 1) {
        timer.cancel();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ph_shop()),
          (route) => false,
        );
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🎉 Đăng nhập thành công',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'MerriweatherSans',
                ),
              ),
              const SizedBox(height: 30),
              const Image(
                image: AssetImage('assets/check.png'),
                height: 120,
                width: 120,
              ),
              const SizedBox(height: 30),
              const Text(
                'Chào mừng bạn đến với PH Shop!\nHãy tận hưởng những giây phút mua sắm tuyệt vời nhé!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.4,
                  fontFamily: 'MerriweatherSans',
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Chuyển về trang chính sau $_countdown giây...',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
