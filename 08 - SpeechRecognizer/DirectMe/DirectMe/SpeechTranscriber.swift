//
//  SpeechTranscriber.swift
//  DirectMe
//
//  Created by Samuel Burnstone on 27/09/2016.
//  Copyright © 2016 ShinobiControls. All rights reserved.
//

import Speech

class SpeechTranscriber {
    
    /// Whether we are currently listening for audio input.
    private(set) var isTranscribing: Bool = false
    
    /// Closure executed when the recording finished and the speech recognizer was able to transcribe it.
    var onTranscriptionCompletion: ((String) -> ())?
    
    private let speechRecognizer = SFSpeechRecognizer()
    private let audioEngine = AVAudioEngine()
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    init() {
        SFSpeechRecognizer.requestAuthorization() {
            status in
            if status == .authorized {
                print("We're good to go!")
            }
            else {
                fatalError("Sorry, this demo is a bit pointless if you disable dictation")
            }
        }
    }
    
    /// Start listening to audio input from microphone.
    func start() {
        
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        do {
            try createAudioSession() {
                buffer in
                recognitionRequest.append(buffer)
            }
        }
        catch {
            fatalError("Error setting up microphone input listener!")
        }
        
        speechRecognizer?.recognitionTask(with: recognitionRequest) {
            [weak self]
            result, error in
            guard let result = result else {
                print(error?.localizedDescription)
                return
            }
            
            // Wait until we have the final result before calling our completion block
            if result.isFinal {
                self?.onTranscriptionCompletion?(result.bestTranscription.formattedString)
            }
        }
        
        // Store request for later use
        self.recognitionRequest = recognitionRequest
        
        isTranscribing = true
    }
    
    /// Stops the transcriber from listening to audio input from the microphone and tells the recognition request that audio has completed.
    func stop() {
        recognitionRequest?.endAudio()
        audioEngine.stop()
        audioEngine.inputNode?.removeTap(onBus: 0)
        isTranscribing = false
    }
    
    /// Sets up the audio session.
    private func createAudioSession(onNewBufferReceived: @escaping (AVAudioPCMBuffer) -> ()) throws {
        let audioSession = AVAudioSession.sharedInstance()
        
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            onNewBufferReceived(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()
    }
}
