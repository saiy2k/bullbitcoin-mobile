import 'package:bb_mobile/_pkg/logger.dart';
import 'package:bb_mobile/_ui/app_bar.dart';
import 'package:bb_mobile/_ui/components/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoggerPage extends StatelessWidget {
  const LoggerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final logs = context.select((Logger logger) => logger.state);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: BBAppBar(
          text: 'Logs',
          onBack: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (logs.isEmpty)
              const Center(child: BBText.titleLarge('No logs'))
            else ...[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    context.read<Logger>().clear();
                  },
                  child: const BBText.bodySmall('Clear'),
                ),
              ),
              const Divider(),
            ],
            for (final log in logs) _LogItem(log: log),
          ],
        ),
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  const _LogItem({required this.log});

  final (String, DateTime) log;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: BBText.bodySmall(log.$1),
      subtitle: BBText.bodySmall(log.$2.toString(), isBold: true),
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: log.$1));
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
      },
    );
  }
}
