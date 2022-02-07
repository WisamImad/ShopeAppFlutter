import 'package:flutter/material.dart';
import 'package:learn_section8/modules/login/login_screen.dart';
import 'package:learn_section8/shared/network/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel(this.image, this.title, this.body);
}

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  bool isLast = false;
  bool x = true;

  void submit(){
    print('Welcome');
    CacheHelper.saveData2(
        key: 'onBoarding',
        value: true
    ).then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
    });
  }

  List<BoardingModel> boarding = [
    BoardingModel(
        "assets/images/image_store1.png", "Title Page 1", "Body Page 1"),
    BoardingModel(
        "assets/images/image_store2.png", "Title Page 2", "Body Page 2"),
    BoardingModel(
        "assets/images/image_store3.png", "Title Page 3", "Body Page 3"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  submit();
                },
                child: Text(
                  'SKIP',style: TextStyle(color: Colors.orange,fontWeight: FontWeight.w900),
                ),
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (int index) {
                    if (index == boarding.length - 1) {
                      setState(() {
                        isLast = true;
                      });
                      print('isLAst');
                    } else {
                      setState(() {
                        isLast = false;
                      });
                      print("nit Last");
                    }
                  },
                  physics: BouncingScrollPhysics(),
                  controller: boardController,
                  itemBuilder: (context, index) =>
                      builderPageView(boarding[index]),
                  itemCount: boarding.length,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                children: [
                  SmoothPageIndicator(
                      controller: boardController,
                      count: boarding.length,
                      effect: ExpandingDotsEffect(
                          dotColor: Colors.grey,
                          activeDotColor: Colors.orange,
                          dotHeight: 10,
                          expansionFactor: 4,
                          dotWidth: 10,
                          spacing: 5.0)),
                  Spacer(),
                  FloatingActionButton(
                    onPressed: () {
                      if (isLast) {
                        submit();
                      } else {
                        boardController.nextPage(
                            duration: Duration(milliseconds: 750),
                            curve: Curves.easeInToLinear);
                      }
                    },
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

Widget builderPageView(BoardingModel model) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Image(image: AssetImage("${model.image}"))),
        SizedBox(
          height: 40,
        ),
        Text(
          "${model.title}",
          style: TextStyle(fontSize: 25.0),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          "${model.body}",
          style: TextStyle(fontSize: 14),
        )
      ],
    );
