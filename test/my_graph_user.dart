import '../lib/facebook.dart';
import 'my_graph_language.dart';

class MyGraphUser extends GraphUser {

  // Create a setter to enable easy extraction of the languages field
  GraphObjectList<MyGraphLanguage> get languages;
}