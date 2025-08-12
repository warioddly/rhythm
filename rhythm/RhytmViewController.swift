//
//  DocumentViewController.swift
//  rhythm
//
//  Created by GØDØFIMØ on 12/8/25.
//

import UIKit

class RhytmViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.text = "Hello, World!"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
       
        let customView = CustomPaintView()
        customView.backgroundColor = .clear
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(customView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
  
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            customView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            customView.widthAnchor.constraint(equalToConstant: 300),
            customView.heightAnchor.constraint(equalToConstant: 300),
        ])

    }
}

class CustomPaintView: UIView {
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setFillColor(UIColor.red.cgColor)

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius: CGFloat = 80

        context.addArc(
            center: center,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: false
        )
        context.fillPath()
    }
}
