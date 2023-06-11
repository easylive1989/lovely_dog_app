import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:lovely_dog_app/breed_list_page.dart';
import 'package:lovely_dog_app/dog_api.dart';
import 'package:lovely_dog_app/dog_image_page.dart';
import 'package:lovely_dog_app/main.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

main() {
  late MockClient mockClient;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    registerFallbackValue(MockRoute());
    mockClient = MockClient();
    mockNavigatorObserver = MockNavigatorObserver();
  });

  testWidgets('display breed list', (WidgetTester tester) async {
    givenBreedList(
      mockClient,
      breedList: '{"affenpinscher": [], "african": [], "airedale": []}',
    );

    await givenShowBreedListPage(tester, mockClient);

    expect(find.text("affenpinscher"), findsOneWidget);
    expect(find.text("african"), findsOneWidget);
    expect(find.text("airedale"), findsOneWidget);
  });

  testWidgets('should open dog image page when click breed tile',
      (tester) async {
    givenBreedList(
      mockClient,
      breedList: '{"affenpinscher": [], "african": [], "airedale": []}',
    );

    await givenShowBreedListPage(tester, mockClient, [mockNavigatorObserver]);

    await whenTap(tester, find.byType(ListTile).first);

    verify(() => mockNavigatorObserver.didPush(
        captureAny(that: RouteMatcher("/dog_image")), captureAny()));
  });

  testWidgets('should show image when open dog image page', (tester) async {
    mockNetworkImagesFor(() async {
      givenBreedList(
        mockClient,
        breedList: '{"affenpinscher": [], "african": [], "airedale": []}',
      );

      givenDogImage(mockClient, "african",
          "https://images.dog.ceo/breeds/bulldog-boston/n02096585_355.jpg");

      await givenShowMainApp(tester, mockClient);

      await whenTap(tester, find.byType(ListTile).at(1));

      expect(findNetworkImage(tester).url,
          "https://images.dog.ceo/breeds/bulldog-boston/n02096585_355.jpg");
    });
  });
}

Future<void> whenTap(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> givenShowBreedListPage(
  WidgetTester tester,
  MockClient mockClient, [
  List<NavigatorObserver> mockRouteObserver = const [],
]) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BreedListPage(dogApi: DogApi(client: mockClient)),
      navigatorObservers: mockRouteObserver,
      routes: {
        DogImagePage.routeName: (_) => const SizedBox(),
      },
    ),
  );
  await tester.pumpAndSettle();
}

NetworkImage findNetworkImage(WidgetTester tester) =>
    tester.widget<Image>(find.byType(Image)).image as NetworkImage;

void givenValidDogImage(MockClient mockClient) {
  givenDogImage(mockClient, "affenpinscher",
      "https://images.dog.ceo/breeds/bulldog-boston/n02096585_354.jpg");
}

void givenDogImage(MockClient mockClient, String breed, String dogImageUrl) {
  when(() => mockClient
          .get(Uri.parse("https://dog.ceo/api/breed/$breed/images/random")))
      .thenAnswer((_) async {
    return Response('{"message": \"$dogImageUrl\", "status": "success"}', 200);
  });
}

Future<void> givenShowMainApp(
  WidgetTester tester,
  MockClient mockClient,
) async {
  await tester.pumpWidget(
    MainApp(
      dogApi: DogApi(client: mockClient),
    ),
  );
  await tester.pumpAndSettle();
}

void givenBreedList(MockClient mockClient, {required String breedList}) {
  when(() => mockClient.get(Uri.parse("https://dog.ceo/api/breeds/list/all")))
      .thenAnswer((_) async {
    return Response('{"message": $breedList, "status": "success"}', 200);
  });
}

class RouteMatcher extends Matcher {
  final String routeName;

  RouteMatcher(this.routeName);

  @override
  Description describe(Description description) {
    return description.add('route name is $routeName');
  }

  @override
  bool matches(item, Map matchState) {
    return item.settings.name == routeName;
  }
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockClient extends Mock implements Client {}

class MockRoute extends Mock implements Route {}
