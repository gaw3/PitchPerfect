
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

    // MARK: - IB Outlets

    @IBOutlet weak var stopButton: UIButton!

    @IBOutlet weak var effectsStackView: UIStackView!
    @IBOutlet weak var speedStackView:   UIStackView!
    @IBOutlet weak var pitchStackView:   UIStackView!
    @IBOutlet weak var otherStackView:   UIStackView!

    // MARK: - IB Actions

    @IBAction func buttonWasTapped(_ button: UIButton) {
        let playbackEffect = PlaybackEffect(rawValue: button.tag)

        guard playbackEffect != nil else {
            fatalError("Received action from unknown button = \(button)")
        }

        switch playbackEffect! {

        case .slowSpeed, .fastSpeed: playSpeedEffect(rate: playbackEffect == .slowSpeed ? AudioEffects.OneOctaveLowerRate : AudioEffects.OneOctaveHigherRate)
        case .lowPitch, .highPitch:  playPitchEffect(pitch: playbackEffect == .lowPitch ? AudioEffects.OneOctaveLowerPitch : AudioEffects.OneOctaveHigherPitch)

        case .echo:   playAudioWithEffect(AVAudioUnitDelay())
        case .reverb: playReverbEffect(wetDryMix: AudioEffects.ReverbHalfWet)
        case .stop:   audioEngine.stop()

        }

    }

    // MARK: - Constants

    fileprivate let audioEngine = AVAudioEngine()

    // MARK: - Variables

    var receivedAudio:         RecordedAudio?
    fileprivate var audioFile: AVAudioFile?

    // MARK: - View Events

    override func viewDidLoad() {
        super.viewDidLoad()

        alignEffectButtons()
        NotificationCenter.default.addObserver(self, selector: SEL.ProcessNotification, name: .UIDeviceOrientationDidChange, object: nil)

        do {
            audioFile = try AVAudioFile(forReading: receivedAudio!.filePathURL as URL)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            presentAlert(Alert.Title.UnableToInitPlayback, message: error.localizedDescription)
        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIDeviceOrientationDidChange, object: nil)
    }

}



// MARK: -
// MARK: - Notifications

extension PlaySoundsViewController {

    func processNotification(_ notification: Notification) {

        switch notification.name {

        case Notification.Name.UIDeviceOrientationDidChange: alignEffectButtons()

        default: fatalError("Received unknown notification = \(notification)")
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

    struct AudioEffects {
        // Pitch is measured in “cents”, a logarithmic value used for measuring musical intervals.
        // One octave = 1200 cents.
        static let OneOctaveHigherPitch = Float(1200.0)
        static let OneOctaveLowerPitch  = Float(-1200.0)
        // Doubling the rate raises the pitch one octave;  halving the rate lowers the pitch one octave.
        static let OneOctaveHigherRate  = Float(2.0)
        static let OneOctaveLowerRate   = Float(0.5)
        // Reverb Wet/Dry Mix is specified as the percentage of the output signal that is comprised of
        // the wet (reverb) signal (thus the remaining percentage of the output signal is comprised of
        // the dry (original) signal).
        // 0 = output signal comprised entirely of dry signal (no wet).
        // 100 = output signal comprised entirely of wet signal (all wet).
        static let ReverbHalfWet = Float(50.0)
    }

    struct SEL {
        static let ProcessNotification = #selector(processNotification(_:))
    }

    // MARK: --Methods--

    func alignEffectButtons() {

        if UIDevice.current.orientation.isLandscape {
            effectsStackView.axis = .horizontal
            speedStackView.axis   = .vertical
            pitchStackView.axis   = .vertical
            otherStackView.axis   = .vertical
        } else {
            effectsStackView.axis = .vertical
            speedStackView.axis   = .horizontal
            pitchStackView.axis   = .horizontal
            otherStackView.axis   = .horizontal
        }

    }

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
            presentAlert(Alert.Title.UnableToStartPlayback, message: error.localizedDescription)
        }
        
    }
    
    func playPitchEffect(pitch: Float) {
        let effect = AVAudioUnitTimePitch()
        effect.pitch = pitch
        playAudioWithEffect(effect)
    }

    func playReverbEffect(wetDryMix: Float) {
        let effect = AVAudioUnitReverb()
        effect.wetDryMix = wetDryMix
        playAudioWithEffect(effect)
    }

    func playSpeedEffect(rate: Float) {
        let effect = AVAudioUnitVarispeed()
        effect.rate = rate
        playAudioWithEffect(effect)
    }

 }
