//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Gregory White on 9/2/15.
//  Copyright (c) 2015-2016 Gregory White. All rights reserved.
//

import AVFoundation
import UIKit

final class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: - Private Constants

    fileprivate struct AlertTitle {
        static let UnableToStart = "Unable to start recording"
        static let UnableToStop  = "Unable to stop recording"
    }

    fileprivate struct Strings {
        static let StatusPaused    = "Recording Paused..."
        static let StatusRecording = "Recording..."
        static let StatusTap       = "Tap to Record"
        static let FileName        = "my_audio.wav"
    }

    // MARK: - Private Stored Variables

    fileprivate var audioRecorder: AVAudioRecorder?
    fileprivate var recordedAudio: RecordedAudio?

    // MARK: - Private Computed Variables

    fileprivate var docsDir: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }

    fileprivate var audioSession: AVAudioSession {
        return AVAudioSession.sharedInstance()
    }

    // MARK: - IB Outlets

    @IBOutlet weak var pauseButton:     UIButton!
    @IBOutlet weak var recordingStatus: UILabel!
    @IBOutlet weak var recordButton:    UIButton!
    @IBOutlet weak var resumeButton:    UIButton!
    @IBOutlet weak var stopButton:      UIButton!

    // MARK: - View Events

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        stopButton.isHidden    = true
        stopButton.isEnabled   = false

        pauseButton.isHidden   = true
        pauseButton.isEnabled  = false

        resumeButton.isHidden  = true
        resumeButton.isEnabled = false

        recordButton.isHidden  = false
        recordButton.isEnabled = true

        recordingStatus.text = Strings.StatusTap
    }

    // MARK: - IB Actions

    @IBAction func pauseRecording(_ sender: UIButton) {
        assert(sender == pauseButton, "rcvd pause action from unknown button")

        audioRecorder?.pause()
        recordingStatus.text = Strings.StatusPaused
        stopButton.isEnabled   = false
        pauseButton.isEnabled  = false
        resumeButton.isEnabled = true
    }

    @IBAction func resumeRecording(_ sender: UIButton) {
        assert(sender == resumeButton, "rcvd resume action from unknown button")

        audioRecorder?.record()
        recordingStatus.text = Strings.StatusRecording
        stopButton.isEnabled   = true
        pauseButton.isEnabled  = true
        resumeButton.isEnabled = false
    }

    @IBAction func startRecording(_ sender: UIButton) {
        assert(sender == recordButton, "rcvd record action from unknown button")

        recordingStatus.text = Strings.StatusRecording
        recordButton.isEnabled = false

        stopButton.isHidden    = false
        stopButton.isEnabled   = true

        pauseButton.isHidden   = false
        pauseButton.isEnabled  = true

        resumeButton.isHidden  = false

        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)

            let filePath = URL(fileURLWithPath: "\(docsDir)/\(Strings.FileName)")

            audioRecorder = try AVAudioRecorder(url: filePath, settings: [:])
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        } catch let error as NSError {
            presentAlert(AlertTitle.UnableToStart, message:  error.localizedDescription)
        }

    }

    @IBAction func stopRecording(_ sender: UIButton) {
        assert(sender == stopButton, "rcvd stop action from unknown button")

        recordingStatus.text = Strings.StatusTap
        audioRecorder?.stop()

        do {
            try audioSession.setActive(false)
        } catch let error as NSError {
            presentAlert(AlertTitle.UnableToStop, message:  error.localizedDescription)
        }

    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == PlaySoundsViewController.UI.SegueID) {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            playSoundsVC.receivedAudio = recordedAudio
        }
        
    }
    
    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent)
            performSegue(withIdentifier: PlaySoundsViewController.UI.SegueID, sender: nil)
        } else {
            recordButton.isEnabled = true
            stopButton.isHidden = true
        }
        
    }
    
}
