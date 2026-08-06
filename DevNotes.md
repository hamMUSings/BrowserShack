# Developer / Contributor Notes

Detailed notes on all parts of BrowserShack to get anyone started who wants to contribute.

# BrowserShack Home Web Page

All web pages were laid out with [RocketCake](https://www.ambiera.com/rocketcake/)

## index.html

Index.html contains 3 main types of markup:

1) Straight html+css
   - As laid out by RocketCake
2) RocketCake javascript modules
   - Menu
   - HF Conditions (gallery)
3) Custom javascript
   - Enable Radio Audio Player

The custom javascript is a simple script that is activated when clicked on the speaker icon.  Technically, the Radio Audio Player is enabled/viewable by default but there is a call to the toggle script on load which toggles it to be hidden.  The speaker button runs the toggle again to unhide/hide it again.

Due to not being successful to get the javascript player loaded directly into index.html for some reason it is a separate page with the [OvenPlayer](https://github.com/AirenSoft/OvenPlayer) loaded into audioplayer.html and on index.html it is an embedded iframe.

## audioplayer.html

This is a page that ONLY has an instance of the [OvenPlayer](https://github.com/AirenSoft/OvenPlayer) loaded into it and pointed at the OvenMediaServer instance.  It will only be able to connect when the phone_voice_stack is run.

This is the default player for the WebRTC server (OvenMediaEngine) that is used.

## handmic.html

This is by far the most 'complex' page of the bunch.  As in the most custom code is written.  In essence it isn't exactly complicated but more to understand about how it works.

> [!NOTE]
> This is the only page where it was designed for mobile devices FIRST.  The layout is intentionally setup so on a phone the only things easily shown are the screen and the PTT.  In addition everything is laid out centered and sized to look and feel nice on a mobile device. It will work on a computer browser as well.


It has the following types of markup:

1) Straight html+css
   - Including buttons
2) RocketCake javascript modules
   - A
3) Custom javascript
   - Websocket sending events per button
   - Most javascript code of all pages
4) Input form field for frequency 
5) OvenLiveKit WebRTC javascript

When the page loads it loads the [OvenLiveKit](https://github.com/AirenSoft/OvenLiveKit-Web) WebRTC connection and requests access to users microphone to send to the radio via the OvenMedieEngine WebRTC server.  This is largely a direct use of the example from OvenLiveKit.  This is included as javascript in the page.

Then the video output of ustreamer is shown in an iframe in the page.  This gives a view of the radio screen while on this page.

The rest of the page is largely buttons and custom javascript functions to send data to a websocket running in the voice_phone_stack.  The buttons are designs from RocketCake and all except PTT use onclick() actions to activate the javascript functions.  There is one function per button with hard coded data to send to the websocket instance of hamlib. 

> [!IMPORTANT]
> The PTT button uses onup and ondown as two separate actions to start and stop the PTT calls.

To view the command set of the websocket server see [the containers github page.](https://github.com/hamMUSings/websocketd_to_hamlib)

The frequency set has a text input field and the javascript takes that input and sends it in the correct format to the websocket server when the Go button is pushed. It then clears the field once sent.  It allows the users to enter in MHz but does math to convert it to Hz before sending to websocket server.

> [!IMPORTANT]
> The websocket server only allows certain commands from hamlib to be sent see the containers github page](https://github.com/hamMUSings/websocketd_to_hamlib) for a complete list.

> [!IMPORTANT]
> The websocket server has a filter on it to only allow legal ham band frequencies to be sent to the radio.  If an incorrect frequency is sent the field will reset but the radio will not change.  There is **no feedback** on the web page that it was wrong.

To keep things simple the page only sends websocket commands and does not do anything with received packets. As the radio is in full view whether they succeeded, failed, or PTT active is viewable right there no return information was put into the web page.

## Space Weather & Photo Credits

These both are straight html+css with either text, links, or images.  Nothing fancy going on here.

## Desktop Environment

Due to issues with graphics drivers and GridTracker2 in a XPRA based docker container I decided to just let the desktop be local.  This does raise resource requirements and isn't the most ideal but it also allos graphics and audio drivers to be natively accessed.

* LXQt is installed via DietPi menu.
  * Only test on Intel integrated GPU at this time.
* WSJT-X, GridTracker2, and JS8Call are all 'installed' using AppImages.
  * Stored in /mnt/dietpi_userdata/AppImages
  * Renamed from their long names (ie GridTracker2-2.260723.0-x86_64.AppImage) to simpler app name only (ie gridtracker2.AppImage)
  * Custom menu items in repo are placed in ~/.local/share/applications
   * Shorted name allows menu items to be easily 'reused' by users
   * Application "upgrades" are only a matter of renaming the new AppImage to the shortened name and placed in the correct folder
   * New custom applications and shortcuts can be added by making a new custom menu item and shorted AppImage name
   


   