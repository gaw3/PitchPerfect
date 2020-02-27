# ![][AppIcon]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PitchPerfect

PitchPerfect allows the user to record sound via the device microphone, and then play that sound modulated in one of six different ways.

## Project

PitchPerfect is Portfolio Project #1 of the Udacity iOS Developer Nanodegree Program.  The following list contains pertinent course documents:  

* [Udacity App Specification][AppSpec]  
* [Udacity Code Improvements][CodeImprovements]
* [Udacity Grading Rubric][GradingRubric]  
* [GitHub Swift Style Guide][SwiftStyleGuide]  
* [Udacity Git Commit Message Style Guide][CommitMsgStyleGuide]  
* [Udacity Project Review][ProjectReview]<br/><br/>

| [Change Log][ChangeLog] | Current Build          | Project Submission - ***Exceeds Expectations*** |
| :----------             | :-----------------     | :-------------                                  |
| GitHub Tag              | v3.0                   | no tag                                          |
| App Version:            | 3.0                    | 1.0                                             |
| Environment:            | iOS 13 / Swift 5       | iOS 9.0 / Swift 2                               |
| Devices:                | iPhone Only            | iPhone Only                                     |
| Orientations:           | All except Upside Down | Portrait Only                                   |

## Design

### Record View

###### TABLE 1 - Record View States
| Tap to Record | Recording... | Recording Paused... |
| :---:         | :---:        | :---:               |
| ![][TRV]      | ![][RV]      | ![][RPV]            |

###### TABLE 2 - Recording Control Buttons
| Resume            | Pause            | Stop            |
| :---:             | :---:            | :---:           |
| ![][ResumeButton] | ![][PauseButton] | ![][StopButton] |

* The **Record View** is the initial view after app launch and looks like **Tap to Record**.<br/><br/>
* Tap the active microphone icon to start recording:  
  - The view transitions to **Recording...**.
  - Icons that are "greyed out" are inactive and will not respond to a tap.<br/><br/>
* While recording, tap the **Pause** button to pause recording:
  - The view transitions to **Recording Paused...**.
  - **Resume** button becomes active, **Pause/Stop** buttons become inactive.<br/><br/>
* While recording, tap the **Stop** button to stop recording:
  - Recording function is terminated.
  - The view transitions to the **Playback View**.<br/><br/>
* While recording is paused, tap the **Resume** button to continue recording:
  - New audio will be appended to previously recorded audio
  - **Resume** button becomes inactive, **Pause/Stop** buttons become active.<br/><br/>

### Playback View

###### TABLE 3 - Playback View
|          | 
| :---:    |                      
| ![][PVC] |

###### TABLE 4 - Playback Effect Buttons
| Snail  | Rabbit | Chipmunk | Darth Vader | Hawk  | Reverb |
| :---:  | :---:  | :---:    | :---:       | :---: | :---:  | 
| ![][SnailButton] | ![][RabbitButton] | ![][ChipmunkButton] | ![][DarthVaderButton] | ![][HawkButton] | ![][ReverbButton] |

* Tap the **Snail** button to play the original audio at one-half the recording speed, *making the audio sound slower*.
* Tap the **Rabbit** button to play the original audio at twice the recording speed, *making the audio sound faster*.
* Tap the **Chipmunk** button to play the original audio with pitch one octave higher than the original, *making the audio sound higher*.
* Tap the **Darth Vader** button to play the original audio with pitch one octave lower that the original, *making the audio sound lower*.
* Tap the **Hawk** button to play the original audio with *an [echo][Echo] based on a one-second delay*.
* Tap the **Reverb** button to play the original audio with *a [reverberation][Reverberation] containing the acoustic characteristics of a medium-sized hall environment, using a [wet-dry mix][WetDryMix] of 50%*.
* During playback, tap the **Stop** button to terminate playback<br/><br/>
* During playback, tap an effect button to terminate the current playback, and restart playback with the new effect.
* At any time, tap the **< Record** button (in the navigation bar) to terminate playback (if active) and return to the **Tap to Record** state of the **Record View**.

### Notes

* [Device Privacy][DevicePrivacy]

### iOS Frameworks

* AVFoundation
* Foundation
* UIKit

### 3rd-Party

* *GitHub Swift Style Guide* lives in this [repo][StyleGuideRepo].
* `Swift.gitignore`, the template used to create the local `.gitignore` file, lives in this [repo][GitIgnoreRepo].

---
**Copyright © 2016-2020 Gregory White. All rights reserved.**



[AppIcon]:              ./Paperwork/images/PitchPerfectAppIcon_80.png
[ChipmunkButton]:       ./Paperwork/images/ChipmunkButton_90.png
[DarthVaderButton]:     ./Paperwork/images/DarthVaderButton_90.png
[HawkButton]:           ./Paperwork/images/HawkButton_90.png
[PauseButton]:          ./Paperwork/images/PauseButton_30.png
[PVC]:                  ./Paperwork/images/PlayViewController.png
[RabbitButton]:         ./Paperwork/images/RabbitButton_90.png
[ResumeButton]:         ./Paperwork/images/ResumeButton_30.png
[ReverbButton]:         ./Paperwork/images/ReverbButton_90.png
[RPV]:                  ./Paperwork/images/RecordingPausedView.png
[RV]:                   ./Paperwork/images/RecordingView.png
[SnailButton]:          ./Paperwork/images/SnailButton_90.png
[StopButton]:           ./Paperwork/images/StopButton_30.png
[TRV]:                  ./Paperwork/images/TapToRecordView.png

[AppSpec]:              ./Paperwork/Udacity/UdacityAppSpecification.pdf
[CodeImprovements]:     ./Paperwork/Udacity/UdacityCodeImprovements.pdf
[CommitMsgStyleGuide]:  ./Paperwork/Udacity/UdacityGitCommitMessageStyleGuide.pdf
[GradingRubric]:        ./Paperwork/Udacity/UdacityGradingRubric.pdf
[ProjectReview]:        ./Paperwork/Udacity/UdacityProjectReview.pdf
[SwiftStyleGuide]:      ./Paperwork/Udacity/GitHubSwiftStyleGuide.pdf  

[ChangeLog]:            ./Paperwork/READMEFiles/ChangeLog.md
[AVF]:                  ./Paperwork/READMEFiles/AVFoundation.md
[FDTN]:                 ./Paperwork/READMEFiles/Foundation.md
[DevicePrivacy]:        ./Paperwork/READMEFiles/Privacy.md
[UK]:                   ./Paperwork/READMEFiles/UIKit.md 

[Echo]:                 https://en.wikipedia.org/wiki/Echo
[GitIgnoreRepo]:        https://github.com/github/gitignore
[Reverberation]:        https://en.wikipedia.org/wiki/Reverberation
[StyleGuideRepo]:       https://github.com/github/swift-style-guide
[WetDryMix]:            http://www.differencebetween.net/technology/difference-between-wet-and-dry-signals-or-sounds/
