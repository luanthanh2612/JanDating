/*
This class defines all the possible read/write locations from the Firestore database.
In future, any new path can be added here.
This class work together with FirestoreService and FirestoreDatabase.
 */

class FirestorePath {
  static String users() => 'users';
  static String user(String uid) => 'users/$uid';
  static String likedBy(String uid) => 'users/$uid/selectedList';
  static String photo(String uid, int timestamp) =>
      'users/$uid/photos/$timestamp';
  static String photos(String uid) => 'users/$uid/photos';
  static String languages() => 'languages';
}
