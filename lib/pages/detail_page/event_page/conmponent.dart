import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/models/person/person_model.dart';
import 'package:person_note/providers/person_provider.dart';
import 'package:person_note/utils/date_format.dart';
import 'package:person_note/utils/validator.dart' as validator;

class GetPersonDialog extends HookConsumerWidget {
  const GetPersonDialog({
    super.key,
    required this.allPersonList,
    required this.onPressed,
  });
  final List<Person> allPersonList;
  final void Function(Person) onPressed;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = useState<Person?>(null);
    final textEditingController = useTextEditingController();
    return SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            dropdownSearchData: DropdownSearchData<Person>(
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
                return item.value.toString().contains(searchValue);
              },
            ),
            isExpanded: true,
            items: allPersonList.map((person) {
              return DropdownMenuItem(
                value: person,
                child: Row(
                  children: [
                    Text(person.name),
                  ],
                ),
              );
            }).toList(),
            value: selected.value,
            onChanged: (newValue) => selected.value = newValue,
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
        ),
      ],
    );
  }
}

class EventForm extends HookConsumerWidget {
  const EventForm({
    super.key,
    required this.formKey,
    required this.textConteroller,
    required this.personList,
    required this.dateTime,
  });
  final Key formKey;
  final TextEditingController textConteroller;
  final ValueNotifier<List<Person>> personList;
  final ValueNotifier<DateTime> dateTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PersonListField(personList: personList),
              _DateTimeField(dateTime: dateTime),
              const Divider(),
              _EventContentField(textConteroller: textConteroller),
              const SizedBox(height: 300),
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonListField extends HookConsumerWidget {
  const _PersonListField({required this.personList});
  final ValueNotifier<List<Person>> personList;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.person,
          style: theme.textTheme.bodyLarge,
        ),
        ...personList.value.map(
          (e) => Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: Text(
                  e.name,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            ref.watch(personListProvider.future).then(
                  (value) => showDialog<void>(
                    context: context,
                    builder: (context) {
                      return GetPersonDialog(
                        // Persons already added are not displayed
                        allPersonList: value
                            .where(
                              (element) => !personList.value.contains(element),
                            )
                            .toList(),
                        onPressed: (person) {
                          personList.value = [
                            ...personList.value,
                            person,
                          ];
                        },
                      );
                    },
                  ),
                );
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class _DateTimeField extends HookConsumerWidget {
  const _DateTimeField({required this.dateTime});
  final ValueNotifier<DateTime> dateTime;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Row(
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
              firstDate: DateTime.now().subtract(const Duration(days: 30)),
              lastDate: DateTime.now(),
            );
            if (newDate != null) {
              dateTime.value = newDate;
            }
          },
          icon: const Icon(Icons.date_range),
        ),
      ],
    );
  }
}

class _EventContentField extends HookConsumerWidget {
  const _EventContentField({required this.textConteroller});
  final TextEditingController textConteroller;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return TextFormField(
      maxLines: null,
      controller: textConteroller,
      validator: validator.isNonNullString,
      style: theme.textTheme.bodyLarge,
      decoration: const InputDecoration(
        border: InputBorder.none,
      ),
      selectionHeightStyle: BoxHeightStyle.includeLineSpacingMiddle,
    );
  }
}
