import 'package:person_note/models/event/event_model.dart';
import 'package:person_note/services/event_service.dart';

final initData = <String, Event>{
  '0': Event(
    id: '0',
    dateTime: DateTime(2022, 5),
    text: 'A day when I went bird watching with my friend.',
    created: DateTime.now(),
    updated: DateTime.now(),
    personIdList: ['0', '1', '2'],
  ),
  '1': Event(
    id: '1',
    dateTime: DateTime(2022, 7, 10),
    text: 'A day when I went on a hike with my friend.',
    created: DateTime.now(),
    updated: DateTime.now(),
    personIdList: ['2'],
  ),
  '2': Event(
    id: '2',
    dateTime: DateTime(2022, 9, 15),
    text: 'A day when I had a BBQ with my friend.',
    created: DateTime.now(),
    updated: DateTime.now(),
    personIdList: ['2', '3', '4', '5'],
  ),
  '3': Event(
    id: '3',
    dateTime: DateTime(2022, 9, 5),
    text: 'A day when I went to the movies with my friend.',
    created: DateTime.now(),
    updated: DateTime.now(),
    personIdList: ['1', '2'],
  ),
  '4': Event(
    id: '4',
    dateTime: DateTime(2022, 10, 22),
    text: 'A day when I went to see the fall foliage with my friend.',
    created: DateTime.now(),
    updated: DateTime.now(),
    personIdList: ['0', '1', '2', '3', '4', '5'],
  ),
  '5': Event(
    id: '5',
    dateTime: DateTime(2022, 11, 11),
    text: 'A day when I went café hopping with my friend.',
    created: DateTime.now(),
    updated: DateTime.now(),
    personIdList: ['2', '3'],
  ),
  '6': Event(
    id: '6',
    dateTime: DateTime(2022, 12, 25),
    text: 'A day when I had a Christmas dinner with my friend.',
    created: DateTime.now(),
    updated: DateTime.now(),
    personIdList: ['0', '1', '2'],
  ),
  '7': Event(
    id: '7',
    dateTime: DateTime(2022),
    text: 'A day when I greeted the new year with my friend.',
    created: DateTime.now(),
    updated: DateTime.now(),
    personIdList: ['2', '5'],
  ),
};

class EventServiceTestImpl implements EventServiceAbstract {
  EventServiceTestImpl(String _);
  final eventMap = <String, Event>{...initData};
  @override
  Future<void> addEvent(Event event) async {
    eventMap.addEntries(
      {event.id: event.copyWith(id: (eventMap.length + 1).toString())}.entries,
    );
  }

  @override
  Future<List<Event>> getEventList() async => eventMap.values.toList();

  @override
  Future<void> removeEvent(String id) async {
    eventMap.remove(id);
  }

  @override
  Stream<List<Event>> watchEventList() =>
      Stream.value(eventMap.values.toList());

  @override
  Future<void> editEvent(Event event) async {
    eventMap.update(event.id, (value) => event);
  }

  @override
  Stream<List<Event>> watchEventListByPersonId(String personId) => Stream.value(
        eventMap.values
            .where((element) => (element.personIdList ?? []).contains(personId))
            .toList(),
      );
}
