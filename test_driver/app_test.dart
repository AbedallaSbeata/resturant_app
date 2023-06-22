import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/scaffolding.dart';

void main() {
  group("Flutter Restaurant App Test", () {
    final imageField = find.byValueKey("imageFood");
    final nameField = find.byValueKey("nameFood");
    final priceField = find.byValueKey("priceFood");
    final categoryField = find.byValueKey("categoryFood");
    final addButton = find.byValueKey("addFood");
    final managerPage = find.byType("ManagerPage");

    FlutterDriver? driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await driver!.waitUntilFirstFrameRasterized();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver!.close();
      }
    });

    test("add food", () async {
      await driver!.tap(imageField);
      await driver!.tap(nameField);
      await driver!.enterText("shoraba");
      await driver!.tap(priceField);
      await driver!.enterText("25");
      await driver!.tap(categoryField);
      await driver!.tap(addButton);
      await driver!.waitFor(managerPage);
      assert(managerPage != null);
      await driver!.waitUntilNoTransientCallbacks();
    });
  });
}
