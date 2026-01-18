import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/core/utils/app_colors.dart';
import 'package:workspace/core/utils/app_styles.dart';
import 'package:workspace/core/helper/navigation.dart';
import 'package:workspace/core/components/app_text.dart';
import 'package:workspace/features/thesis/auth/cubit/auth_cubit.dart';
import 'package:workspace/features/thesis/home/screen/notification.dart';
import 'package:workspace/features/thesis/home/screen/profile_page.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().updateUserImage();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 15,
              bottom: 85,
              right: 20,
              left: 20,
            ),
            color: AppColors.primary,
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: state.user?.imageUrl != null
                      ? CircleAvatar(
                          radius: 40,
                          backgroundImage: MemoryImage(
                            base64Decode(state.user?.imageUrl ?? ''),
                          ),
                        )
                      : Icon(Icons.person, size: 40, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        state.user?.name ?? '',
                        maxLines: 2,
                        fontSize: 18,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        state.user?.phone ?? '',
                        style: AppStyles.mediumGrey12.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      AppNavigator.push(context, NotificationPage()),
                  icon: Icon(
                    Icons.notifications,
                    color: AppColors.white,
                    size: 28,
                  ),
                ),
                IconButton(
                  onPressed: () =>
                      AppNavigator.push(context, ProfilePage(user: state.user)),
                  icon: Icon(
                    Icons.account_circle,
                    color: AppColors.white,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class HeaderWidgetV2 extends StatelessWidget {
  const HeaderWidgetV2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 15,
            bottom: 20,
            right: 20,
            left: 20,
          ),
          color: AppColors.primary,
          child: Row(
            children: [
              Container(
                width: 62,
                height: 62,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(70),
                ),
                child: state.user?.imageUrl != null
                    ? CircleAvatar(
                        radius: 40,
                        backgroundImage: MemoryImage(
                          base64Decode(state.user?.imageUrl ?? ''),
                        ),
                      )
                    : Icon(Icons.person, size: 40, color: AppColors.primary),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(
                      state.user?.name ?? '',
                      maxLines: 2,
                      fontSize: 18,
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      state.user?.phone ?? '',
                      style: AppStyles.mediumGrey12.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => AppNavigator.push(context, NotificationPage()),
                icon: Icon(
                  Icons.notifications,
                  color: AppColors.white,
                  size: 28,
                ),
              ),
              IconButton(
                onPressed: () =>
                    AppNavigator.push(context, ProfilePage(user: state.user)),
                icon: Icon(
                  Icons.account_circle,
                  color: AppColors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
