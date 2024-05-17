import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart'; // Import package
import 'package:shop/api/api_manager.dart';
import 'package:shop/firebase_options.dart';
import 'package:shop/helper/app_colors.dart';
import 'package:shop/helper/dimension.dart';
import 'package:shop/module/auth/login/login_page.dart';
import 'package:shop/module/home/home_bloc.dart';
import 'package:shop/module/home/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences package
import 'package:timezone/data/latest.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request permissions when the app is initialized
  await requestPermissions();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  tz.initializeTimeZones();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  runApp(MyApp());
}

// Function to request permissions
Future<void> requestPermissions() async {
  // Request multiple permissions at once
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.notification, // Adding notification permission
  ].request();

  // Check if any of the permissions are denied
  if (statuses.containsValue(PermissionStatus.denied)) {
    // Show a dialog requesting the user to grant permissions
    showDialog(
      context: navigatorKey.currentState!.overlay!.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permissions Required'),
          content: Text('Please grant the required permissions to use the app.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final ApiManager apiManager = ApiManager();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => HomeBloc(),
        ),
      ],
      child: GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                "assets/lottie/loading_clock.json",
                frameRate: FrameRate(60),
                width: Dimensions.size100 * 2,
                repeat: true,
              ),
              Text(
                "Memuat...",
                style: TextStyle(
                  fontSize: Dimensions.text20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        overlayColor: Colors.black,
        overlayOpacity: 0.8,
        child: GetMaterialApp(
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          title: "Muslim",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: "Barlow",
            colorScheme: AppColors.lightColorScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            fontFamily: "Barlow",
            colorScheme: AppColors.darkColorScheme,
          ),
          themeMode: ThemeMode.system,
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child ?? Container(),
            );
          },
          home: FutureBuilder(
            future: _isUserLoggedIn(), // Check if user is logged in
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                if (snapshot.data == true) {
                  return HomePage(); // If user is logged in, show HomePage
                } else {
                  return LoginScreen(); // If user is not logged in, show LoginScreen
                }
              }
            },
          ),
        ),
      ),
    );
  }

  // Function to check if user is logged in
  Future<bool> _isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;

  const DismissKeyboard({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null
) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
