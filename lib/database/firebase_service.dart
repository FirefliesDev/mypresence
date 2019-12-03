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
        event = model.Event.fromJson(snapshot.value[key]);
        break;
      }
    });
    return event;
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
      String eventId, List<Occurrence> occurrences) async {
    final _itemRef =
        _databaseRef.child(FirebaseConstant.eventOccurrences).child(eventId);
    occurrences.forEach((item) {
      final occurrenceId = _itemRef.push().key;
      item.id = occurrenceId;
      _itemRef.child(occurrenceId).set(item.toJson());
    });
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
}
