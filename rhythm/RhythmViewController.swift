//
//  DocumentViewController.swift
//  rhythm
//
//  Created by GØDØFIMØ on 12/8/25.
//

import SwiftUI
import UIKit

class RhythmViewController: UIViewController {

    public var viewModel: RhythmAudioPlayer

    init(viewModel: RhythmAudioPlayer) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let visualizerView = RhythmVisualizerView()
        visualizerView.backgroundColor = .clear
        visualizerView.translatesAutoresizingMaskIntoConstraints = false

        viewModel.onBufferUpdate = { buffer in
            guard let buffer = buffer else { return }

            DispatchQueue.main.async {
                visualizerView.updateBuffer(buffer)
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
        view.addSubview(visualizerView)

        NSLayoutConstraint.activate([

            visualizerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            visualizerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            visualizerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            visualizerView.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -16), 

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
        viewModel.upload()
    }

    @objc func playAudio() {
        viewModel.play()
    }

    @objc func pauseAudio() {
        viewModel.pause()
    }

}
