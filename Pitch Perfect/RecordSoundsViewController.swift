//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Gregory White on 9/2/15.
//  Copyright (c) 2015 Gregory White. All rights reserved.
//

import AVFoundation
import UIKit

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

	// MARK: - IB Outlets

	@IBOutlet weak var pauseButton: UIButton!
	@IBOutlet weak var recordingStatus: UILabel!
	@IBOutlet weak var recordButton: UIButton!
	@IBOutlet weak var resumeButton: UIButton!
	@IBOutlet weak var stopButton: UIButton!

	// MARK: - Class Variables

	var audioRecorder: AVAudioRecorder!
	var recordedAudio: RecordedAudio!

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(animated: Bool) {
		stopButton.hidden = true
		stopButton.enabled = false

		pauseButton.hidden = true
		pauseButton.enabled = false

		resumeButton.hidden = true
		resumeButton.enabled = false

		recordButton.hidden = false
		recordButton.enabled = true

		recordingStatus.text = "Tap to Record"
	}

	// MARK: - IB Actions

	@IBAction func pauseRecording(sender: UIButton) {
		audioRecorder.pause()
		recordingStatus.text = "Recording Paused..."
		stopButton.enabled = false
		pauseButton.enabled = false
		resumeButton.enabled = true
	}

	@IBAction func resumeRecording(sender: UIButton) {
		audioRecorder.record()
		recordingStatus.text = "Recording..."
		stopButton.enabled = true
		pauseButton.enabled = true
		resumeButton.enabled = false
	}

	@IBAction func startRecording(sender: UIButton) {
		recordingStatus.text = "Recording..."
		recordButton.enabled = false

		stopButton.hidden = false
		stopButton.enabled = true

		pauseButton.hidden = false
		pauseButton.enabled = true

		resumeButton.hidden = false

		let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
		let recordingName = "my_audio.wav"
		let pathArray = [dirPath, recordingName]
		let filePath = NSURL.fileURLWithPathComponents(pathArray)

		var session = AVAudioSession.sharedInstance()
		session.setCategory(AVAudioSessionCategoryRecord, error: nil)

		audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
		audioRecorder.delegate = self
		audioRecorder.meteringEnabled = true
		audioRecorder.prepareToRecord()
		audioRecorder.record()
	}

	@IBAction func stopRecording(sender: UIButton) {
		recordingStatus.text = "Tap to Record"
		audioRecorder.stop()

		var audioSession = AVAudioSession.sharedInstance()
		audioSession.setActive(false, error: nil)
	}

	// MARK: - Navigation

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "stopRecording") {
			let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
			let data = sender as! RecordedAudio
			playSoundsVC.receivedAudio = data
		}
	}

	// MARK: - AVAudioRecorderDelegate

	func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
		if (flag) {
			recordedAudio = RecordedAudio(filePathUrl: recorder.url,	title: recorder.url.lastPathComponent!)
			performSegueWithIdentifier("stopRecording", sender: recordedAudio)
		} else {
			recordButton.enabled = true
			stopButton.hidden = true
		}
	}

}