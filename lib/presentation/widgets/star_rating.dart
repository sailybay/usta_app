import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;

  const StarRating({super.key, required this.rating, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return Icon(Icons.star_rounded, size: size, color: AppColors.star);
        } else if (i < rating) {
          return Icon(
            Icons.star_half_rounded,
            size: size,
            color: AppColors.star,
          );
        } else {
          return Icon(
            Icons.star_border_rounded,
            size: size,
            color: AppColors.star,
          );
        }
      }),
    );
  }
}
