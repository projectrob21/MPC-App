//
//  MPCViewController.swift
//
//
//  Created by Robert Deans on 12/18/16.
//
//

import UIKit
import AVFoundation

class MPCViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIGestureRecognizerDelegate {
    
    var mpcView: MPCView!
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var recordingSession: AVAudioSession!
    var reverbUnit: AVAudioUnitReverb!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Set up ViewController
    func configure() {
        mpcView = MPCView()
        view.addSubview(mpcView)
        mpcView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        assignGestureRecognizers()
        assignButtonTargets()
        mpcView.recordButton.addTarget(self, action: #selector(recordAudio(_:)), for: .touchUpInside)
        
        /*
        reverbUnit = AVAudioUnitReverb()
        reverbUnit.wetDryMix = 50
        reverbUnit.loadFactoryPreset(.largeHall)
        */
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("microphone permissions granted")
                    } else {
                        print("microphone permissions denied")
                    }
                }
            }
        } catch {
            print("failed to ser upt recordingSession")
        }
        
    }

    
    func assignGestureRecognizers() {
        
        let recognizer1 = UILongPressGestureRecognizer(target: self, action: #selector(setupRecorder(_:)))
        recognizer1.delegate = self
        mpcView.padView1.addGestureRecognizer(recognizer1)
            
        let recognizer2 = UILongPressGestureRecognizer(target: self, action: #selector(setupRecorder(_:)))
        recognizer2.delegate = self
        mpcView.padView2.addGestureRecognizer(recognizer2)
        
        let recognizer3 = UILongPressGestureRecognizer(target: self, action: #selector(setupRecorder(_:)))
        recognizer3.delegate = self
        mpcView.padView3.addGestureRecognizer(recognizer3)
    }
    
    func assignButtonTargets() {
        for padButton in mpcView.padButtonArray {
            padButton.addTarget(self, action: #selector(padTapped(_:)), for: .touchUpInside)
        }
        
    }
    
    func setupRecorder(_ sender: UILongPressGestureRecognizer) {
        for view in mpcView.padViewArray {
            view.backgroundColor = UIColor.orange
        }
        sender.view?.backgroundColor = UIColor.green
        
        guard let padViewTag = sender.view?.tag else { print("error uwnrapping view tag"); return }
        let audioFile = "padButton\(padViewTag).audioFile.m4a"
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let audioFilename = documentsDirectory.appendingPathComponent(audioFile)
        
        let settings = [AVFormatIDKey : Int(kAudioFormatAppleLossless),
                        AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                        AVNumberOfChannelsKey: 1,
                        AVSampleRateKey: 44100.0 ] as [String : Any]
        
        do {
            audioRecorder =  try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            print("ready to record at \(audioFilename)")
        } catch {
            if let err = error as Error? {
                print("AVAudioRecorder error: \(err.localizedDescription)")
                audioRecorder = nil
            }
        }
    }
    

    func recordAudio(_ sender: UIButton) {
        if sender.titleLabel?.text == "Record" {
            audioRecorder.record()
            sender.setTitle("Stop", for: .normal)
            print("recording file at \(audioRecorder.url)")
        } else {
            audioRecorder.stop()
            sender.setTitle("Record", for: .normal)
        }
    }
    
    func padTapped(_ padButton: UIButton) {
        preparePlayer(for: padButton.tag)
        guard let unwrappedAudioPlayer = audioPlayer else { print("could not unwrap audioPlayer, no file"); return }
        unwrappedAudioPlayer.play()
    }
    
    func preparePlayer(for padButtonTag: Int) {
        let audioFile = "padButton\(padButtonTag).audioFile.m4a"
        print("playing audio from \(getFileURL(audioFile))")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileURL(audioFile))
            audioPlayer.delegate = self
            audioPlayer.volume = 1.0
        } catch {
            if let err = error as Error? {
                print("AVAudioPlayer error: \(err.localizedDescription)")
                audioPlayer = nil
            }
        }
    }
    
    func getFileURL(_ fileName: String) -> URL {
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent(fileName)
        return soundURL
    }
    
}
