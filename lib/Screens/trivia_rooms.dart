import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:card_swiper/card_swiper.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class TriviaRooms extends StatelessWidget {
  TriviaRooms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Trivia Rooms"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Headline',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 200.0,
              child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.secondary,
                        child: const SizedBox(
                          width: 300,
                          height: 100,
                          child: Center(child: Text('Filled Card')),
                        ),
                      );
                    },

                    //indicatorLayout: PageIndicatorLayout.COLOR,
                    autoplay: MediaQuery.of(context).size.height >
                        MediaQuery.of(context).size.width,
                    viewportFraction: MediaQuery.of(context).size.height >
                            MediaQuery.of(context).size.width
                        ? 1
                        : 0.3,
                    itemCount: 10,
                    pagination: new SwiperPagination(),
                    control: new SwiperControl(),
                  )),
            ),
            Text(
              'Demo Headline 2',
              style: TextStyle(fontSize: 18),
            ),
            Card(
              child: ListTile(
                  title: Text('Motivation $int'),
                  subtitle: Text('this is a description of the motivation')),
            ),
            Card(
              child: ListTile(
                  title: Text('Motivation $int'),
                  subtitle: Text('this is a description of the motivation')),
            ),
            Card(
              child: ListTile(
                  title: Text('Motivation $int'),
                  subtitle: Text('this is a description of the motivation')),
            ),
            Card(
              child: ListTile(
                  title: Text('Motivation $int'),
                  subtitle: Text('this is a description of the motivation')),
            ),
            Card(
              child: ListTile(
                  title: Text('Motivation $int'),
                  subtitle: Text('this is a description of the motivation')),
            ),
          ],
        ),
      ),
    );
  }
}
