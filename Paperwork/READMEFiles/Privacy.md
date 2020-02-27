# ![][AppIcon]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Device Privacy

PitchPerfect is designed to utilize the device **Microphone**.

## Microphone Privacy

* Info.plist **MUST** contain the key/value pair for **Privacy - Microphone Usage Description** for the app to work properly on a device:
* Key/Value pair is ["NSMicrophoneUsageDescription", String];  string may be empty,  this implementation leaves it empty.
* When the **Microphone** button is tapped for the first time after installation, the following alert appears:

###### Table 3 - Microphone Usage Request
|               | 
| :---:         |                      
| ![][MicAlert] |

* Tapping **OK** grants access to the **Microphone** and enables recording.
* Tapping **Don't Allow** causes the app to hang or crash;  it needs to be uninstalled/reinstalled to work properly.

---
**Copyright © 2016-2020 Gregory White. All rights reserved.**



[AppIcon]:   ../images/PitchPerfectAppIcon_80.png
[MicAlert]:  ../images/MicrophoneUsageAlert.png
