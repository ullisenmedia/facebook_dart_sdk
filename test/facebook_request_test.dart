import 'dart:html';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import '../lib/facebook.dart';
import 'my_graph_post.dart';

void main() {

  useHtmlConfiguration();

  var accessToken = 'CAACEdEose0cBANx8GDRS0NOxkO3nZCmkAZAlaeCEzqeSXEhLyS8h7lgXGcCKrwWhjtQFQv95b07u2pUNOHyV202w6bjgkYhFovdWCD9V0HM4jGYBAuRmhptRKguuiBk5Mxa7RxXlJ5OficBafT2ZARZCladhOKDnZAyxDuvBj5nblXQ24buRowIpNn0VQu2qWXZBw5529bbGd51UD35DQGifNbPwMSgV4ZD';
  var appId = '1457108374569654';
  var appSecret = 'c99f5f0727b5314b4b4bf8fd79c3a54c';

  FacebookRequest.client = new BrowserClient();
  FacebookSession.setDefaultApplication(appId, appSecret);

  var session = new FacebookSession(accessToken);

  test('test new me requests', () {

      FacebookRequest.newMeRequest(session)
        .then(expectAsync((graphUser) {

          print(graphUser.name);

          expect(graphUser is GraphUser, isTrue);
          expect(graphUser.name != null, isTrue);

        }));

      FacebookRequest.newMyFriendRequest(session)
      .then(expectAsync((graphFriends) {

        expect(graphFriends is GraphObjectList, isTrue);
      }));

  });

  test('test new post request', () {

    var myGraphPost = new MyGraphPost();
    myGraphPost.message = "My graph post";

    FacebookRequest.newPostRequest(session, 'me/feed', myGraphPost)
      .then(expectAsync((res) {

        print(res);

        expect(res != null, isTrue);

      }));

  });
}