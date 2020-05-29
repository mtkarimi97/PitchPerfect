//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Administrator on 1/23/20.
//  Copyright © 2020 Walek. All rights reserved.
//

import UIKit
import AVFoundation

/*
 This class provides the functionality to record audio
 */
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // Label with text on current options
    @IBOutlet weak var recordLabel: UILabel!
    // Button to record
    @IBOutlet weak var recordButton: UIButton!
    // Button to stop recoding
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // Does the audio recording
    var audioRecorder: AVAudioRecorder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        stopRecordingButton.isEnabled = false // start with stop recording button not enabled
    }
    
    // MARK: - Recording Functions
    
    /*
      * When record button is pressed, this function records audio, and recordLabel changes to reflect that
      * @param sender
     */
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(recording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String // getting the path where the file is going to be saved in the devices storage
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record() // start recording
    }
    
    /*
     * Stop recording when button pressed
     * @param sender
     */
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(recording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    /*
     * Sets the buttons to enabled or disabled and changes recordLabel according to the app state
     */
    func configureUI(recording: Bool) {
        if recording {
            stopRecordingButton.isEnabled = true
            recordButton.isEnabled = false
            recordLabel.text = "Recording in Progress"
        } else {
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
            recordLabel.text = "Tap to Record"
        }
    }
    
    // MARK: - Segue Functions
    
    /*
     * When finished recording, go to next screen to play back recorded sound
     * If error occurred, print that recording failed
     */
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording was not successful.")
        }
    }
    
    /*
     * This function passes the file path where the audio file is located to the next view controller
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
