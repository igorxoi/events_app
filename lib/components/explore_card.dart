import 'package:events_app/models/event.dart';
import 'package:events_app/pages/event_details.dart';
import 'package:events_app/services/favorite_handler.dart';
import 'package:events_app/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExploreCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onFavoriteToggled;

  const ExploreCard({super.key, required this.event, this.onFavoriteToggled});

  void _navigateToDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EventDetailsPage(event: event)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToDetails(context),
      child: Container(
        height: 150,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.35, // 35%
                    height: double.infinity,
                    color: Colors.grey[200],
                    child: Image.network(
                      'https://f.i.uol.com.br/fotografia/2024/02/08/170741929465c5269eeecc5_1707419294_3x2_md.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                Positioned(
                  top: 8,
                  left: 8,
                  child: InkWell(
                    onTap: () async {
                      await FavoriteHandlerService().toggleFavorite(
                        context: context,
                        event: event,
                        onFavoriteToggled: onFavoriteToggled,
                      );
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: whiteColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        event.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favoriteColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              flex: 65, // 65%
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: blackColor,
                      ),
                    ),
                    const SizedBox(height: 4),

                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: textColorPrimary,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            formatDatePtBr(event.date),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: textColorPrimary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: textColorPrimary,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${event.address.neighborhood}, ${event.address.city}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: textColorPrimary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          size: 16,
                          color: textColorPrimary,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${formatTimePtBr(event.startTime)} até ${formatTimePtBr(event.endTime)}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: textColorPrimary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatDatePtBr(String dateString) {
  final date = DateTime.parse(dateString);
  return DateFormat("d 'de' MMMM 'de' y", 'pt_BR').format(date);
}

String formatTimePtBr(String timeString) {
  final parts = timeString.split(':');
  if (parts.length != 2) return timeString;

  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);

  final hourStr = hour.toString().padLeft(2, '0');

  if (minute == 0) {
    return '${hourStr}h';
  } else {
    final minuteStr = minute.toString().padLeft(2, '0');
    return '${hourStr}h${minuteStr}';
  }
}
