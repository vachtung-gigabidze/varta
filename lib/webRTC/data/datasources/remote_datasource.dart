import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String _roomsCollection = 'rooms';
  static const String _candidatesCollection = 'candidates';
  static const String _candidateUidField = 'uid';

  String? userId;

  Future<String> createRoom({required RTCSessionDescription offer}) async {
    final DocumentReference<Map<String, dynamic>> roomRef =
        _db.collection(_roomsCollection).doc();
    final Map<String, dynamic> roomWithOffer = <String, dynamic>{
      'offer': offer.toMap()
    };

    await roomRef.set(roomWithOffer);
    return roomRef.id;
  }

  Future<void> deleteRoom({required String roomId}) =>
      _db.collection(_roomsCollection).doc(roomId).delete();

  Future<void> setAnswer({
    required String roomId,
    required RTCSessionDescription answer,
  }) async {
    final DocumentReference<Map<String, dynamic>> roomRef =
        _db.collection(_roomsCollection).doc(roomId);
    final Map<String, dynamic> roomWithAnswer = <String, dynamic>{
      'answer': {'type': answer.type, 'sdp': answer.sdp}
    };
    await roomRef.update(roomWithAnswer);
  }

  Future<RTCSessionDescription?> getRoomOfferIfExists(
      {required String roomId}) async {
    final DocumentSnapshot<Map<String, dynamic>> roomDoc =
        await _db.collection(_roomsCollection).doc(roomId).get();
    if (!roomDoc.exists) {
      return null;
    } else {
      final Map<String, dynamic> data = roomDoc.data() as Map<String, dynamic>;
      final Map<String, dynamic> offer = data['offer'] as Map<String, dynamic>;
      return RTCSessionDescription(
          offer['sdp'].toString(), offer['type'].toString());
    }
  }

  Stream<RTCSessionDescription?> getRoomDataStream({required String roomId}) {
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        _db.collection(_roomsCollection).doc(roomId).snapshots();
    final Stream<Map<String, dynamic>?> filteredStream = snapshots.map(
        (DocumentSnapshot<Map<String, dynamic>> snapshot) => snapshot.data());
    return filteredStream.map(
      (Map<String, dynamic>? data) {
        if (data != null && data['answer'] != null) {
          return RTCSessionDescription(
            data['answer']['sdp'].toString(),
            data['answer']['type'].toString(),
          );
        } else {
          return null;
        }
      },
    );
  }

  Stream<List<RTCIceCandidate>> getCandidatesAddedToRoomStream({
    required String roomId,
    required bool listenCaller,
  }) {
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots = _db
        .collection(_roomsCollection)
        .doc(roomId)
        .collection(_candidatesCollection)
        .where(_candidateUidField, isNotEqualTo: userId)
        .snapshots();

    final Stream<List<RTCIceCandidate>> convertedStream = snapshots.map(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
        final Iterable<DocumentChange<Map<String, dynamic>>> docChangesList =
            listenCaller
                ? snapshot.docChanges
                : snapshot.docChanges.where(
                    (DocumentChange<Map<String, dynamic>> change) =>
                        change.type == DocumentChangeType.added);
        return docChangesList
            .map((DocumentChange<Map<String, dynamic>> change) {
          final Map<String, dynamic> data =
              change.doc.data() as Map<String, dynamic>;
          return RTCIceCandidate(
            data['candidate'].toString(),
            data['sdpMid'].toString(),
            data['sdpMLineIndex'] as int?,
          );
        }).toList();
      },
    );

    return convertedStream;
  }

  Future<void> addCandidateToRoom({
    required String roomId,
    required RTCIceCandidate candidate,
  }) async {
    final DocumentReference<Map<String, dynamic>> roomRef =
        _db.collection(_roomsCollection).doc(roomId);
    final CollectionReference<Map<String, dynamic>> candidatesCollection =
        roomRef.collection(_candidatesCollection);
    await candidatesCollection.add(
      (candidate.toMap()..[_candidateUidField] = userId)
          as Map<String, dynamic>,
    );
  }
}
