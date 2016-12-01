
 //
 //  PlaySoundsViewController.swift
 //  Pitch Perfect
 //
 //  Created by Gregory White on 9/2/15.
 //  Copyright (c) 2015-2016 Gregory White. All rights reserved.
 //

 import AVFoundation
 import UIKit

 final class PlaySoundsViewController: UIViewController {

    // MARK: --IB Outlets--

    @IBOutlet weak var stopButton: UIButton!

    // MARK: --IB Actions--

    @IBAction func buttonWasTapped(_ button: UIButton) {
        let playbackEffect = PlaybackEffect(rawValue: button.tag)!

        switch playbackEffect {

        case .slowSpeed, .fastSpeed:
            let effect = AVAudioUnitVarispeed()
            effect.rate = (playbackEffect == .slowSpeed ? AudioEffects.OneOctaveLowerRate : AudioEffects.OneOctaveHigherRate)
            playAudioWithEffect(effect)

        case .lowPitch, .highPitch:
            let effect = AVAudioUnitTimePitch()
            effect.pitch = (playbackEffect == .lowPitch ? AudioEffects.OneOctaveLowerPitch : AudioEffects.OneOctaveHigherPitch)
            playAudioWithEffect(effect)

        case .echo: playAudioWithEffect(AVAudioUnitDelay())

        case .reverb:
            let effect = AVAudioUnitReverb()
            effect.wetDryMix = AudioEffects.ReverbHalfWet
            playAudioWithEffect(effect)

        case .stop: audioEngine.stop()

        }

    }

    // MARK: --Constants--

    struct UI {
        static let SegueID = "SegueFromRecordToPlay"
    }

    fileprivate let audioEngine = AVAudioEngine()

    // MARK: --Variables--

    var receivedAudio:         RecordedAudio?
    fileprivate var audioFile: AVAudioFile?
 }



 // MARK: - View Events

 extension PlaySoundsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            audioFile = try AVAudioFile(forReading: receivedAudio!.filePathURL as URL)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            presentAlert(AlertTitle.UnableToInit, message: error.localizedDescription)
        }

    }

 }



 // MARK: - Private Helpers

 private extension PlaySoundsViewController {

    // MARK: --Constants--

    enum PlaybackEffect: Int {
        case slowSpeed = 1
        case fastSpeed = 2
        case highPitch = 3
        case lowPitch  = 4
        case echo      = 5
        case reverb    = 6
        case stop      = 7
    }

    struct AlertTitle {
        static let UnableToInit  = "Unable to initialize for playback"
        static let UnableToStart = "Unable to start playback"
    }

    struct AudioEffects {
        // Pitch is measured in “cents”, a logarithmic value used for measuring musical intervals.
        // One octave = 1200 cents.
        static let OneOctaveHigherPitch: Float = 1200.0
        static let OneOctaveLowerPitch:  Float  = -1200.0
        // Doubling the rate raises the pitch one octave;  halving the rate lowers the pitch one octave.
        static let OneOctaveHigherRate:  Float  = 2.0
        static let OneOctaveLowerRate:   Float   = 0.5
        // Reverb Wet/Dry Mix is specified as the percentage of the output signal that is comprised of
        // the wet (reverb) signal (thus the remaining percentage of the output signal is comprised of
        // the dry (original) signal).
        // 0 = output signal comprised entirely of dry signal (no wet).
        // 100 = output signal comprised entirely of wet signal (all wet).
        static let ReverbHalfWet: Float = 50.0
    }

    // MARK: --Methods--

    func playAudioWithEffect(_ effect: AVAudioUnit) {
        audioEngine.stop()
        audioEngine.reset()

        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(effect)

        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile!, at: nil, completionHandler: nil)

        do {
            try audioEngine.start()
            audioPlayerNode.play()
        } catch let error as NSError {
            presentAlert(AlertTitle.UnableToStart, message: error.localizedDescription)
        }
        
    }
    
 }
