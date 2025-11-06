import 'package:events_app/models/event.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

class ShareService {
  static final ShareService _instance = ShareService._internal();

  factory ShareService() {
    return _instance;
  }

  ShareService._internal();

  Future<void> shareEvent({
    required BuildContext context,
    required Event event,
  }) async {
    try {
      final String shareText =
          '''
${event.name}

📅 ${event.date}
⏰ ${event.startTime} - ${event.endTime}
📍 ${event.address.street}, ${event.address.number} - ${event.address.neighborhood}
   ${event.address.city}, ${event.address.state}

${event.descricao}

Venha participar deste evento incrível!
''';

      await Share.share(shareText, subject: event.name);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível compartilhar o evento'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
