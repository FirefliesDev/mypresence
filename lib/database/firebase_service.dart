import 'package:firebase_database/firebase_database.dart';
import 'package:mypresence/model/event.dart' as model;
import 'package:mypresence/model/item.dart';
import 'package:mypresence/model/occurrence.dart';
import 'package:mypresence/utils/constants.dart';

/// Stores all the custom colors used in this application
class FirebaseService {
  static var _databaseRef = FirebaseDatabase.instance.reference();

  /// Create Event
  static Future<String> createEvent(model.Event item) async {
    final _itemRef = _databaseRef.child(FirebaseConstant.event);
    final _id = _itemRef.push().key;

    _itemRef.child(_id).set(item.toJson());
    return _id;
  }

  /// Create Occurrence
  static Future<void> createOccurrence(Occurrence item) async {
    final _itemRef = _databaseRef.child(FirebaseConstant.occurrence);
    final _id = _itemRef.push().key;

    _itemRef.child(_id).set(item.toJson());
  }

  /// Create Occurrence
  static Future<void> createEventOccurrences(
      String eventId, List<Occurrence> occurrences) async {
    final _itemRef =
        _databaseRef.child(FirebaseConstant.eventOccurrences).child(eventId);

    print('Before forEach');
    occurrences.forEach((item) {
      final occurrenceId = _itemRef.push().key;
      _itemRef.child(occurrenceId).set(item.toJson());
    });
    print(occurrences.length);
    print('After forEach');

    // final _id = _itemRef.push().key;

    // _itemRef.child(_id).set(item.toJson());

    /*
  val eventDurationReference = databaseReference
                .child(FirebaseConstant.NO.EVENT_DURATION)
                .child(eventID)

            for (duration in durations) {
                val durationID = eventDurationReference.push().key
                val durationPresenceReference = databaseReference
                    .child(FirebaseConstant.NO.DURATION_PRESENCE)
                    .child(durationID!!)

                eventDurationReference
                    .child(durationID)
                    .setValue(duration)

                for (user in users) {
                    val newRef = durationPresenceReference.child(user.id)
                    newRef.child("name").setValue(user.name)
                    newRef.child("lastName").setValue(user.lastName)
                    newRef.child("present").setValue(false)
                }
            }
    */
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
