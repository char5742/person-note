import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/detail/create_event?id=$personId'),
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(person.name),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CirclePersonIconBox(),
                      ElevatedButton(
                          onPressed: () =>
                              context.go('/detail/edit?id=$personId'),
                          child: Text(AppLocalizations.of(context)!.editNote))
                    ],
                  ),
                  Text(person.email ?? '', style: theme.textTheme.bodyMedium),
                  const Padding(padding: EdgeInsets.only(top: 8.0)),
                  Text(person.memo, style: theme.textTheme.bodyLarge),
                  Text(
                      '${person.age != null ? AppLocalizations.of(context)!.yearsOld(person.age!) : ""}  ${person.birthday != null ? "${AppLocalizations.of(context)!.birthday} ${formatDate(person.birthday)}" : ""}',
                      style: theme.textTheme.bodyLarge),
                  const Divider(),
                ],
              ),
            ),
          ),
          EventList(personId: personId),
        ],
      ),
    );
  }
}

class EventList extends HookConsumerWidget {
  final String personId;
  const EventList({required this.personId, super.key});
  Future<void> bottomSheet(context,
      {Function()? onDelete, Function()? onEdit}) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  context.pop();
                  showDialog(
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
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Text(
                      AppLocalizations.of(context)!.deleteEvent,
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
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    Text(
                      AppLocalizations.of(context)!.editEvent,
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
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // the new one come on top
    final eventAsync = ref.watch(eventByPersonIdProvider(personId).select(
        (data) => data
          ..asData?.value.sort((a, b) => b.dateTime.compareTo(a.dateTime))));
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return eventAsync.when(
      error: (e, s) =>
          SliverList(delegate: SliverChildListDelegate([Container()])),
      loading: () => SliverList(
        delegate: SliverChildListDelegate([const CircularProgressIndicator()]),
      ),
      data: (eventList) => SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: eventList.length,
          (context, index) {
            final event = eventList[index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
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
                            Wrap(
                              children: [
                                ...?event.personIdList?.map(
                                  (personId) => HookConsumer(
                                    builder: (context, ref, child) {
                                      final person = ref
                                          .watch(personByIdProvider(personId));
                                      return person.map(
                                        data: (data) => Card(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const CirclePersonIconBox(
                                                size: 16,
                                              ),
                                              const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 4.0)),
                                              Flexible(
                                                child: Text(
                                                  data.value.name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        error: (_) => Container(),
                                        loading: (_) =>
                                            const CircularProgressIndicator(),
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
                    InkWell(
                      onTap: () => bottomSheet(
                        context,
                        onDelete: () => ref
                            .read(eventProvider)
                            .removeEvent(event.id)
                            .then((value) => context.pop()),
                        onEdit: () => context.go(
                            '/detail/edit_event?id=${event.personIdList?.first}&event_id=${event.id}'),
                      ),
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.more_vert,
                          size: 20,
                          color: colorScheme.outline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
