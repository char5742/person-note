import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/model/person/person.dart';
import 'package:person_note/provider/event.dart';
import 'package:person_note/provider/person.dart';
import 'package:person_note/util/date_format.dart';
import 'package:person_note/util/validator.dart';

class EventEditPage extends HookConsumerWidget {
  final String eventId;
  const EventEditPage({required this.eventId, super.key});

  Future<void> showGetPersonDialog(BuildContext context,
      List<Person> allPersonList, Function(Person) onPressed) async {
    await showDialog(
      context: context,
      builder: (context) {
        return HookConsumer(
          builder: (context, ref, child) {
            final selected = useState<Person?>(null);
            final textEditingController = useTextEditingController();
            return SimpleDialog(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    items: allPersonList.map((person) {
                      return DropdownMenuItem(
                        value: person,
                        child: Row(children: [
                          Text(person.name),
                        ]),
                      );
                    }).toList(),
                    value: selected.value,
                    onChanged: (newValue) => selected.value = newValue,
                    searchController: textEditingController,
                    searchInnerWidget: Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        bottom: 4,
                        right: 8,
                        left: 8,
                      ),
                      child: TextFormField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          hintText: 'Search for an item...',
                          hintStyle: const TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return (item.value.toString().contains(searchValue));
                    },
                    //This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        textEditingController.clear();
                      }
                    },
                  ),
                ),
                IconButton(
                  onPressed: selected.value == null
                      ? null
                      : () {
                          onPressed(selected.value!);
                          context.pop();
                        },
                  icon: const Icon(Icons.add),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = useState(false);
    if (!ref.watch(eventByIdProvider(eventId)).hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    final event = ref.watch(eventByIdProvider(eventId)).value!;

    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final theme = Theme.of(context);
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Person', style: theme.textTheme.bodyLarge),
                    ...personList.value.map((e) => Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 150),
                            child: Text(
                              e.name,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ))),
                    IconButton(
                      onPressed: () {
                        ref.watch(personListProvider.future).then(
                              (value) => showGetPersonDialog(
                                context,
                                // Persons already added are not displayed
                                value
                                    .where((element) =>
                                        !personList.value.contains(element))
                                    .toList(),
                                (person) {
                                  personList.value = [
                                    ...personList.value,
                                    person
                                  ];
                                },
                              ),
                            );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      formatDateTime(dateTime.value),
                      style: theme.textTheme.bodyLarge,
                    ),
                    IconButton(
                      onPressed: () async {
                        final newDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now(),
                        );
                        if (newDate != null) {
                          dateTime.value = newDate;
                        }
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                  ],
                ),
                const Divider(),
                TextFormField(
                  maxLines: null,
                  controller: textConteroller,
                  autofocus: true,
                  validator: Validator.isNonNullString,
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 300)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
