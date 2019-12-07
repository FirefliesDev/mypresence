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

  /// Get Events
  static Future<model.Event> getEventById(String eventId) async {
    model.Event event;
    final _itemRef = _databaseRef.child(FirebaseConstant.event);
    await _itemRef.once().then((DataSnapshot snapshot) {
      final value = snapshot.value as Map;
      for (final key in value.keys) {
        if (key == eventId) {
          event = model.Event.fromJson(snapshot.value[key]);
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
    print('ID OCURRENCE QR CODE: => ' + occurrenceId);
    final _itemRef =
        _databaseRef.child(FirebaseConstant.eventOccurrences).child(eventId);
    await _itemRef.once().then((DataSnapshot snapshot) {
      final value = snapshot.value as Map;
      for (final key in value.keys) {
        // occurrence = model.Event.fromJson(snapshot.value[key]);

        if (key == occurrenceId) {
          print('KEY ' + key);
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
      for (final key in value.keys) {
        User u = User.fromJson(snapshot.value[key]);
        items.add(u);
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

    print('UserID: $userId');
    print('UserID: ${occurrence.date}');
    print('UserID: ${occurrence.id}');

    _itemRef.set(occurrence.toJson());
  }

  static Stream<Event> getOccurrencesGroupByDate(String userId) {
    final _itemRef = _databaseRef
        .child(FirebaseConstant.occurrencesGroupByDate)
        .child(userId);
    return _itemRef.onValue;
  }

  /// Create EventParticipants
  static Future<void> createEventParticipants(String eventId, User user) async {
    final _itemRef =
        _databaseRef.child(FirebaseConstant.eventParticipants).child(eventId);
    _itemRef.child(user.id).set(user.toJson());
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
