import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/provider/person.dart';
import 'package:person_note/util/date_format.dart';
import 'package:person_note/util/validator.dart';

import '../component.dart';

class EditPage extends HookConsumerWidget {
  final String personId;
  const EditPage({required this.personId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = useState(false);
    if (!ref.watch(personByIdProvider(personId)).hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    final person = ref.watch(personByIdProvider(personId)).value!;

    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final theme = Theme.of(context);
    final nameConteroller = useTextEditingController(text: person.name);
    final ageConteroller =
        useTextEditingController(text: (person.age ?? '').toString());
    final emailConteroller = useTextEditingController(text: person.email);
    final memoConteroller = useTextEditingController(text: person.memo);
    final birthday = useState<DateTime?>(person.birthday);
    final tags = useState(<String>[...?person.tags]);
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: isProcessing.value
                ? null
                : () async {
                    if (formKey.currentState!.validate()) {
                      isProcessing.value = true;
                      final editedPerson = person.copyWith(
                        name: nameConteroller.text,
                        age: int.tryParse(ageConteroller.text),
                        email: emailConteroller.text,
                        birthday: birthday.value,
                        memo: memoConteroller.text,
                        tags: tags.value,
                      );
                      await ref
                          .read(personProvider)
                          .editPerson(editedPerson)
                          .then((value) => context.pop());
                    }
                  },
            child: const Text(
              'Save',
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameConteroller,
                validator: Validator.isNonNullString,
                decoration: const InputDecoration(label: Text('Name')),
              ),
              TextFormField(
                controller: ageConteroller,
                validator: Validator.isNumber,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(label: Text('Age')),
              ),
              TextFormField(
                controller: emailConteroller,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(label: Text('E-mail')),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  children: [
                    Text('Birthday', style: theme.textTheme.labelLarge),
                    const Padding(padding: EdgeInsets.only(left: 16.0)),
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
              TextFormField(
                controller: memoConteroller,
                decoration: const InputDecoration(label: Text('Memo')),
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
