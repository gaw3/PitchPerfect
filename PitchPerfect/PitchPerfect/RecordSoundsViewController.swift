//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Gregory White on 9/2/15.
//  Copyright (c) 2015-2016 Gregory White. All rights reserved.
//

import AVFoundation
import UIKit

final class RecordSoundsViewController: UIViewController {

    // MARK: - Variables
    
    fileprivate var audioRecorder: AVAudioRecorder?
    fileprivate var recordedAudio: RecordedAudio?
    
    // MARK: - IB Outlets

    @IBOutlet weak var pauseButton:  UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var stopButton:   UIButton!

    @IBOutlet weak var recordingStatus: UILabel!

    // MARK: - IB Actions

    @IBAction func buttonWasTapped(_ button: UIButton) {

        switch button {

        case recordButton: startRecording()
        case pauseButton:  pauseRecording()
        case resumeButton: resumeRecording()
        case stopButton:   stopRecording()

        default: fatalError("Received action from unknown button = \(button)")
        }

    }

    // MARK: - View Events

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

}


// MARK: -
// MARK: - Navigation

extension RecordSoundsViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == IB.SegueID.SegueFromRecordToPlay) {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            playSoundsVC.receivedAudio = recordedAudio
        }

    }

}



// MARK: -
// MARK: - Audio Recorder Delegate

extension RecordSoundsViewController: AVAudioRecorderDelegate {

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {

        if flag {
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent)
            performSegue(withIdentifier: IB.SegueID.SegueFromRecordToPlay, sender: nil)
        } else {
            recordButton.isEnabled = true
            stopButton.isHidden = true
        }

    }

}



// MARK: -
// MARK: - Private Helpers

private extension RecordSoundsViewController {

    struct Strings {
        static let StatusPaused    = "Recording Paused..."
        static let StatusRecording = "Recording..."
        static let StatusTap       = "Tap to Record"
        static let FileName        = "my_audio.wav"
    }

    var docsDir: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }

    func pauseRecording() {
        audioRecorder?.pause()
        recordingStatus.text = Strings.StatusPaused
        stopButton.isEnabled   = false
        pauseButton.isEnabled  = false
        resumeButton.isEnabled = true
    }

    func resumeRecording() {
        audioRecorder?.record()
        recordingStatus.text = Strings.StatusRecording
        stopButton.isEnabled   = true
        pauseButton.isEnabled  = true
        resumeButton.isEnabled = false
    }

    func startRecording() {
        recordingStatus.text = Strings.StatusRecording
        recordButton.isEnabled = false

        stopButton.isHidden    = false
        stopButton.isEnabled   = true

        pauseButton.isHidden   = false
        pauseButton.isEnabled  = true

        resumeButton.isHidden  = false

        do {
            let pathArray = [docsDir, "my_audio.wav"]
            let filePath  = URL(string: pathArray.joined(separator: "/"))
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            audioRecorder = try AVAudioRecorder(url: filePath!, settings: [:])
            
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
        } catch let error as NSError {
            presentAlert(Alert.Title.UnableToStartRecording, message:  error.localizedDescription)
        }

    }

    func stopRecording() {
        recordingStatus.text = Strings.StatusTap
        audioRecorder?.stop()

        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch let error as NSError {
            presentAlert(Alert.Title.UnableToStopRecording, message:  error.localizedDescription)
        }
        
    }
    
}


