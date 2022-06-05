import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/views/core/misc/asset_images.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(16)),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: placeholderColor ?? Theme.of(context).dividerColor,
        ),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? '',
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(kAppLogoImageSvg),
              ),
            ),
            errorWidget: (context, url, error) => Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(kAppLogoImageSvg),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
