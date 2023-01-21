import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:person_note/provider/event.dart';
import 'package:person_note/provider/person.dart';
import 'package:person_note/util/date_format.dart';

import '../component.dart';

class DetailPage extends HookConsumerWidget {
  final String personId;
  const DetailPage({required this.personId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(personByIdProvider(personId)).hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    final person = ref.watch(personByIdProvider(personId)).value!;

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(person.name),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/detail/create_event?id=$personId'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CirclePersonIconBox(),
                    ElevatedButton(
                        onPressed: () =>
                            context.go('/detail/edit?id=$personId'),
                        child: const Text('Edit Note'))
                  ],
                ),
                Text(person.email ?? '', style: theme.textTheme.bodyMedium),
                const Padding(padding: EdgeInsets.only(top: 8.0)),
                Text(person.memo, style: theme.textTheme.bodyLarge),
                Text(
                    '${person.age != null ? "${person.age}歳" : ""}  ${person.birthday != null ? "誕生日: ${person.birthday?.month}月${person.birthday?.day}日" : ""}',
                    style: theme.textTheme.bodyLarge),
                const Divider(),
              ],
            ),
          ),
          Expanded(
            child: EventList(personId: personId),
          ),
        ],
      ),
    );
  }
}

class EventList extends HookConsumerWidget {
  final String personId;
  const EventList({required this.personId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // the new one come on top
    final eventAsync = ref.watch(eventByPersonIdProvider(personId).select(
        (data) => data
          ..asData?.value.sort((a, b) => b.dateTime.compareTo(a.dateTime))));
    final textTheme = Theme.of(context).textTheme;

    return eventAsync.when(
      error: (e, s) => Container(),
      loading: () => const CircularProgressIndicator(),
      data: (eventList) => ListView.builder(
        itemCount: eventList.length,
        itemBuilder: (context, index) {
          final event = eventList[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formatDateTime(event.dateTime)),
                    Text(
                      event.text,
                      style: textTheme.bodyLarge,
                    ),
                    Row(
                      children: [
                        ...?event.personIdList?.map(
                          (personId) => HookConsumer(
                            builder: (context, ref, child) {
                              if (ref
                                  .watch(personByIdProvider(personId))
                                  .isLoading) {
                                return const CircularProgressIndicator();
                              }
                              final person = ref
                                  .watch(personByIdProvider(personId))
                                  .value!;
                              return Card(
                                child: Row(
                                  children: [
                                    const CirclePersonIconBox(
                                      size: 16,
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 4.0)),
                                    Text(person.name),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
