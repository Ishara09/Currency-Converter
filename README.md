# currency_converter

A new Flutter project.

       Currency Converter

       Installation -----------------------

       Clone the Repository

       git clone https://github.com/Ishara09/Currency-Converter.git

       cd currency_converter


       Install Dependencies -------------------

        Run the following command to fetch all the required dependencies:

        flutter pub get

        Set Up API Keys ---------------

        API_KEY=your_api_key_here

        Configuration ------------------

        Set Up Shared Preferences

        The app uses shared_preferences to save and retrieve preferred currencies. Ensure the shared_preferences package is added to your pubspec.yaml:

        dependencies:

               shared_preferences: ^2.0.8

        Update API Configuration -------------------

        Update the API URLs and parameters in the CurrencyService class as required by your chosen API provider.

        Usage ------------------------

        Run the App

        Use the following command to start the app on an emulator or connected device:

         flutter run


Add Preferred Currencies--------------------

          Navigate to the main screen.

          Enter an amount and select the base currency.

          Tap the + ADD CONVERTER button to add target currencies.

Convert Currencies ---------------------

           Enter an amount in the input field.
		   
           Select the base currency from the dropdown.
		   
           The app will display converted amounts in your preferred target currencies.
		   

Remove Preferred Currencies -----------------

           On the main screen, swipe left on any currency tile and tap the delete icon to remove it from the list.


Features ----------------

          Convert amounts between different currencies.
		  
          Manage preferred target currencies.
		  
          Save user preferences locally using shared preferences.
		  
          Display currency conversion rates fetched from a remote API.
		  

Troubleshooting -----------------------

          Error: Could not prepare isolate / Could not create root isolate

This error typically indicates a problem with the Flutter environment or build artifacts. Run the following commands:
          check the main.dart file firstly
          flutter clean
          flutter pub get
          flutter run

Ensure your API key is correct and not exceeding rate limits. Check the API provider’s documentation for troubleshooting.

Shared Preferences Not Saving

Ensure shared_preferences is correctly configured and initialized. Check for any exceptions in the logs that might indicate issues with saving or loading preferences.


I used for this flutter project MVC Architecture ---------------

Model - View - Controller 

       --- Model
       The Model component in the MVC (Model-View-Controller) design pattern represents the data and business logic of an application. It is responsible for managing the application’s data, processing 
        business rules, and responding to requests for information from other components, such as the View and the Controller.

       --- View
       Displays the data from the Model to the user and sends user inputs to the Controller. It is passive and does not directly interact with the Model. Instead, it receives data from the Model and sends 
       user inputs to the Controller for processing.

       --- Controller
       Controller acts as an intermediary between the Model and the View. It handles user input and updates the Model accordingly and updates the View to reflect changes in the Model. It contains 
       application logic, such as input validation and data transformation.

       Advantages of the MVC : ---------------
                 easier to understand, maintain, and modify
                 can be developed and tested separately
                 Since the components are independent, changes to one component do not affect the others, allowing for easier updates and modifications
                 components can be reused in other parts of the application or in different projects, reducing development time and effort
                 Multiple developers can work on different components










