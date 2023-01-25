import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/model/person/person.dart';
import 'package:person_note/provider/event.dart';
import 'package:person_note/provider/person.dart';

import 'conmponent.dart';

class EventEditPage extends HookConsumerWidget {
  final String eventId;
  const EventEditPage({required this.eventId, super.key});

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
          .whereType()
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
                          .read(eventProvider)
                          .editEvent(editedEvent)
                          .then((value) => context.pop());
                    }
                  },
            child: const Text(
              'Edit Event',
            ),
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
