import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/views/core/misc/asset_images.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';

class NullableNetworkImage extends StatelessWidget {
  const NullableNetworkImage({
    Key? key,
    required this.imageUrl,
    this.aspectRatio = 1,
    this.padding,
    this.borderRadius,
    this.placeholderColor,
  }) : super(key: key);

  final String? imageUrl;
  final double aspectRatio;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? placeholderColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ??
          const BorderRadius.all(Radius.circular(kBorderRadius)),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color:
              placeholderColor ?? Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: CachedNetworkImage(
            imageUrl: imageUrl == null
                ? ''
                : (kIsWeb
                    ? 'https://sholawatan.azlir.workers.dev/$imageUrl'
                    : (imageUrl ?? '')),
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(kAppLogoImagePng),
              ),
            ),
            errorWidget: (context, url, error) => Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(kAppLogoImagePng),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
