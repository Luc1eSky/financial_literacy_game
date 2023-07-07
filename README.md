# Financial Literacy Game
 This is an educational web app designed to enhance financial literacy among users and was developed for a field experiment conducted in Uganda and India. The app is developed using Flutter, a cross-platform framework for building native applications for mobile, web, and desktop from a single codebase. The game was played by over 500 study participants over the summer 2023 in order to teach simple financial decision making and investments and was playable with minimal digitial literacy levels since most study participants do not own their own smartphone to play the game. The study results will be published in 2024 and I will provide a link here in the future.

## Getting Started
1. Make sure you have Flutter SDK installed on your machine. If not, refer to the Flutter installation guide.
2. Clone this repository to your local machine.
3. Open a terminal or command prompt and navigate to the project directory.
4. Run the following command to install the required dependencies:
-> flutter pub get
5. Connect a device or start an emulator.
6. Run the app using the following command:
-> flutter run
The app should launch on your device or emulator, and you can explore its features and functionalities.

## Features of the game
Game Play: Users are presented livestock investment decisions and have to decide if they want to buy the asset or not and how to finance it. 

User Interface and Navigation: The game has an intuitive and easy-to-use interface that is accessible to users of all educational backgrounds. The navigation is simple, with clear and concise instructions, so that users can easily progress through the different levels and with clear learning objectives in each stage of the game.

Levels: The game has a total of 6 levels with increasing difficulty.

Progressive Difficulty: The game has a progressive difficulty curve, starting with simple concepts and gradually increasing in complexity. This allows users to build their knowledge and skills gradually, making it easier to understand and apply the more advanced financial concepts.

Randomized Shocks: Players will be confronted with shocks in each simulation round, those can be positive or negative and are influenced by the risk level of the investment.

Localization: The app has been translated into Luganda and Kannada since those were the locations, where the experiments were taking place. For the internationalization the Flutter International Package has been used.

[Link to hosted web app](https://financelitsim.web.app)

## Main Packages being used

Riverpod: It is a state management package for Flutter, which aims to simplify and improve the way you manage state in your Flutter applications. It is built on top of Flutter's provider package and provides a more intuitive and flexible API.
[Riverpod package](https://financelitsim.web.app](https://pub.dev/packages/riverpod)

Localizations: The flutter_localizations package is a collection of localization delegates and utility classes that provide internationalization (i18n) support for Flutter applications. It is a part of the Flutter SDK and is automatically included when you create a new Flutter project.
[Internationalizing a Flutter app](https://financelitsim.web.app](https://pub.dev/packages/riverpod](https://docs.flutter.dev/accessibility-and-localization/internationalization))



## Contributing
Contributions to this project are welcome. If you encounter any issues or have suggestions for improvements, please open an issue on the project's GitHub repository. When contributing to this repository, please follow the existing code style and structure. Additionally, adhere to the Flutter best practices and conventions.

## License
This project is licensed under the MIT License. Feel free to modify and distribute the app in accordance with the terms of the license.
