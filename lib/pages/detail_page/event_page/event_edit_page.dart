import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/models/person/person_model.dart';
import 'package:person_note/providers/event_provider.dart';
import 'package:person_note/providers/person_provider.dart';

import 'conmponent.dart';

class EventEditPage extends HookConsumerWidget {
  const EventEditPage({required this.eventId, super.key});
  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = useState(false);
    if (!ref.watch(eventByIdProvider(eventId)).hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    final event = ref.watch(eventByIdProvider(eventId)).value!;

    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final textConteroller = useTextEditingController(text: event.text);
    final personList = useState<List<Person>>([
      ...?event.personIdList
          ?.map((id) => ref.read(personByIdProvider(id)).asData?.value)
          .whereType(),
    ]);
    final dateTime = useState<DateTime>(event.dateTime);
    final tags = useState(<String>[...?event.tags]);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close),
        ),
        actions: [
          ElevatedButton(
            onPressed: isProcessing.value
                ? null
                : () async {
                    if (formKey.currentState!.validate()) {
                      isProcessing.value = true;
                      final editedEvent = event.copyWith(
                        dateTime: dateTime.value,
                        text: textConteroller.text,
                        personIdList:
                            personList.value.map((e) => e.id).toList(),
                        tags: tags.value,
                      );
                      await ref
                          .read(eventServiceProvider)
                          .editEvent(editedEvent)
                          .then((value) => context.pop());
                    }
                  },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
      body: EventForm(
        formKey: formKey,
        textConteroller: textConteroller,
        personList: personList,
        dateTime: dateTime,
      ),
    );
  }
}
