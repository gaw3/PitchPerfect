//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Gregory White on 9/2/15.
//  Copyright (c) 2015-2016 Gregory White. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

final internal class PlaySoundsViewController: UIViewController {

	// MARK: - Internal Constants

	internal struct UI {
		static let SegueID = "SegueFromRecordToPlay"
	}

	// MARK: - Private Constants

	fileprivate struct AlertTitle {
		static let UnableToInit  = "Unable to initialize for playback"
		static let UnableToStart = "Unable to start playback"
	}

	fileprivate struct Effects {
		// Pitch is measured in “cents”, a logarithmic value used for measuring musical intervals. 
		// One octave = 1200 cents.
		static let OneOctaveHigherPitch: Float = 1200.0
		static let OneOctaveLowerPitch: Float  = -1200.0
		// Doubling the rate raises the pitch one octave;  halving the rate lowers the pitch one octave.
		static let OneOctaveHigherRate: Float  = 2.0
		static let OneOctaveLowerRate: Float   = 0.5
		// Reverb Wet/Dry Mix is specified as the percentage of the output signal that is comprised of 
		// the wet (reverb) signal (thus the remaining percentage of the output signal is comprised of 
		// the dry (original) signal).
		// 0 = output signal comprised entirely of dry signal (no wet).
		// 100 = output signal comprised entirely of wet signal (all wet).
		static let ReverbHalfWet: Float = 50.0
	}

	// MARK: - Internal Stored Variables

	internal var receivedAudio: RecordedAudio?

	// MARK: - Private Stored Variables

	fileprivate let audioEngine = AVAudioEngine()
   fileprivate var audioFile: AVAudioFile?

	// MARK: - Private Computed Variables

	fileprivate var audioSession: AVAudioSession {
		return AVAudioSession.sharedInstance()
	}

	// MARK: - IB Outlets

	@IBOutlet weak internal var stopButton: UIButton!

	// MARK: - View Events

	override internal func viewDidLoad() {
		super.viewDidLoad()

		do {
			audioFile = try AVAudioFile(forReading: receivedAudio!.filePathUrl as URL)
			try audioSession.setCategory(AVAudioSessionCategoryPlayback)
		} catch let error as NSError {
			presentAlert(AlertTitle.UnableToInit, message: error.localizedDescription)
		}

	}

	// MARK: - IB Actions

	@IBAction internal func playChipmunkAudio(_ sender: UIButton) {
		let pitchEffect = AVAudioUnitTimePitch()
		pitchEffect.pitch = Effects.OneOctaveHigherPitch
		playAudioWithEffect(pitchEffect)
	}

	@IBAction internal func playDarthVaderAudio(_ sender: UIButton) {
		let pitchEffect = AVAudioUnitTimePitch()
		pitchEffect.pitch = Effects.OneOctaveLowerPitch
		playAudioWithEffect(pitchEffect)
	}

	@IBAction internal func playEchoAudio(_ sender: UIButton) {
		let echoEffect = AVAudioUnitDelay()
		playAudioWithEffect(echoEffect)
	}

	@IBAction internal func playFastAudio(_ sender: UIButton) {
		let fastEffect = AVAudioUnitVarispeed()
		fastEffect.rate = Effects.OneOctaveHigherRate
		playAudioWithEffect(fastEffect)
	}

	@IBAction internal func playReverbAudio(_ sender: UIButton) {
		let reverbEffect = AVAudioUnitReverb()
		reverbEffect.wetDryMix = Effects.ReverbHalfWet
		playAudioWithEffect(reverbEffect)
	}

	@IBAction internal func playSlowAudio(_ sender: UIButton) {
		let slowEffect = AVAudioUnitVarispeed()
		slowEffect.rate = Effects.OneOctaveLowerRate
		playAudioWithEffect(slowEffect)
	}

	@IBAction internal func stopAudio(_ sender: UIButton) {
		audioEngine.stop()
	}

	// MARK: - Private

	fileprivate func playAudioWithEffect(_ effect: AVAudioUnit) {
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
