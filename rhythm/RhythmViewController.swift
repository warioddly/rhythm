//
//  DocumentViewController.swift
//  rhythm
//
//  Created by GØDØFIMØ on 12/8/25.
//

import SwiftUI
import UIKit

class RhythmViewController: UIViewController {

    var audioPlayer: RhythmAudioPlayer
    var visualizer: RhythmVisualizer
    
    init(audioPlayer: RhythmAudioPlayer, visualizer: RhythmVisualizer) {
        self.audioPlayer = audioPlayer
        self.visualizer = visualizer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visualizer.backgroundColor = .clear
        visualizer.translatesAutoresizingMaskIntoConstraints = false

        audioPlayer.onBufferUpdate = { buffer in
            guard let buffer = buffer else { return }

            DispatchQueue.main.async {
                self.visualizer.updateBuffer(buffer)
            }
        }

        let stack = UIStackView(arrangedSubviews: [
            makeButton("Upload", action: #selector(uploadAudio)),
            makeButton("Pause", action: #selector(pauseAudio)),
            makeButton("Play", action: #selector(playAudio)),
        ])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)
        view.addSubview(visualizer)

        NSLayoutConstraint.activate([

            visualizer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            visualizer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            visualizer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            visualizer.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -16),

            stack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            stack.heightAnchor.constraint(equalToConstant: 50),
            stack.widthAnchor.constraint(equalToConstant: 250)

        ])

    }
    
    func makeButton(_ title: String, action: Selector) -> UIView {
        let playButtonView = UIButton(type: .system)
        playButtonView.setTitle(title, for: .normal)
        playButtonView.addTarget(
            self,
            action: action,
            for: .touchUpInside
        )
        
        return playButtonView
    }

    @objc func uploadAudio() {
        audioPlayer.upload()
    }

    @objc func playAudio() {
        audioPlayer.play()
    }

    @objc func pauseAudio() {
        audioPlayer.pause()
    }

}
