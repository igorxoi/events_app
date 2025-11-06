import 'package:events_app/models/event.dart';
import 'package:events_app/services/favorite_handler.dart';
import 'package:events_app/services/share.dart';
import 'package:events_app/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;
  const EventDetailsPage({super.key, required this.event});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  late bool _isFavored;

  @override
  void initState() {
    super.initState();
    _isFavored = widget.event.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 98,
        leading: Padding(
          padding: const EdgeInsets.only(left: 32),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: primaryDarkColor,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.arrow_back, color: whiteColor),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 32),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: primaryDarkColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: Icon(
                  _isFavored ? Icons.favorite : Icons.favorite_border,
                  color: whiteColor,
                ),
                onPressed: () {
                  setState(() {
                    FavoriteHandlerService().toggleFavorite(
                      context: context,
                      event: widget.event,
                    );
                    _isFavored = !_isFavored;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://f.i.uol.com.br/fotografia/2024/02/08/170741929465c5269eeecc5_1707419294_3x2_md.jpg",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 230.0,
                    left: 32.0,
                    right: 32.0,
                    bottom: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: primaryDarkColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.event.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: whiteColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 16,
                                  color: whiteColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  formatDate(widget.event.date),
                                  style: const TextStyle(
                                    color: whiteColor,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.access_time_outlined,
                                  size: 16,
                                  color: whiteColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.event.startTime,
                                  style: const TextStyle(
                                    color: whiteColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: whiteColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.event.address.city} - ${widget.event.address.state}',
                                  style: const TextStyle(
                                    color: whiteColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Local',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${widget.event.address.street}, ${widget.event.address.number}\n${widget.event.address.neighborhood}, ${widget.event.address.city} - ${widget.event.address.state}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: textColorPrimary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Mapa será adicionado aqui',
                            style: TextStyle(color: textColorPrimary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            ShareService().shareEvent(
                              context: context,
                              event: widget.event,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Compartilhar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    final formattedDate = DateFormat("dd 'de' MMMM", 'pt_BR').format(date);
    return formattedDate;
  }
}
