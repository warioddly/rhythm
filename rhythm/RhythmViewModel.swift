//
//  DocumentViewController.swift
//  rhythm
//
//  Created by GØDØFIMØ on 12/8/25.
//

import AVFAudio

protocol RhythmAudioPlayer {

    func play()

    func pause()

    func upload()

    func reset()
    
    func stop()

}

class RhythmViewModel: RhythmAudioPlayer {

    var audio: AVAudioFile?

    let audioEngine = AVAudioEngine()
    let playerNode = AVAudioPlayerNode()

    var audioBuffer: AVAudioPCMBuffer? {
        didSet {
            onBufferUpdate?(audioBuffer)
        }
    }

    var onBufferUpdate: ((AVAudioPCMBuffer?) -> Void)?

    // MARK: - Play
    func play() {

        guard let audio else {
            print("Upload the audio file first")
            return
        }

        if playerNode.engine == nil {
            audioEngine.attach(playerNode)
            audioEngine.connect(
                playerNode,
                to: audioEngine.outputNode,
                format: audio.processingFormat
            )
        }

        do {
            if !audioEngine.isRunning {
                try audioEngine.start()
               
            }

            if !playerNode.isPlaying {
                playerNode.scheduleFile(
                    audio,
                    at: nil,
                    completionHandler: nil
                )
                playerNode.play()

                if playerNode.numberOfInputs == 0 {
                    playerNode.removeTap(onBus: 0)
                    playerNode.installTap(
                        onBus: 0,
                        bufferSize: 1024,
                        format: audio.processingFormat
                    ) { [weak self] buffer, _ in
                        self?.audioBuffer = buffer
                    }
                }
            }
        } catch {
            print("Audio Engine error:", error)
        }

    }

    // MARK: - Pause
    func pause() {

        if playerNode.isPlaying {
            playerNode.stop()
        }

    }

    // MARK: - Upload
    func upload() {

        guard
            let fileURL = Bundle.main.url(
                forResource: "Martin Garrix - Access",
                withExtension: "mp3"
            )
        else {
            fatalError("File not found")
        }

        do {
            audio = try AVAudioFile(forReading: fileURL)
            print("The audio uploaded: \(audio!)")
        } catch {
            print("Error when upload the audio file: \(error)")
        }

    }

    // MARK: - Reset
    func reset() {
        audioEngine.stop()
        audio = nil
    }

    // MARKL - Stop
    func stop() {
        if (audioEngine.isRunning) {
            audioEngine.stop()
        }
        if (playerNode.isPlaying) {
            playerNode.stop()
        }
    }
}
