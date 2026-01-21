import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myprojectshop/theme/theme.dart';

class NoInternetScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetScreen({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie Animation for No Internet
              // Note: You might need to add a lottie file to assets or use a network one
              Lottie.network(
                'https://assets9.lottiefiles.com/packages/lf20_0s6tfbuc.json',
                height: 250,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.wifi_off,
                    size: 150,
                    color: AppTheme.primaryColor,
                  );
                },
              ),
              const SizedBox(height: 40),
              const Text(
                'No Internet Connection',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Please check your internet settings and try again to continue shopping.',
                style: TextStyle(fontSize: 16, color: AppTheme.textsecandery),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
