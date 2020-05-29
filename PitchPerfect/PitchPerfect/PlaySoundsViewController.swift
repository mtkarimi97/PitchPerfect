//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Administrator on 2/3/20.
//  Copyright © 2020 Walek. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    // The file path of the audio file
    var recordedAudioURL: URL!
    // The audio file to play back
    var audioFile:AVAudioFile!
    // The engine that plays the sounds
    var audioEngine:AVAudioEngine!
    // Not used (why?)
    var audioPlayerNode: AVAudioPlayerNode!
    // Timer for playing/stopping the audio
    var stopTimer: Timer!

    // Enumeration for the different playback options
    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    // MARK: Outlets
    // Playback buttons
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // MARK: Actions
    
    /*
     * Play the sound based on the button pressed, with the modification
     */
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch (ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    /*
     * Stop the audio
     */
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }
    
    /*
     * Setup the audio (calls function in PlaySoundsViewController-Audio.swift file)
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupAudio()
    }
    
    /*
     * Start UI with nothing playing
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
}
