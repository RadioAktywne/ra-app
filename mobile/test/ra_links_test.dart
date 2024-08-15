import 'package:flutter_test/flutter_test.dart';
import 'package:radioaktywne/resources/ra_links.dart';

void main() {
  test("Correct path to RA API's posts", () {
    expect(
      Uri.https(RaLinks.radioAktywne, RaLinks.api.posts),
      Uri.parse('https://radioaktywne.pl/wp-json/wp/v2/posts'),
    );
  });

  test("Correct path to RA's radio player", () {
    expect(
      Uri.https(RaLinks.radioPlayerBase, RaLinks.radioPlayer.radioStream),
      Uri.parse('https://listen.radioaktywne.pl:${RaLinks.playerPort}/raogg'),
    );
  });

  test("Correct path to RA API's album; hard query params", () {
    expect(
      Uri.https(
        RaLinks.radioAktywne,
        RaLinks.api.album,
        {
          '_embed': true.toString(),
          'page': 5.toString(),
          'per_page': 15.toString(),
        },
      ),
      Uri.parse(
        'https://radioaktywne.pl/wp-json/wp/v2/album?_embed=true&page=5&per_page=15',
      ),
    );
  });
}
