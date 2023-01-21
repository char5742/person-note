import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/model/event/event.dart';
import 'package:person_note/model/person/person.dart';
import 'package:person_note/provider/event.dart';
import 'package:person_note/provider/person.dart';
import 'package:person_note/util/date_format.dart';
import 'package:person_note/util/validator.dart';

import '../../component.dart';

class EventCreatePage extends HookConsumerWidget {
  final String personId;
  const EventCreatePage({required this.personId, super.key});

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
    if (!ref.watch(personByIdProvider(personId)).hasValue) {
      return const CircularProgressIndicator();
    }
    final person = ref.watch(personByIdProvider(personId)).value!;

    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final theme = Theme.of(context);
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
                    isProcessing.value = true;
                    if (formKey.currentState!.validate()) {
                      final event = Event(
                        id: "",
                        dateTime: dateTime.value,
                        text: textConteroller.text,
                        personIdList:
                            personList.value.map((e) => e.id).toList(),
                        tags: tags.value,
                        created: DateTime.now(),
                        updated: DateTime.now(),
                      );
                      await ref
                          .read(eventProvider)
                          .addEvent(event)
                          .then((value) => context.pop());
                    }
                  },
            child: const Text(
              'Add Event',
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 24,
                width: double.infinity,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Person', style: theme.textTheme.bodyLarge),
                    ...personList.value.map((e) => Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Text(
                            e.name,
                            style: theme.textTheme.bodyLarge,
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
              Expanded(
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: textConteroller,
                  autofocus: true,
                  validator: Validator.isNonNullString,
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 16.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Tags', style: theme.textTheme.labelLarge),
                    ...tags.value.map((e) => Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Text(
                            e,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ))),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final controller = TextEditingController();
                            return SimpleDialog(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              children: [
                                TextFormField(controller: controller),
                                IconButton(
                                  onPressed: () {
                                    tags.value = [
                                      ...tags.value,
                                      controller.text
                                    ];
                                    context.pop();
                                  },
                                  icon: const Icon(Icons.add),
                                )
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
