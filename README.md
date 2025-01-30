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

**NOTE**

According to the task use case the first time a ride is confirm a countdown of 15 seconds is started to simulate a no driver found interface only when the retry button is clicked will driver be returned.

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

