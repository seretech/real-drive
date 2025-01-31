# Real Drive
A Simple Ride-Hailing Mobile Application.

# Apk File installer
Click on the Real Drive apk file in the email to download the application, then copy the download file to an android device.

Click on the file to allow the application install on the device, after successful installation the application will be opened.

# App Usage
To use the application an account must be created,  after user inputs all details and  click on sign up location permission must be allowed before sign up can be completed after which the user is directed to the app homepage.

On the homepage if the user does not have a ride in progress the app processes location request to get the current location of the user, after which the user can confirm if this is the pick up location, if not the user can tap or long press anywhere on the map to drop marker for a pick up location, the user then click on the confirm pick up location to confirm the selected location.
After the user confirm a pick up location the user then taps or long press anywhere on the map to drop a marker for a drop off location, the user then click on the confirm drop location to confirm the selected location.

After the pickup and drop off location has been the selected the user then confirms the ride at which point a search is initiated for any available driver.

If a driver is not found the user can click on retry to search again, once a driver is found the user is presented with the detail of the driver as well as a notification with all relevant information, the user can then proceed to confirm the ride.

On the history page the user can see all list of rides initiated previous and any ride currently in progress.

On the profile page the user can see and edit there personal information and update their password as well.

# Third Party Libraries Used
get: ^4.6.6

get_storage: ^2.1.1

google_maps_flutter: ^2.10.0

permission_handler: ^11.3.1

location: ^8.0.0

move_to_background: ^1.0.2

flutter_local_notifications: ^18.0.1

geocoding: ^3.0.0

GetX is an extra-light and powerful solution for Flutter. It combines high-performance state management, intelligent dependency injection, and route management quickly and practically.

Get Storage is a fast, extra light and synchronous key-value in memory, which backs up data to disk at each operation. It is written entirely in Dart and easily integrates with Get framework of Flutter.

Google maps flutter is a Flutter plugin for integrating Google Maps in iOS and Android applications in our case used for displaying users location and pickup and drop off location selection.

Permission Handler is a plugin that provides a cross-platform (iOS, Android) API to request and check permissions in our case used for asking location permission.

Location is Cross-platform plugin for easy access to device's location in real-time in our case used for get the user current location on the app is opened.

Move to background is a flutter plugin for sending application to background in our case for minimizing the application.

Flutter Local Notification is a cross platform plugin for displaying and scheduling local notifications for Flutter applications with the ability to customise for each platform in our case used for sending push notification when a driver is found.

Geocoding is a plugin which provides easy geocoding and reverse-geocoding features in our case used for convert the location selected on the map(longitude and latitude) to physical address for users clarity.

**NOTE**

According to the task use case the first time a ride is confirm a countdown of 15 seconds is started to simulate a no driver found interface only when the retry button is clicked will driver be returned.

The price of N10,000 is static for all rides.

Once a ride is in progress another ride cannot be initiated, the in-progress ride needs to be completed before another ride can be initiate.

Location permission is require before sign in and sign up to get user current location and mark on the map.

# Github Repository
Click on the Github Repo link in the email to open the code repository.

Once opened, click on "<>code" green button by the right side of page and either copy the clone https link or download the project source code as zip file.

if Zip File is downloaded
Extract the file into an empty folder,
open android studio,
click on open project,
navigate to the folder,
select ok to load the project.

If Clone link is copied
Open android studio,
click on new project,
select project from version control,
From opened dialog ensure git is selected form dropdown as version control option,
paste clone link copied from the github repo,
select clone at the bottom of the dialog to load the project
