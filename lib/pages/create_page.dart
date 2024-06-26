import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/models/person/person_model.dart';
import 'package:person_note/providers/person_provider.dart';

import 'component.dart';

class CreatePage extends HookConsumerWidget {
  const CreatePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = useState(false);
    final formKey = useMemoized(GlobalKey<FormState>.new, const []);
    final nameConteroller = useTextEditingController();
    final ageConteroller = useTextEditingController();
    final emailConteroller = useTextEditingController();
    final memoConteroller = useTextEditingController();
    final birthdayController = useState<DateTime?>(null);
    final tagsController = useState(<String>[]);
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
            onPressed: isProcessing.value
                ? null
                : () async {
                    if (formKey.currentState!.validate()) {
                      isProcessing.value = true;
                      final person = Person(
                        id: '',
                        name: nameConteroller.text,
                        age: int.tryParse(ageConteroller.text),
                        email: emailConteroller.text,
                        birthday: birthdayController.value,
                        memo: memoConteroller.text,
                        tags: tagsController.value,
                      );
                      await ref
                          .read(personServiceProvider)
                          .addPerson(person)
                          .then((value) => context.go('/'));
                    }
                  },
            child: Text(AppLocalizations.of(context)!.addNote),
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
