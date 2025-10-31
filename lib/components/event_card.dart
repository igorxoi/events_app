import 'package:events_app/models/event.dart';
import 'package:events_app/services/favorite_handler.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onFavoriteToggled;

  const EventCard({super.key, required this.event, this.onFavoriteToggled});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child:
                      // image.isNotEmpty
                      // ?
                      Image.network(
                        "https://f.i.uol.com.br/fotografia/2024/02/08/170741929465c5269eeecc5_1707419294_3x2_md.jpg",
                        fit: BoxFit.cover,
                      ),
                  // : Container(color: Colors.grey[300]),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${event.address.neighborhood} - ${event.address.state}",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 42,
            right: 12,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 21, 101, 192),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getDay(event.date),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    getMonthAbbreviation(event.date),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 16,
            right: 16,
            child: GestureDetector(
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
                  color: Colors.white,
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
                  event.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String getDay(String dateString) {
  final date = DateTime.parse(dateString);
  return date.day.toString().padLeft(2, '0');
}

String getMonthAbbreviation(String dateString) {
  final date = DateTime.parse(dateString);

  const months = [
    'JAN',
    'FEV',
    'MAR',
    'ABR',
    'MAI',
    'JUN',
    'JUL',
    'AGO',
    'SET',
    'OUT',
    'NOV',
    'DEZ',
  ];

  return months[date.month - 1];
}
