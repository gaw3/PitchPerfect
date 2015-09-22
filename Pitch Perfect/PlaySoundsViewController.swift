//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Gregory White on 9/2/15.
//  Copyright (c) 2015 Gregory White. All rights reserved.
//

import AVFoundation
import UIKit

class PlaySoundsViewController: UIViewController {

	// MARK: - IB Outlets

	@IBOutlet weak var stopButton: UIButton!

	// MARK: - Class Variables

	var audioEngine: AVAudioEngine!
	var audioFile: AVAudioFile!
	var audioSession: AVAudioSession!
	var receivedAudio: RecordedAudio!

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		audioEngine = AVAudioEngine()
		audioFile   = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

		audioSession = AVAudioSession.sharedInstance()
		audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil)
	}

	// MARK: - IB Actions

	@IBAction func playChipmunkAudio(sender: UIButton) {
		var pitchEffect = AVAudioUnitTimePitch()
		pitchEffect.pitch = 1000
		playAudioWithEffect(pitchEffect)
	}

	@IBAction func playDarthVaderAudio(sender: UIButton) {
		var pitchEffect = AVAudioUnitTimePitch()
		pitchEffect.pitch = -1000
		playAudioWithEffect(pitchEffect)
	}

	@IBAction func playEchoAudio(sender: UIButton) {
		var echoEffect = AVAudioUnitDelay()
		playAudioWithEffect(echoEffect)
	}

	@IBAction func playFastAudio(sender: UIButton) {
		var fastEffect = AVAudioUnitVarispeed()
		fastEffect.rate = 2.0
		playAudioWithEffect(fastEffect)
	}

	@IBAction func playReverbAudio(sender: UIButton) {
		var reverbEffect = AVAudioUnitReverb()
		reverbEffect.wetDryMix = 50.0
		playAudioWithEffect(reverbEffect)
	}

	@IBAction func playSlowAudio(sender: UIButton) {
		var slowEffect = AVAudioUnitVarispeed()
		slowEffect.rate = 0.5
		playAudioWithEffect(slowEffect)
	}

	@IBAction func stopAudio(sender: UIButton) {
		audioEngine.stop()
	}

	// MARK: - Private

	private func playAudioWithEffect(effect: AVAudioUnit) {
		audioEngine.stop()
		audioEngine.reset()

		var audioPlayerNode = AVAudioPlayerNode()
		audioEngine.attachNode(audioPlayerNode)
		audioEngine.attachNode(effect)

		audioEngine.connect(audioPlayerNode, to: effect, format: nil)
		audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)

		audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
		audioEngine.startAndReturnError(nil)

		audioPlayerNode.play()
	}

}
