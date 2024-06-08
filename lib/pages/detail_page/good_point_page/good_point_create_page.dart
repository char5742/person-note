import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/models/person/good_point/good_point_model.dart';
import 'package:person_note/providers/good_point_provider.dart';

class GoodPointCreatePage extends HookConsumerWidget {
  const GoodPointCreatePage({required this.personId, super.key});

  final String personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = useState(false);
    final textController = useTextEditingController();
    return Dialog(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              minLines: 1,
              maxLines: 3,
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Good Point',
              ),
            ),
            ElevatedButton(
              onPressed: isProcessing.value
                  ? null
                  : () {
                      isProcessing.value = true;
                      ref.read(goodPointServiceProvider(personId)).addGoodPoint(
                            GoodPoint(
                              id: '',
                              point: textController.text,
                            ),
                          );
                      context.pop();
                    },
              child: Text(AppLocalizations.of(context)!.addGoodPoint),
            ),
          ],
        ),
      ),
    );
  }
}
