import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workspace/core/utils/app_images.dart';
import 'package:workspace/features/thesis/home/cubit/home_cubit.dart';

class DutyLocation extends StatelessWidget {
  const DutyLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Row(
          children: [
            SvgPicture.asset(AppImages.location_2),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'Your Duty Location: ${state.address ?? ''}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }
}
