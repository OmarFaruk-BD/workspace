import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/core/components/app_text.dart';
import 'package:workspace/core/components/app_button.dart';
import 'package:workspace/features/thesis/home/cubit/home_cubit.dart';
import 'package:workspace/features/thesis/home/screen/landing_page.dart';

class BottomSection extends StatelessWidget {
  const BottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Positioned(
          left: 0,
          right: 0,
          bottom: 30,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (state.punchedIn != true) ...[
                  CommonText(
                    'How to work',
                    fontSize: 18,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  CommonText(
                    'The easiest way to track attendance and time for your mobile employees. Seamlessly track attendance and retrieve details of location and time in real-time.',
                    fontSize: 12,
                    color: AppColors.grey,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 20),
                ],
                if (state.punchedIn == true) ...[
                  AppButton(
                    text: 'Today’s Visit Area',
                    btnColor: Colors.white,
                    textColor: AppColors.red,
                    onTap: () {
                      AppNavigator.push(context, LandingPage(index: 1));
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
