//
//  DocumentViewController.swift
//  rhythm
//
//  Created by GØDØFIMØ on 12/8/25.
//

import AVFAudio
import UIKit

class RhythmVisualizerView: UIView {

    var buffer: AVAudioPCMBuffer?

    override func draw(_ rect: CGRect) {

        guard let buffer = buffer,
            let channelData = buffer.floatChannelData?[0]
        else { return }

        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setLineWidth(1)

        let width = Int(rect.width)
        let samplesPerPixel = max(1, Int(buffer.frameLength) / width)

        context?.beginPath()
        
        for x in 0..<width {
            let sampleIndex = x * samplesPerPixel
            
            let sample = CGFloat(channelData[sampleIndex])
            
            let y = rect.height / 2 - sample * (rect.height / 2)
            if x == 0 {
                context?.move(to: CGPoint(x: CGFloat(x), y: y))
            } else {
                context?.addLine(to: CGPoint(x: CGFloat(x), y: y))
            }
        }
        
        context?.strokePath()

    }

    func updateBuffer(_ buffer: AVAudioPCMBuffer?) {
        self.buffer = buffer
        setNeedsDisplay()
    }

}
