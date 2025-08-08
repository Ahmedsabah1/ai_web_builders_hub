import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../data/models/tool.dart';
import '../../core/constants/app_constants.dart';

class ToolCard extends StatelessWidget {
  final Tool tool;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;

  const ToolCard({
    super.key,
    required this.tool,
    required this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tool Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppConstants.cardBorderRadius),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: tool.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: tool.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.web,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.web,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
                
                // Category Badge
                if (tool.category != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: tool.category!.color != null
                            ? Color(int.parse('0xFF${tool.category!.color!.replaceAll('#', '')}'))
                            : Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tool.category!.name,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                
                // Favorite Button
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: onFavoriteToggle,
                      icon: Icon(
                        tool.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: tool.isFavorite
                            ? Theme.of(context).colorScheme.error
                            : Colors.grey[600],
                        size: 20,
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Tool Information
            Padding(
              padding: const EdgeInsets.all(AppConstants.smallPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tool Name
                  Text(
                    tool.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Tool Description
                  Text(
                    tool.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Rating and Pricing Row
                  Row(
                    children: [
                      // Rating
                      if (tool.rating != null) ...[
                        RatingBarIndicator(
                          rating: tool.rating!,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tool.rating!.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (tool.ratingCount != null) ...[
                          Text(
                            ' (${tool.ratingCount})',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                      
                      const Spacer(),
                      
                      // Pricing
                      if (tool.pricing != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: tool.pricing!.toLowerCase() == 'free'
                                ? Colors.green.withOpacity(0.1)
                                : Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tool.pricing!,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: tool.pricing!.toLowerCase() == 'free'
                                  ? Colors.green[700]
                                  : Colors.blue[700],
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  // Skill Level
                  if (tool.skillLevel != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.signal_cellular_alt,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tool.skillLevel!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}