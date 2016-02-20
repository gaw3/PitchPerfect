//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Gregory White on 9/2/15.
//  Copyright (c) 2015-2016 Gregory White. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

final internal class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

	// MARK: - Private Constants

	private struct Strings {
		static let StatusPaused    = "Recording Paused..."
		static let StatusRecording = "Recording..."
		static let StatusTap       = "Tap to Record"
		static let FileName        = "my_audio.wav"
	}

	// MARK: - Private Stored Variables

	private var audioRecorder: AVAudioRecorder?
	private var recordedAudio: RecordedAudio?

	// MARK: - Private Computed Variables

	private var docsDir: String {
		return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
	}

	private var audioSession: AVAudioSession {
		return AVAudioSession.sharedInstance()
	}

	// MARK: - IB Outlets

	@IBOutlet weak internal var pauseButton:     UIButton!
	@IBOutlet weak internal var recordingStatus: UILabel!
	@IBOutlet weak internal var recordButton:    UIButton!
	@IBOutlet weak internal var resumeButton:    UIButton!
	@IBOutlet weak internal var stopButton:      UIButton!

	// MARK: - View Events

	override internal func viewDidLoad() {
		super.viewDidLoad()
	}

	override internal func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		stopButton.hidden    = true
		stopButton.enabled   = false

		pauseButton.hidden   = true
		pauseButton.enabled  = false

		resumeButton.hidden  = true
		resumeButton.enabled = false

		recordButton.hidden  = false
		recordButton.enabled = true

		recordingStatus.text = Strings.StatusTap
	}

	// MARK: - IB Actions

	@IBAction internal func pauseRecording(sender: UIButton) {
		assert(sender == pauseButton, "rcvd pause action from unknown button")

		audioRecorder?.pause()
		recordingStatus.text = Strings.StatusPaused
		stopButton.enabled   = false
		pauseButton.enabled  = false
		resumeButton.enabled = true
	}

	@IBAction internal func resumeRecording(sender: UIButton) {
		assert(sender == resumeButton, "rcvd resume action from unknown button")

		audioRecorder?.record()
		recordingStatus.text = Strings.StatusRecording
		stopButton.enabled   = true
		pauseButton.enabled  = true
		resumeButton.enabled = false
	}

	@IBAction internal func startRecording(sender: UIButton) {
		assert(sender == recordButton, "rcvd record action from unknown button")

		recordingStatus.text = Strings.StatusRecording
		recordButton.enabled = false

		stopButton.hidden    = false
		stopButton.enabled   = true

		pauseButton.hidden   = false
		pauseButton.enabled  = true

		resumeButton.hidden  = false

		do {
			try audioSession.setCategory(AVAudioSessionCategoryRecord)
			
			let filePath = NSURL.fileURLWithPathComponents([docsDir, Strings.FileName])
			
			audioRecorder = try AVAudioRecorder(URL: filePath!, settings: [:])
			audioRecorder?.delegate = self
			audioRecorder?.meteringEnabled = true
			audioRecorder?.prepareToRecord()
			audioRecorder?.record()
		} catch let error as NSError {
			print("Unable to start recording; error = \(error.localizedDescription)")
		}

	}

	@IBAction internal func stopRecording(sender: UIButton) {
		assert(sender == stopButton, "rcvd stop action from unknown button")

		recordingStatus.text = Strings.StatusTap
		audioRecorder?.stop()

		do {
			try audioSession.setActive(false)
		} catch let error as NSError {
			print("Unable to stop recording session; error = \(error.localizedDescription)")
		}
		
	}

	// MARK: - Navigation

	override internal func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

		if (segue.identifier == PlaySoundsViewController.UI.SegueID) {
			let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
			playSoundsVC.receivedAudio = recordedAudio
		}

	}

	// MARK: - AVAudioRecorderDelegate

	internal func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {

		if flag {
			recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
			performSegueWithIdentifier(PlaySoundsViewController.UI.SegueID, sender: nil)
		} else {
			recordButton.enabled = true
			stopButton.hidden = true
		}

	}

}