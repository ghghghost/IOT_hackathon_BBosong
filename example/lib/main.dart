import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:async';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';


enum Options { none, image, frame, tesseract, vision }

late List<CameraDescription> cameras;
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Options option = Options.none;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    const title = 'BBosong';
    List<IconData> _icons = [
      Icons.loyalty,
      Icons.kitchen,
      Icons.local_laundry_service,
      Icons.perm_device_information,
    ];
    List<String> _string = [
      '태그 인식',
      '옷장',
      '세탁',
      '공지사항',
    ];
    List<Widget> _widget = [
      YoloVideo(),
      Closet(),
      Laundry(),
      YoloVideo(),
    ];

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
          backgroundColor: Colors.black,
        ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(4, (index) {
            return Center(
                child: Card(
                  elevation: 4, // 카드의 그림자를 표시하여 테두리 효과를 줍니다.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 카드의 모서리를 둥글게 만듭니다.
                    side: BorderSide(color: Colors.black, width: 2), // 카드의 테두리 속성을 설정합니다.
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => _widget[index]),
                          );
                        },
                        icon: Icon(
                          _icons[index], // 아이콘 종류를 변경할 수 있습니다.
                          color: Colors.black, // 아이콘 색상을 변경할 수 있습니다.
                          size: 80.0, // 아이콘 크기를 변경할 수 있습니다.
                        ),
                        iconSize: 100,
                      ),
                      SizedBox(height: 1),
                      Text(
                        _string[index], // 원하는 글씨를 넣으세요.
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
            );
          }),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: task(option),
  //     floatingActionButton: SpeedDial(
  //       //margin bottom
  //       icon: Icons.menu, //icon on Floating action button
  //       activeIcon: Icons.close, //icon when menu is expanded on button
  //       backgroundColor: Colors.black12, //background color of button
  //       foregroundColor: Colors.white, //font color, icon color in button
  //       activeBackgroundColor:
  //           Colors.deepPurpleAccent, //background color when menu is expanded
  //       activeForegroundColor: Colors.white,
  //       visible: true,
  //       closeManually: false,
  //       curve: Curves.bounceIn,
  //       overlayColor: Colors.black,
  //       overlayOpacity: 0.5,
  //       buttonSize: const Size(56.0, 56.0),
  //       children: [
  //         SpeedDialChild(
  //           //speed dial child
  //           child: const Icon(Icons.video_call),
  //           backgroundColor: Colors.red,
  //           foregroundColor: Colors.white,
  //           label: 'Yolo on Frame',
  //           labelStyle: const TextStyle(fontSize: 18.0),
  //           onTap: () {
  //             setState(() {
  //               option = Options.frame;
  //             });
  //           },
  //         ),
  //         SpeedDialChild(
  //           child: const Icon(Icons.camera),
  //           backgroundColor: Colors.blue,
  //           foregroundColor: Colors.white,
  //           label: 'Yolo on Image',
  //           labelStyle: const TextStyle(fontSize: 18.0),
  //           onTap: () {
  //             setState(() {
  //               option = Options.image;
  //             });
  //           },
  //         ),
  //         SpeedDialChild(
  //           child: const Icon(Icons.text_snippet_outlined),
  //           foregroundColor: Colors.white,
  //           backgroundColor: Colors.green,
  //           label: 'Tesseract',
  //           labelStyle: const TextStyle(fontSize: 18.0),
  //           onTap: () {
  //             setState(() {
  //               option = Options.tesseract;
  //             });
  //           },
  //         ),
  //
  //         // SpeedDialChild(
  //         //   child: const Icon(Icons.document_scanner),
  //         //   foregroundColor: Colors.white,
  //         //   backgroundColor: Colors.green,
  //         //   label: 'Vision',
  //         //   labelStyle: const TextStyle(fontSize: 18.0),
  //         //   onTap: () {
  //         //     setState(() {
  //         //       option = Options.vision;
  //         //     });
  //         //   },
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  Widget task(Options option) {
    if (option == Options.frame) {
      return YoloVideo();
    }
    return const Center(child: Text("Choose Task"));
  }
}


//yolo sect
class YoloVideo extends StatefulWidget {
  YoloVideo({Key? key}) : super(key: key);

  @override
  State<YoloVideo> createState() => _YoloVideoState();

}
XFile? capturedImage;
class _YoloVideoState extends State<YoloVideo> {

  late CameraController controller;
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;
  Map<String, dynamic> originalList = {
    'cl': 1,
    'cl_no': 2,
    'cl_o_no': 3,
    'dry': 4,
    'dry_no': 5,
    'dry_oil': 6,
    'dryer': 7,
    'dryer_no': 8,
    'hand': 9,
    'hand_no': 10,
    'hanger': 11,
    'hanger_shade': 12,
    'iron_140': 13,
    'iron_140_cloth': 14,
    'iron_180': 15,
    'iron_80': 16,
    'iron_80_cloth': 17,
    'iron_no': 18,
    'lay_shade': 19,
    'o': 20,
    'o_no': 21,
    'error': 22,
    'error': 23,
    'water_30': 24,
    'water_30_hand': 25,
    'water_30_weak': 26,
    'water_40': 27,
    'water_40_weak': 28,
    'water_60': 29,
    'water_95': 30,
    'water_no': 31,
  };
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    init();
    print('hi');
  }

  init() async {
    cameras = await availableCameras();
    vision = FlutterVision();
    controller = CameraController(cameras[0], ResolutionPreset.low);
    controller.initialize().then((value) {
      loadYoloModel().then((value) {
        setState(() {
          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
        });
      });
    });
  }



  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Scaffold(
        body: yoloResults.isEmpty || isDetecting
            ? Stack(
          fit: StackFit.expand,
          children: [
            AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(
                controller,
              ),
            ),
            ...displayBoxesAroundRecognizedObjects(size),
            Positioned(
              bottom: 75,
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 5, color: Colors.white, style: BorderStyle.solid),
                ),
                child: isDetecting
                    ? IconButton(
                  onPressed: () async {
                    stopDetection();
                  },
                  icon: const Icon(
                    Icons.stop,
                    color: Colors.red,
                  ),
                  iconSize: 50,
                )
                    : IconButton(
                  onPressed: () async {
                    await startDetection();
                  },
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                  iconSize: 50,
                ),
              ),
            ),
          ],
        )
            : ListView.builder(
            shrinkWrap: true,
            itemCount: yoloResults.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> result = yoloResults[index];
              if(index == yoloResults.length-1) {
                return Card(
                  child: Column(
                    children: [
                      Text(
                        result['tag'].toString().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Image(
                        image: AssetImage(
                          'assets/' + originalList[result['tag'].toString()].toString() + '.jpg',
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextButton(onPressed: captureAndSavePhoto, child: Text(
                        "옷장에 저장하기",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                    ],
                  ),
                );
              }
              else {
                return Card(
                  child: Column(
                    children: [
                      Text(
                        result['tag'].toString().toUpperCase(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Image(
                        image: AssetImage(
                          'assets/' + originalList[result['tag'].toString()]
                              .toString() + '.jpg',
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                );
              }
            }
        )
    );
  }

  Future<void> captureAndSavePhoto() async {
    capturedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (capturedImage != null) {
      // 촬영한 사진을 저장할 디렉토리를 가져옵니다.
      Directory directory = await getApplicationDocumentsDirectory();
      String documentsPath = directory.path;
      String imagePath = '$documentsPath/my_image.jpg';


      // 촬영한 사진을 지정된 경로로 복사합니다.


      // imagePath를 사용하여 촬영한 사진을 표시하거나 다른 작업을 수행할 수 있습니다.
      print('촬영한 사진이 저장되었습니다: $imagePath');
    }
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/yolov5n.tflite',
        modelVersion: "yolov5",
        numThreads: 2,
        useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.4,
        confThreshold: 0.4,
        classThreshold: 0.5);
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        yoloOnFrame(image);
      }
    });
  }

  Future<void> stopDetection() async {
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          // child: Text(
          //   "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
          //   style: TextStyle(
          //     background: Paint()..color = colorPick,
          //     color: Colors.white,
          //     fontSize: 18.0,
          //   ),
          //),
        ),
      );
    }).toList();
  }
}


//closet sect
class Closet extends StatefulWidget {
  const Closet({Key? key}) : super(key: key);

  @override
  State<Closet> createState() => _ClosetState();
}

class _ClosetState extends State<Closet> {
  String imagePath = '';
  Options option = Options.none;
  List<Image> _imagePaths = [Image.asset('assets/cloth.jpg'), Image.file(File(capturedImage!.path))];

  void _showImageDescriptionDialog(String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Image Description'),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    const title = 'Closet';
    List<String> desc =[
    '<누렇게 된 흰색 면 티셔츠 세탁하는 방법>\n준비물 : 50~60도 정도의 온수 / 중성세제\n1. 온수에 중성세제를 넣고 녹여줍니다\n2. 흰색면티를 넣고 약 10시간에서 1일정도 넣어둡니다\n3. 세탁기에서 헹굼탈수만 헹굼 탈수를 해줍니다.',
    '<집에서 드라이클리닝 하는 방법>\n1. 드라이클리닝 세제(유기용제)를 준비한다.\n2. 저온의 물에 홈 드라이클리닝 전용세제를 희석한다.\n3. 얼룩이 있는 부분은 물에 담그기 전에 부드러운 솔을 이용해 문질러 준 후 접은 그대로 희석액에 담궈준다. (미리 원액을 옷 안쪽에 문질러 보아 탈색이 되지 않는 지 확인)\n4. 옷을 그대로 두고 2~3번 물을 바꿔가며 헹궈준다.\n5. 마른 수건으로 물기 제거 후 그늘에서 건조한다.(물기를 없애겠다고 손으로 절대 짜지 말 것.)\n6. 남아있는 거품이나 냄새는 건조하면서 모두 날라간다.\n\n★ 주의 해야 할 사항과 팁:\n가죽, 모피, 벨벳, 비로드 소재의 옷이나 기계 주름, 엠보싱 가공이 되어 있는 옷은 집에서 드라이 클리닝을 하기에 어려움이 있습니다.\n변색·탈색 여부를 미리 확인해 보는 것을 추천합니다.\n레이온이 많이 섞여 있는 의류, 두꺼운 모, 견직 소재의 의류는 옷이 줄어 들 수 있기 때문에 주의해야 합니다.',
    ];

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
          backgroundColor: Colors.black,
        ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(2, (index) {
            return Center(
                child: Card(
                  elevation: 4, // 카드의 그림자를 표시하여 테두리 효과를 줍니다.
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // 카드의 모서리를 둥글게 만듭니다.
                    side: BorderSide(color: Colors.black, width: 2), // 카드의 테두리 속성을 설정합니다.
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: _imagePaths[index],
                        iconSize: 200,
                        onPressed: () {
                          _showImageDescriptionDialog(desc[index]);
                        },
                      ),
                    ],
                  ),
                )
            );
          }),
        ),
      ),
    );
  }
}


//clipper sect
class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // 원하는 형태로 자르기 영역을 정의합니다.
    return Path()
      ..addOval(Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class HalfClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height / 2) // 화면의 가로 중점에서 시작
      ..lineTo(size.width, size.height / 2) // 화면의 가로 중점에서 화면의 아래로 선 그리기
      ..lineTo(size.width, 0) // 화면의 오른쪽 아래 꼭지점으로 선 그리기
      ..lineTo(0, 0) // 화면의 오른쪽 위 꼭지점으로 선 그리기
      ..close(); // 경로를 닫습니다. 즉, 완전한 사각형 영역이 됩니다.

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

}

class ThirdClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height * 2 / 3) // 화면의 가로 중점에서 시작
      ..lineTo(size.width, size.height * 2 / 3) // 화면의 가로 중점에서 화면의 아래로 선 그리기
      ..lineTo(size.width, 0) // 화면의 오른쪽 아래 꼭지점으로 선 그리기
      ..lineTo(0, 0) // 화면의 오른쪽 위 꼭지점으로 선 그리기
      ..close(); // 경로를 닫습니다. 즉, 완전한 사각형 영역이 됩니다.

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}


//Laundry sect
class Laundry extends StatefulWidget {
  Laundry({Key? key}) : super(key: key);

  @override
  State<Laundry> createState() => _LaundryState();

}
int num = 0;
class _LaundryState extends State<Laundry> {

  late CameraController controller;
  late FlutterVision vision;
  late List<int> height = [2,1];
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  final DatabaseReference ref = FirebaseDatabase.instance.reference();


  @override
  void initState() {
    super.initState();
    init();
    print('hi');
  }

  init() async {
    cameras = await availableCameras();
    vision = FlutterVision();
    controller = CameraController(cameras[0], ResolutionPreset.low);
    controller.initialize().then((value) {
      setState(() {
          isLoaded = true;
          isDetecting = false;
        });
    });


  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Center(
              child: ClipPath(
                  clipper: MyCustomClipper(), // CustomClipper를 사용하여 원본 크기의 이미지를 적절한 크기로 자름
                  child: CameraPreview(controller)
              ),
            ),
          ),
          Positioned(
            bottom: 75,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 5,
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
              ),
              child: isDetecting
                  ? IconButton(
                onPressed: () async {

                },
                icon: const Icon(
                  Icons.stop,
                  color: Colors.red,
                ),
                iconSize: 50,
              )
                  : IconButton(
                onPressed: () async {
                  await ref.update(
                      {'proper_height': height[num]});
                  try {
                    // Ensure that the camera is initialized.
                    await controller.initialize();

                    // Attempt to take a picture and get the file `image`
                    // where it was saved.
                    final image = await controller.takePicture();

                    if (!mounted) return;

                    // If the picture was taken, display it on a new screen.
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DisplayPictureScreen(
                          // Pass the automatically generated path to
                          // the DisplayPictureScreen widget.
                          imagePath: image.path,
                        ),
                      ),
                    );
                  } catch (e) {
                    // If an error occurs, log the error to the console.
                    print(e);
                  }
                  num = num+1;
                },
                icon: const Icon(
                  Icons.play_arrow,
                  color: Colors.black,
                ),
                iconSize: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


List<CustomClipper<Path>> _clipper = [HalfClipper(), ThirdClipper()];
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: ClipPath(
          clipper: MyCustomClipper(), // CustomClipper를 사용하여 원본 크기의 이미지를 적절한 크기로 자름
          child: Container(
    color: Colors.red,
    child: ClipPath(
            clipper: _clipper[num], // CustomClipper를 사용하여 원본 크기의 이미지를 적절한 크기로 자름
            child: Center(
              child: Container(
              // 이미지를 화면에 꽉 채우기 위해 Container를 사용합니다.
              width: 500,
              height: 500,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
              ),
            ),)
      ),
          )));
  }
}

