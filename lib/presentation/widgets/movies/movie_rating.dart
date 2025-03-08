import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:flutter/material.dart';

class MovieRating extends StatelessWidget {

  final double voteAverage;
  final double popularity; 

  const MovieRating({super.key, required this.voteAverage, required this.popularity});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme;
    return SizedBox(
            width: 130,
            child: Row(
              children: [
                Icon(Icons.star_half_outlined, color: Colors.amber, size: 15),
                const SizedBox(width: 5),
                Text(HumanFormats.number(voteAverage, 1),
                    style:
                        titleStyle.bodyMedium?.copyWith(color: Colors.yellow.shade900)),
                const Spacer(),
                Icon(Icons.people_outline , size: 15),
                const SizedBox(width: 5),
                Text(HumanFormats.number(popularity),
                    style: titleStyle.bodySmall),
                // Text('${movie.popularity}', style: titleStyle.bodySmall),
              ],
            ),
          );
  }
}