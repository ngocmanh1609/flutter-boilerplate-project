# Boilerplate Project

A boilerplate project created in flutter using Rx and BLoC.

## Getting Started

The Boilerplate contains the minimal implementation required to create a new library or project. The repository code is preloaded with some basic components like basic app architecture, app theme, constants and required dependencies to create a new project. By using boiler plate code as standard initializer, we can have same patterns in all the projects that will inherit it. This will also help in reducing setup & development time by allowing you to use same code pattern and avoid re-writing from scratch.

## How to Use 

**Step 1:**

Go to project root and execute the following command in console to get the required dependencies: 

```
flutter pub get 
```

**Step 2:**

This project uses `inject` library that works with code generation, execute the following command to generate files:

```
flutter packages pub run build_runner build --delete-conflicting-outputs
```

or watch command in order to keep the source code synced automatically:

```
flutter packages pub run build_runner watch
```

or clean build:

```
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Hide Generated Files

In-order to hide generated files, navigate to `Android Studio` -> `Preferences` -> `Editor` -> `File Types` and paste the below lines under `ignore files and folders` section:

```
*.inject.summary;*.inject.dart;*.g.dart;
```

In Visual Studio Code, navigate to `Preferences` -> `Settings` and search for `Files:Exclude`. Add the following patterns:
```
**/*.inject.summary
**/*.inject.dart
**/*.g.dart
```

## Boilerplate Features:

* Splash
* Login
* Home
* Routing
* Theme
* Dio
* Database
* RxDart
* BLoC (State Management)
* Encryption
* Validation
* Code Generation
* User Notifications
* Logging
* Dependency Injection
* Dark Theme Support
* Multilingual Support
* BLoC example

### Up-Coming Features:

* Connectivity Support
* Background Fetch Support

### Libraries & Tools Used

* [Dio](https://github.com/flutterchina/dio)
* [Database](https://github.com/tekartik/sembast.dart)
* [RxDart](https://github.com/ReactiveX/rxdart)
* [BLoC](https://github.com/mono0926/bloc_provider) (State Management)
* [Encryption](https://github.com/xxtea/xxtea-dart)
* [Validation](https://github.com/dart-league/validators)
* [Logging](https://github.com/zubairehman/Flogs)
* [Notifications](https://github.com/AndreHaueisen/flushbar)
* [Json Serialization](https://github.com/dart-lang/json_serializable)
* [Dependency Injection](https://github.com/google/inject.dart)

### Folder Structure
Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- build
|- ios
|- lib
|- test
```

Here is the folder structure we have been using in this project

```
lib/
|- bloc/
|- constants/
|- data/
|- ui/
|- utils/
|- widgets/
|- main.dart
|- routes.dart
```

Now, lets dive into the lib folder which has the main code for the application.

```
1- bloc - Contains common bloc(s) for state-management of your application, to connect the reactive data of your application with the UI. 
2- constants - All the application level constants are defined in this directory with-in their respective files. This directory contains the constants for `theme`, `dimentions`, `api endpoints`, `preferences` and `strings`.
3- data - Contains the data layer of your project, includes directories for local, network and shared pref/cache.
4- ui — Contains all the ui of your project, contains sub directory for each screen.
5- util — Contains the utilities/common functions of your application.
6- widgets — Contains the common widgets for your applications. For example, Button, TextField etc.
7- routes.dart — This file contains all the routes for your application.
8- main.dart - This is the starting point of the application. All the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.
```


## Conclusion

I will be happy to answer any questions that you may have on this approach, and if you want to lend a hand with the boilerplate then please feel free to submit an issue and/or pull request 🙂

Again to note, this is example can appear as over-architectured for what it is - but it is an example only. If you liked my work, don’t forget to ⭐ star the repo to show your support.

