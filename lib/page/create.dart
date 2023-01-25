import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/model/person/person.dart';
import 'package:person_note/provider/person.dart';

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
    final birthday = useState<DateTime?>(null);
    final tags = useState(<String>[]);
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
                        id: "",
                        name: nameConteroller.text,
                        age: int.tryParse(ageConteroller.text),
                        email: emailConteroller.text,
                        birthday: birthday.value,
                        memo: memoConteroller.text,
                        tags: tags.value,
                      );
                      await ref
                          .read(personProvider)
                          .addPerson(person)
                          .then((value) => context.go('/'));
                    }
                  },
            child: const Text(
              'Add Person',
            ),
          ),
        ],
      ),
      body: PersonForm(
        formKey: formKey,
        nameController: nameConteroller,
        ageController: ageConteroller,
        emailController: emailConteroller,
        memoController: memoConteroller,
        birthday: birthday,
        tags: tags,
      ),
    );
  }
}
