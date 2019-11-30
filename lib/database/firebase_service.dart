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
    item.id = _id;
    _itemRef.child(_id).set(item.toJson());
    return _id;
  }

  /// Read Event
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

  /// Create Occurrence
  static Future<void> createOccurrence(Occurrence item) async {
    final _itemRef = _databaseRef.child(FirebaseConstant.occurrence);
    final _id = _itemRef.push().key;
    item.id = _id;
    _itemRef.child(_id).set(item.toJson());
  }

  /// Read Event
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

  /*
fun getDurationsByEventID(callback: FirebaseEventCallback, eventID: String) {
            val durations = mutableListOf<Duration>()
            val databaseReference = FirebaseDatabase.getInstance().reference
            val eventDuration = databaseReference
                .child(FirebaseConstant.NO.EVENT_DURATION)
                .child(eventID)

            eventDuration.addValueEventListener(object : ValueEventListener {
                override fun onCancelled(p0: DatabaseError) {}

                override fun onDataChange(snapShot: DataSnapshot) {
                    durations.clear()
                    for (d in snapShot.children) {
                        val duration = Duration(
                            d.getValue(Duration::class.java)!!.date,
                            d.getValue(Duration::class.java)!!.location,
                            d.getValue(Duration::class.java)!!.timeStart,
                            d.getValue(Duration::class.java)!!.timeEnd,
                            d.getValue(Duration::class.java)!!.qrCode
                        )
                        duration.id = d.key!!
                        durations.add(duration)
                    }
                    callback.onCallBack(durations)
                }
            })
        }
  */

  /// Create Occurrence
  static Future<void> createEventOccurrences(
      String eventId, List<Occurrence> occurrences) async {
    final _itemRef =
        _databaseRef.child(FirebaseConstant.eventOccurrences).child(eventId);
    occurrences.forEach((item) {
      final occurrenceId = _itemRef.push().key;
      _itemRef.child(occurrenceId).set(item.toJson());
    });
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
