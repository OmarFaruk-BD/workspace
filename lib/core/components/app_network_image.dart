import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:workspace/core/components/app_shimmer.dart';
import 'package:workspace/core/utils/app_images.dart';

class AppCachedNetworkImage extends StatelessWidget {
  const AppCachedNetworkImage(
    this.url, {
    this.fit,
    super.key,
    this.width,
    this.height,
    this.radius = 0,
  });

  final String? url;
  final BoxFit? fit;
  final double? width;
  final double radius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return url == null || url!.isEmpty ? _buildErrorWidget() : _buildImage();
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: url!,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) => AppShimmer(height: height, width: width),
        errorWidget: (context, url, error) => _buildErrorWidget(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return SizedBox(
      width: width,
      height: height,
      child: Image.asset(AppImages.placeholder, fit: BoxFit.cover),
    );
  }
}

class AppCachedImage extends AppCachedNetworkImage {
  const AppCachedImage(
    super.url, {
    super.key,
    super.fit,
    super.width,
    super.height,
    super.radius,
  });
}

class AppNetworkImage extends AppCachedNetworkImage {
  const AppNetworkImage(
    super.url, {
    super.key,
    super.fit,
    super.width,
    super.height,
    super.radius,
  });
}
