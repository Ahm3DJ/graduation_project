import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation_project2/Controller/Storage.dart';
import 'package:graduation_project2/model/Post.dart';
import 'package:graduation_project2/model/User.dart';
import 'package:graduation_project2/shared/showSnackBar.dart';
import 'package:uuid/uuid.dart';

class FireBase {
  Future<UserDete> getUserDetails() async {
    DocumentSnapshot<Map<String, dynamic>> snap = await FirebaseFirestore
        .instance
        .collection('userSSS')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();


    return UserDete.convertSnap2Model(snap);

  
  }

  Future<Map> getData({required context}) async {
    // Get data from DB
    Map userDate = {};

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('userSSS')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userDate = snapshot.data()!;

    } catch (e) {
      showSnackBar(context, "Error");
    }

    return userDate;
  }

  uploadPost({
    required imgName,
    required imgPath,
    required description,
    required profileImg,
    required username,
    required context,
    required quntity,
    required caption,
    required price,
    required title,
    required prodactName,
    required typeOfProdact,
    required phoneNumber,
  }) async {
    String message = "ERROR => Not starting the code";

    try {
// ______________________________________________________________________

      String urlll = await getImgURL(
          imgName: imgName,
          imgPath: imgPath,
          folderName: 'imgPosts/${FirebaseAuth.instance.currentUser!.uid}');

// _______________________________________________________________________
// firebase firestore (Database)
      CollectionReference posts =
          FirebaseFirestore.instance.collection('postSSS');

      String newId = const Uuid().v1();

      PostData postt = PostData(
          datePublished: DateTime.now(),
          description: description,
          imgPost: urlll,
          likes: [],
          profileImg: profileImg,
          postId: newId,
          uid: FirebaseAuth.instance.currentUser!.uid,
          username: username,
          quntity: quntity,
          caption: caption,
          price: price,
          title: title,
          prodactName: prodactName,
          typeOfProdact: typeOfProdact,
          phoneNumber: phoneNumber,
          Likes: []);

      message = "ERROR => erroe hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee";
      posts
          .doc(newId)
          .set(postt.convert2Map())
          .then((value) => print("done................"))
          .catchError((error) => print("Failed to post: $error"));

      message = " Posted successfully ♥ ♥";
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    } catch (e) {
      print(e);
    }

    showSnackBar(context, message);
  }

  Stream<QuerySnapshot<Object?>> getDataBasedTypeProdact(
      {required bool fruit, required bool vegetable, required bool another}) {
    String typeProdact = "";
    if (fruit) {
      typeProdact = "Fruits";
    } else if (vegetable) {
      typeProdact = "Vegetables";
    } else if (another) {
      typeProdact = "Other";
    } else {
      return FirebaseFirestore.instance
          .collection(
              'postSSS') //'uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid
          .snapshots();
    }

    return FirebaseFirestore.instance
        .collection('postSSS')
        .where("typeOfProdact", isEqualTo: typeProdact)
        .snapshots();
  }

  


}
