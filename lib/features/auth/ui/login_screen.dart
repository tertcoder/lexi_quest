import 'package:flutter/material.dart';
import 'package:lexi_quest/core/theme/app_colors.dart';
import 'package:lexi_quest/features/auth/ui/widgets/logo_header.dart';
import 'package:lexi_quest/features/auth/ui/widgets/positioned_liney.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5, 1.0],
            colors: [
              AppColors.primaryIndigo600,
              AppColors.primaryIndigo500,
              AppColors.neutralSlate50,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              PositionedLiney(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    SizedBox(height: 72),
                    LogoHeader(),
                    SizedBox(height: 42),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.background,

                          border: const Border(
                            top: BorderSide(
                              color: AppColors.primaryVariant,
                              width: 6,
                            ),
                            right: BorderSide(
                              color: AppColors.primaryVariant,
                              width: 6,
                            ),
                            left: BorderSide(
                              color: AppColors.primaryVariant,
                              width: 6,
                            ),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Column(children: [Text("Hola")]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
