import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_management/blocs/auth/auth_bloc.dart';
import 'package:library_management/blocs/signin/signin_cubit.dart';
import 'package:library_management/blocs/student_list/student_list_bloc.dart';
import 'package:library_management/repositories/auth_repository.dart';
import 'package:library_management/repositories/student_list_repository.dart';
import 'package:library_management/screens/add_student.dart';
import 'package:library_management/screens/attendance_page/qr_fab_widget.dart';
import 'package:library_management/screens/configure_page.dart';
import 'package:library_management/screens/students_list/students_list.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:library_management/screens/waiting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/attendance_page/attendance_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _defaultLightColorScheme =
      ColorScheme.fromSwatch(primarySwatch: Colors.blue);

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.dark);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: ((lightDynamic, darkDynamic) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<AuthRepository>(
              create: (context) => AuthRepository(
                firebaseFirestore: FirebaseFirestore.instance,
                firebaseAuth: FirebaseAuth.instance,
              ),
            ),
            RepositoryProvider<StudentRepository>(
              create: (context) => StudentRepository(
                firebaseFirestore: FirebaseFirestore.instance,
                firebaseAuth: FirebaseAuth.instance,
              ),
            ),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthBloc>(
                create: (BuildContext context) => AuthBloc(
                  authRepository: context.read<AuthRepository>(),
                ),
              ),
              BlocProvider<SigninCubit>(
                create: (context) => SigninCubit(
                  authRepository: context.read<AuthRepository>(),
                ),
              ),
              BlocProvider<StudentListBloc>(
                create: (context) => StudentListBloc(
                  studentRepository: context.read<StudentRepository>(),
                ),
              )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: lightDynamic ?? _defaultLightColorScheme,
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: darkDynamic ?? _defaultDarkColorScheme,
                useMaterial3: true,
              ),
              themeMode: ThemeMode.system,
              home: const LandingPage(),
            ),
          ),
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  Widget mainPage() {
    if (currentPageIndex == 0) {
      return const StudentList();
    } else if (currentPageIndex == 2) {
      return const ConfigurePage();
    }
    return const AttendanceList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          automaticallyImplyLeading: false,
          actions: [
            if (currentPageIndex == 2)
              PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'SampleItem.itemOne',
                    child: const Text('Delete data'),
                    onTap: () async {
                      context.read<AuthBloc>().add(SignoutRequestedEvent());
                      final prefs = await SharedPreferences.getInstance();
                      prefs.clear();
                    },
                  ),
                  const PopupMenuItem<String>(
                    value: 'SampleItem.itemTw',
                    child: Text('Backup'),
                  ),
                ],
              ),
          ],
        ),
        body: mainPage(),
        floatingActionButton: (currentPageIndex == 0)
            ? FloatingActionButton(
                // heroTag: 'addstud',
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const FormPage();
                      },
                    ),
                  );
                },
                tooltip: 'Add a new student',
                child: const Icon(Icons.add),
              )
            : (currentPageIndex == 1)
                ? const QRFAB()
                : null,
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.group_outlined),
              selectedIcon: Icon(Icons.group),
              label: 'Students',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.fact_check),
              icon: Icon(Icons.fact_check_outlined),
              label: 'Attendance',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_applications_outlined),
              selectedIcon: Icon(Icons.settings_applications),
              label: 'Configure',
            ),
          ],
        ),
      ),
    );
  }
}
