import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/model/event/event.dart';
import 'package:person_note/model/person/person.dart';
import 'package:person_note/provider/event.dart';
import 'package:person_note/provider/person.dart';

import 'conmponent.dart';

class EventCreatePage extends HookConsumerWidget {
  const EventCreatePage({required this.personId, super.key});
  final String personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = useState(false);
    if (!ref.watch(personByIdProvider(personId)).hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    final person = ref.watch(personByIdProvider(personId)).value!;

    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final textConteroller = useTextEditingController();
    final personList = useState<List<Person>>([person]);
    final dateTime = useState<DateTime>(DateTime.now());
    final tags = useState(<String>[]);
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
                      final event = Event(
                        id: '',
                        dateTime: dateTime.value,
                        text: textConteroller.text,
                        personIdList:
                            personList.value.map((e) => e.id).toList(),
                        tags: tags.value,
                      );
                      await ref
                          .read(eventProvider)
                          .addEvent(event)
                          .then((value) => context.pop());
                    }
                  },
            child: Text(AppLocalizations.of(context)!.addEvent),
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
