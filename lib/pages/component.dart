import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/utils/date_format.dart';
import 'package:person_note/utils/validator.dart' as validator;

class CirclePersonIconBox extends StatelessWidget {
  const CirclePersonIconBox({super.key, this.size});
  final double? size;

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _size = size ?? 72;
    return SizedBox(
      width: _size,
      height: _size,
      child: CircleAvatar(
        child: ClipOval(
          child: Stack(
            children: [
              Positioned(
                left: -_size / 6,
                child: Icon(
                  Icons.person,
                  size: _size * 4 / 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomMonthDayPicker extends DatePickerModel {
  CustomMonthDayPicker({
    super.currentTime,
    super.minTime,
    super.maxTime,
    super.locale,
  });

  @override
  List<int> layoutProportions() {
    return [0, 1, 1];
  }
}

class PersonForm extends HookConsumerWidget {
  const PersonForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.ageController,
    required this.emailController,
    required this.memoController,
    required this.birthday,
    required this.tags,
  });
  final Key formKey;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController emailController;
  final TextEditingController memoController;
  final ValueNotifier<DateTime?> birthday;
  final ValueNotifier<List<String>> tags;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // name field
              TextFormField(
                controller: nameController,
                validator: validator.isNonNullString,
                decoration: InputDecoration(
                  label: Text(AppLocalizations.of(context)!.name),
                ),
              ),
              // age field
              TextFormField(
                controller: ageController,
                validator: validator.isNumber,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  label: Text(AppLocalizations.of(context)!.age),
                ),
              ),
              // email field
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  label: Text(AppLocalizations.of(context)!.email),
                ),
              ),
              // birthday field
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.birthday,
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      formatDate(birthday.value),
                      style: theme.textTheme.bodyLarge,
                    ),
                    IconButton(
                      onPressed: () async {
                        final date = await DatePicker.showPicker(
                          context,
                          pickerModel:
                              CustomMonthDayPicker(currentTime: DateTime(0)),
                        );
                        birthday.value = date;
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                  ],
                ),
              ),
              // memo field
              TextFormField(
                controller: memoController,
                maxLines: null,
                decoration: InputDecoration(
                  label: Text(AppLocalizations.of(context)!.memo),
                ),
              ),
              // tags field
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 16),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.tags,
                      style: theme.textTheme.labelLarge,
                    ),
                    ...tags.value.map(
                      (e) => Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: Text(
                            e,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (context) {
                            final controller = TextEditingController();
                            return SimpleDialog(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
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

class SelectActionDialog extends StatelessWidget {
  const SelectActionDialog({
    super.key,
    this.onDelete,
    this.onEdit,
    required this.deleteButtonLabel,
    required this.ediButtontLabel,
  });
  final void Function()? onDelete;
  final void Function()? onEdit;
  final String deleteButtonLabel;
  final String ediButtontLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              context.pop();
              showDialog<void>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.deleteCheck),
                    actions: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                      TextButton(
                        onPressed: onDelete,
                        child: Text(AppLocalizations.of(context)!.delete),
                      ),
                    ],
                  );
                },
              );
            },
            child: Row(
              children: [
                const Icon(Icons.delete, size: 28),
                const SizedBox(width: 10),
                Text(
                  deleteButtonLabel,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              onEdit?.call();
            },
            child: Row(
              children: [
                const Icon(Icons.edit, size: 28),
                const SizedBox(width: 10),
                Text(
                  ediButtontLabel,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
