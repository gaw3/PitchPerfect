# ![App Icon](./Paperwork/READMEFiles/PitchPerfect_80.png)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PitchPerfect

PitchPerfect allows the user to record sound via the device microphone,
and then play that sound back modulated in a fashion chosen by the user.

## Project

PitchPerfect is Portfolio Project #1 of the Udacity iOS Developer Nanodegree
Program.  The following list contains pertinent course documents:
* [Udacity App Specification](./Paperwork/Udacity/UdacityAppSpecification.pdf)  
* [Udacity Code Improvements](./Paperwork/Udacity/UdacityCodeImprovements.pdf)
* [Udacity Grading Rubric](./Paperwork/Udacity/UdacityGradingRubric.pdf)  
* [GitHub Swift Style Guide](./Paperwork/Udacity/GitHubSwiftStyleGuide.pdf)  
* [Udacity Git Commit Message Style Guide](./Paperwork/Udacity/UdacityGitCommitMessageStyleGuide.pdf)  
* [Udacity Project & Code Reviews](https://review.udacity.com/#!/reviews/48019)

|               | Project Submission          | Currently
| :----------   | :-------------              | :----------------- |
| Grade:        |  ***Exceeds Expectations*** | |  
| App Version:  | 1.0                         | 1.1&nbsp;&nbsp;(GH tag v1.1.1)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[changelog](./Paperwork/READMEFiles/ChangeLog.md)|
| Environment:  | Xcode 7.0.1 / iOS 9.0       | Xcode 7.2.1 / iOS 9.2 |
| Devices:      | iPhone Only                 | No Change |
| Orientations: | Portrait Only               | No Change |

## Design

### Record

The Record View is the initial view after app launch (first panel in
following table).

| Tap to Record                                | Recording...                               | Recording Paused...                              |
| :-------------:                              | :-------------:                            | :-------------:                                  |
| ![](./Paperwork/READMEFiles/TapToRecord.png) | ![](./Paperwork/READMEFiles/Recording.png) | ![](./Paperwork/READMEFiles/RecordingPaused.png) |

* Tap the microphone to transition to **Recording...**:
  - Microphone button becomes inactive
  - Legend changes to **Recording...**
  - Control buttons appear along the bottom:
    + ![Pause Button](./Paperwork/READMEFiles/pause_20_blue.png) - Pause




### Playback

[ verbiage TBD ]

### iOS Developer Libraries In Use

* [AVFoundation](./Paperwork/READMEFiles/AVFoundation.md)
* [Foundation](./Paperwork/READMEFiles/Foundation.md)
* [UIKit](./Paperwork/READMEFiles/UIKit.md)

### Protocols Implemented

* AVAudioRecorderDelegate
* UIApplicationDelegate

---
**Copyright © 2016 Gregory White. All rights reserved.**
