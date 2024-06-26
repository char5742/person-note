import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/providers/person_provider.dart';

import '../component.dart';

class EditPage extends HookConsumerWidget {
  const EditPage({required this.personId, super.key});
  final String personId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = useState(false);
    if (!ref.watch(personByIdProvider(personId)).hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    final person = ref.watch(personByIdProvider(personId)).value!;

    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final nameConteroller = useTextEditingController(text: person.name);
    final ageConteroller =
        useTextEditingController(text: (person.age ?? '').toString());
    final emailConteroller = useTextEditingController(text: person.email);
    final memoConteroller = useTextEditingController(text: person.memo);
    final birthdayController = useState<DateTime?>(person.birthday);
    final tagsController = useState(<String>[...?person.tags]);
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
                        birthday: birthdayController.value,
                        memo: memoConteroller.text,
                        tags: tagsController.value,
                      );
                      await ref
                          .read(personServiceProvider)
                          .editPerson(editedPerson)
                          .then((value) => context.pop());
                    }
                  },
            child: Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
      body: PersonForm(
        formKey: formKey,
        nameController: nameConteroller,
        ageController: ageConteroller,
        emailController: emailConteroller,
        memoController: memoConteroller,
        birthdayController: birthdayController,
        tagsController: tagsController,
      ),
    );
  }
}
