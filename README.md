# image-browser

To run this project, please follow following steps:

1. Open terminal and go to project folder where .podfile is stored.
2. Run pod install / pod update.
3. Once command run successfully, go to project folder and open .xcworkspace file in xcode.

# Requirements

- XCode 11
- MAC 10.15

# Supported iOS Version

- iOS 12.0 +

# Language 

- Swift 5.0


# App Version

- 1.0

# Design Patterns

1. MVVM
2. Adapter design pattern
3. Facade design pattern

Please check below for low level diagram:

![ScreenShot](https://github.com/jshivam/image-browser/blob/master/ScreenShots/architecture.png)

1. View / View Controller - This layer is responsible to handle UI operation based on callback from viewModel class.
2. ViewModel - This layer contains all business logic and list of models.
4. APIHandler - On this layer we have kept logic to parse individual response. This layer is designed by keeping in mind that all checks on server response and parsing will be implemented here. 
5. Persistence Manager - Responsible to handle data from Persistence Strore of your choice.
6. HTTPClient - Responsible to make HTTP api call.

# App Data Flow
- Type in the keyword and hit search
- If succesfully fetched the results from server, persistet the latest 10 keywords 
- If unsuccesfully fetched records from server, display error
- When focused into the search box, an auto-suggest list view is displayed below the search box showing my last 10 successful queries.

![ScreenShot](https://github.com/jshivam/image-browser/blob/master/ScreenShots/FlowChart.png)

# Caching

1. App is using UserDefaults to cache recent searched keywords.
2. For Image caching, app is using URLCache & NSCache.

# Assumptions        
1.  App support iPhone device in Portrait mode only. 
2.  Supported mobile platforms are iOS (12.x, 13.x)        
3.  Device support - iPhone 5s, iPhone 6 Series, iPhone SE, iPhone 7 Series, iPhone 8 Series, iPhone X Series    


# Crashlytics

App has implemented crashlytics using Firebase. 
1. Documentation: https://firebase.google.com/docs/crashlytics/get-started?platform=ios.

# CocoaPods Used

- Firebase/Analytics

# Swift Package Manager
- Toast-Swift
- Stevia Autolayout

# Autolayouting
App used Stevia for setting up contraints

# Pagination Handling
For pagination logic, App will assume more pages till the time it don't get empty list of response from server. In case of offline mode, it will always try for next page ( this is to make sure that if app comes online then it should return response).

# ScreenShots
![ScreenShot](https://github.com/jshivam/image-browser/blob/master/ScreenShots/ss.png)

# TODO / Improvements
-  UI test cases
-  ImageDownloader Unit Test cases
-  Improvise ImageDownloader's image caching logic
