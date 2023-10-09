import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronapp/Model/item.dart';

class ConvenienceService {
  final CollectionReference convenienceCollection =
      FirebaseFirestore.instance.collection('convenience');

  void addMenu(Item item) {
    convenienceCollection.doc('cu').update({
      'items': FieldValue.arrayUnion([item.toMap()])
    });
  }

  Future<List<Item>> getMenus() async {
    try {
      DocumentSnapshot snapshot = await convenienceCollection.doc('cu').get();
      print(snapshot);
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        List<Map<String, dynamic>> json =
            (data['items'] as List<dynamic>).cast<Map<String, dynamic>>();
        print(json);
        List<Item> items = [];
        for (int i = 0; i < json.length; i++) {
          items.add(Item.fromMap(json[i]));
        }
        return items;
      }
    } catch (e) {
      print(e);
      return [];
    }
    return [];
  }
}
