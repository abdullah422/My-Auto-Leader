import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mal/modules/loading_page/Loading_page.dart';
import 'package:mal/modules/loading_page/cubit/loading_cubit.dart';
import 'package:mal/services/navigation_service.dart';
import 'package:mal/shared/network/local/shared_preferences.dart';
import 'package:mal/translations/codegen_loader.g.dart';

import 'app_routes.dart';
import 'firebase_options.dart';
import 'shared/network/connection_test/connectivity_service.dart';
import 'shared/network/remote/api_test.dart';


// test git hub
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true);

// flutter local notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// firebase background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A Background message just showed up :  ${message.messageId}');
}
void main() async {
  Bloc.observer = MyBlocObserver();
  FlutterNativeSplash.remove();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 // Api.initializeInterceptors();
  await SharedPrefHelper.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SystemChrome.setSystemUIOverlayStyle(  const SystemUiOverlayStyle(
    statusBarColor:Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value){
    runApp(EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
          Locale('bn'),
          Locale('de'),
          Locale('fr'),
          Locale('tr'),
        ],
        path: 'assets/translations',
        // <-- change the path of the translation files
        fallbackLocale: const Locale('en'),
        assetLoader: CodegenLoader(),
        useOnlyLangCode: true,
        child: const MyApp()));
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ConnectivityService connectivityService;
  late final messengerKey = GlobalKey<ScaffoldMessengerState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivityService = ConnectivityService();
  }


  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        builder: (context, child) {
          return StreamBuilder(
            stream: connectivityService.connectionStatusController.stream,
            builder: (_,snapshot){
              if (snapshot.data == ConnectivityStatus.offline) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                 connectivityService.buildErrorInternetConnectionSnackBar(messengerKey);
                });
              }

              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (BuildContext context) => LoadingCubit()..checker(),

                  ),

                ],
                child: MaterialApp(
                  scaffoldMessengerKey: messengerKey,
                  supportedLocales:context.supportedLocales,
                  localizationsDelegates: context.localizationDelegates,
                  locale: context.locale,
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: RoutesManager.routes,
                  navigatorKey: NavigationService.instance.navigationKey,
                  home: LoadingPage(),
                ),
              );

          },

          );});
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}
