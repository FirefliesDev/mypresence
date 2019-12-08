import 'package:firebase_database/firebase_database.dart';
import 'package:mypresence/model/event.dart' as model;
import 'package:mypresence/model/item.dart';
import 'package:mypresence/model/occurrence.dart';
import 'package:mypresence/model/user.dart';
import 'package:mypresence/utils/constants.dart';

class FirebaseService {
  static var _databaseRef = FirebaseDatabase.instance.reference();

  /// Create Event
  static Future<String> createEvent(model.Event item) async {
    final _itemRef = _databaseRef.child(FirebaseConstant.event);
    final _id = _itemRef.push().key;
    item.id = _id;
    _itemRef.child(_id).set(item.toJson());
    return _id;
  }

  /// Get Events
  static Future<List<model.Event>> getEvents() async {
    List<model.Event> items = [];
    final _itemRef = _databaseRef.child(FirebaseConstant.event);
    await _itemRef.once().then((DataSnapshot snapshot) {
      final value = snapshot.value as Map;
      for (final key in value.keys) {
        model.Event i = model.Event.fromJson(snapshot.value[key]);
        items.add(i);
      }
      print(items.toString());
    });
    return items;
  }

  /// Get Users
  static Future<List<User>> getUsers() async {
    List<User> items = [];
    final _itemRef = _databaseRef.child(FirebaseConstant.user);
    await _itemRef.once().then((DataSnapshot snapshot) {
      final value = snapshot.value as Map;
      for (final key in value.keys) {
        User i = User.fromJson(snapshot.value[key]);
        items.add(i);
      }
      print(items.toString());
    });
    return items;
  }

  /// Get Events
  static Future<model.Event> getEventById(String eventId) async {
    model.Event event;
    final _itemRef = _databaseRef.child(FirebaseConstant.event);
    await _itemRef.once().then((DataSnapshot snapshot) {
      final value = snapshot.value as Map;
      for (final key in value.keys) {
        if (key == eventId) {
          var parsed = snapshot.value[key] as Map<dynamic, dynamic>;
          parsed['count_participants'] = parsed['count_participants'];
          event = model.Event.fromJson(parsed);
          break;
        }
      }
    });
    return event;
  }

  /// Get Occurrence
  static Future<Occurrence> getOccurrenceById(
      String eventId, String occurrenceId) async {
    Occurrence occurrence;
    final _itemRef =
        _databaseRef.child(FirebaseConstant.eventOccurrences).child(eventId);
    await _itemRef.once().then((DataSnapshot snapshot) {
      final value = snapshot.value as Map;
      for (final key in value.keys) {
        // occurrence = model.Event.fromJson(snapshot.value[key]);
        if (key == occurrenceId) {
          occurrence = Occurrence.fromJson(snapshot.value[key]);
          break;
        }
      }
    });
    return occurrence;
  }

  /// Get Events
  static Future<List<model.Event>> getEventsByOwner(String userId) async {
    List<model.Event> items = [];

    final _itemRef =
        _databaseRef.child(FirebaseConstant.ownerEvents).child(userId);

    print('FLAMENGO N E TIME');

    await _itemRef.once().then((DataSnapshot snapshot) {
      final value = snapshot.value as Map;

      for (final key in value.keys) {
        snapshot.value[key]['count_participants'] =
            snapshot.value[key]['count_participants'].toString();
        model.Event i = model.Event.fromJson(snapshot.value[key]);
        items.add(i);
      }
    });

    return items;
  }

  /// Create Occurrence
  static Future<void> createOccurrence(Occurrence item) async {
    final _itemRef = _databaseRef.child(FirebaseConstant.occurrence);
    final _id = _itemRef.push().key;
    item.id = _id;
    _itemRef.child(_id).set(item.toJson());
  }

  /// Get Event's Occurrences
  static Future<List<Occurrence>> getEventOccurrences(String eventId) async {
    List<Occurrence> items = [];
    final _itemRef =
        _databaseRef.child(FirebaseConstant.eventOccurrences).child(eventId);
    await _itemRef.once().then((DataSnapshot snapshot) {
      final value = snapshot.value as Map;
      for (final key in value.keys) {
        Occurrence i = Occurrence.fromJson(snapshot.value[key]);
        items.add(i);
        print(i.toJson());
      }
      print(items.toString());
    });
    return items;
  }

  /// Get Event's Participants
  static Future<List<User>> getEventParticipants(String eventId) async {
    List<User> items = [];
    final _itemRef =
        _databaseRef.child(FirebaseConstant.eventParticipants).child(eventId);
    await _itemRef.once().then((DataSnapshot snapshot) {
      final value = snapshot.value as Map;
      if (value != null) {
        for (final key in value.keys) {
          User u = User.fromJson(snapshot.value[key]);
          items.add(u);
        }
      }
    });
    return items;
  }

  /// Get Event's Occurrences
  static Future<List<Occurrence>> getChildrenGroupBy(
      String userId, String key) async {
    List<Occurrence> items = [];
    final _itemRef = _databaseRef
        .child(FirebaseConstant.occurrencesGroupByDate)
        .child(userId)
        .child(key);
    await _itemRef.once().then((DataSnapshot snapshot) {
      final value = snapshot.value as Map;
      for (final key in value.keys) {
        Occurrence i = Occurrence.fromJson(snapshot.value[key]);
        items.add(i);
        print(i.toJson());
      }
      print(items.toString());
    });
    return items;
  }

  /// Update Occurrence
  static Future<void> updateEventOccurrence(
      String eventId, Occurrence item) async {
    final _itemRef = _databaseRef
        .child(FirebaseConstant.eventOccurrences)
        .child(eventId)
        .child(item.id);
    // Map<String, dynamic> newValue = item.toJson();
    _itemRef.update(item.toJson().cast<String, dynamic>());
  }

  /// Create EventOccurrence
  static Future<void> createEventOccurrences(
      model.Event event, List<Occurrence> occurrences) async {
    final _itemRef =
        _databaseRef.child(FirebaseConstant.eventOccurrences).child(event.id);
    //
    // final _groupByRef =
    //     _databaseRef.child(FirebaseConstant.eventsByDate).child(userId);
    occurrences.forEach((item) {
      final occurrenceId = _itemRef.push().key;
      item.id = occurrenceId;
      _itemRef.child(occurrenceId).set(item.toJson());

      // TODO: Insert events_by_date
      // _groupByRef.child(item.date).child(event.id).set(item.toJson());
    });
  }

  /// Create EventOccurrence
  static Future<void> createOccurrenceGroupByDate(
      String userId, Occurrence occurrence) async {
    final _itemRef = _databaseRef
        .child(FirebaseConstant.occurrencesGroupByDate)
        .child(userId)
        .child(occurrence.date)
        .child(occurrence.id);
    _itemRef.set(occurrence.toJson());
  }

  static Stream<Event> getOccurrencesGroupByDate(String userId) {
    final _itemRef = _databaseRef
        .child(FirebaseConstant.occurrencesGroupByDate)
        .child(userId);
    return _itemRef.onValue;
  }

  /// WORKING ON THIS
  static Future<void> updateOccurrencesGroupByDate(String eventId) async {
    final _itemRef =
        _databaseRef.child(FirebaseConstant.occurrencesGroupByDate);
    await _itemRef.once().then((DataSnapshot snapshot) {
      final value = snapshot.value as Map;
      value.forEach((k, v) {
        print('K: $k');
        // var _ref = _databaseRef.child(FirebaseConstant.occurrencesGroupByDate).child(k).child(path);
        print('V: $v');
        final date = v as Map;
        // teste
      });
    });
  }

  /// Create EventParticipants
  static Future<void> createEventParticipants(
      model.Event item, User user) async {
    List<User> participants = await getEventParticipants(item.id);
    bool exist = false;

    for (var i in participants) {
      if (i.id == user.id) {
        exist = true;
        break;
      }
    }

    if (!exist) {
      var event = await getEventById(item.id);
      final _eventRef =
          _databaseRef.child(FirebaseConstant.event).child(item.id);

      final _ownerRef = _databaseRef
          .child(FirebaseConstant.ownerEvents)
          .child(item.ownerId)
          .child(item.id);

      int count = int.parse(event.countParticipants) + 1;
      _eventRef.child("count_participants").set(count.toString());
      _ownerRef.child("count_participants").set(count.toString());

      final _itemRef =
          _databaseRef.child(FirebaseConstant.eventParticipants).child(item.id);
      _itemRef.child(user.id).set(user.toJson());
    }
  }

  /// Create EventParticipants
  static Future<void> createParticipantEvents(
      String userId, model.Event item) async {
    final _itemRef =
        _databaseRef.child(FirebaseConstant.participantEvents).child(userId);
    _itemRef.child(item.id).set(item.toJson());
  }

  /// Create ownerEvents
  static Future<void> createOwnerEvents(String userId, model.Event item) async {
    final _itemRef =
        _databaseRef.child(FirebaseConstant.ownerEvents).child(userId);
    _itemRef.child(item.id).set(item.toJson());
  }

  /// Create User
  static Future<void> createUser(User item) async {
    final _itemRef = _databaseRef.child(FirebaseConstant.user);
    // final _id = _itemRef.push().key;
    // item.id = _id;
    _itemRef.child(item.id).set(item.toJson());
  }

  ///
  static Future<void> create(Item item) async {
    final _itemRef = _databaseRef.child(FirebaseConstant.item);
    final _id = _itemRef.push().key;

    _itemRef.child(_id).set(item.toJson());
  }

  ///
  static Future<List<Item>> read() async {
    List<Item> items = [];
    final _itemRef = _databaseRef.child(FirebaseConstant.item);
    await _itemRef.once().then((DataSnapshot snapshot) {
      final value = snapshot.value as Map;
      for (final key in value.keys) {
        Item i = Item.fromJson(snapshot.value[key]);
        items.add(i);
      }
      print(items.toString());
    });
    return items;
  }

  ///
  static Future<void> update(Item item) async {
    final _itemRef = _databaseRef.child(FirebaseConstant.item);
    _itemRef.child(item.id).update(item.toJson());
  }

  ///
  static Future<void> delete(String id) async {
    final _itemRef = _databaseRef.child(FirebaseConstant.item);
    _itemRef.child(id).remove();
  }

  ///
  static Future<void> resetDatabase() async {
    final _eventRef = _databaseRef.child(FirebaseConstant.event);
    _eventRef.remove();

    final _eventOcurrenceRef =
        _databaseRef.child(FirebaseConstant.eventOccurrences);
    _eventOcurrenceRef.remove();

    final _eventPartRef =
        _databaseRef.child(FirebaseConstant.eventParticipants);
    _eventPartRef.remove();

    final _groupByDate =
        _databaseRef.child(FirebaseConstant.occurrencesGroupByDate);
    _groupByDate.remove();

    final _ownerEventRef = _databaseRef.child(FirebaseConstant.ownerEvents);
    _ownerEventRef.remove();

    final partEventRef = _databaseRef.child(FirebaseConstant.participantEvents);
    partEventRef.remove();
  }
}
