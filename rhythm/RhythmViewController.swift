//
//  DocumentViewController.swift
//  rhythm
//
//  Created by GØDØFIMØ on 12/8/25.
//

import SwiftUI
import UIKit

class RhythmViewController: UIViewController {

    var viewModel = RhythmViewModel()

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

        
        let uploadButtonBiew = PrimaryButton()
        uploadButtonBiew.setTitle("upload", for: .normal)
        uploadButtonBiew.addTarget(
            self,
            action: #selector(uploadAudio),
            for: .touchUpInside
        )

        let playButtonView = PrimaryButton()

        playButtonView.setTitle("play", for: .normal)
        playButtonView.addTarget(
            self,
            action: #selector(playAudio),
            for: .touchUpInside
        )

        let pauseButtonView = PrimaryButton()

        pauseButtonView.setTitle("pause", for: .normal)
        pauseButtonView.addTarget(
            self,
            action: #selector(pauseAudio),
            for: .touchUpInside
        )

        [
            visualizerView,
            uploadButtonBiew,
            playButtonView,
            pauseButtonView,
        ].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([

            visualizerView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            visualizerView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),

            visualizerView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),

            visualizerView.heightAnchor.constraint(
                equalToConstant: view.frame.height / 2
            ),

            uploadButtonBiew.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            uploadButtonBiew.topAnchor.constraint(
                equalTo: visualizerView.bottomAnchor,
                constant: 16
            ),
            uploadButtonBiew.widthAnchor.constraint(equalToConstant: 300),
            uploadButtonBiew.heightAnchor.constraint(equalToConstant: 46),

            playButtonView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            playButtonView.topAnchor.constraint(
                equalTo: uploadButtonBiew.bottomAnchor,
                constant: 16
            ),
            playButtonView.widthAnchor.constraint(equalToConstant: 300),
            playButtonView.heightAnchor.constraint(equalToConstant: 46),

            pauseButtonView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            pauseButtonView.topAnchor.constraint(
                equalTo: playButtonView.bottomAnchor,
                constant: 16
            ),
            pauseButtonView.widthAnchor.constraint(equalToConstant: 300),
            pauseButtonView.heightAnchor.constraint(equalToConstant: 46),

        ])

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

class PrimaryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        backgroundColor = .systemBlue
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        layer.cornerRadius = 8
        translatesAutoresizingMaskIntoConstraints = false
    }
}
