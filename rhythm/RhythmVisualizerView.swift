//
//  DocumentViewController.swift
//  rhythm
//
//  Created by GØDØFIMØ on 12/8/25.
//

import AVFAudio
import Accelerate
import UIKit

protocol RhythmVisualizer: UIView {
    
    var buffer: AVAudioPCMBuffer? { get set }
    
    func updateBuffer(_ buffer: AVAudioPCMBuffer?)
    
}

class RhythmVisualizerView: UIView, RhythmVisualizer {

    var buffer: AVAudioPCMBuffer?

    override func draw(_ rect: CGRect) {

        guard let buffer = buffer,
            let channelData = buffer.floatChannelData?[0]
        else { return }

        let frameCount = Int(buffer.frameLength)
        var window = [Float](repeating: 0, count: frameCount)
        vDSP_hann_window(
            &window,
            vDSP_Length(frameCount),
            Int32(vDSP_HANN_NORM)
        )

        var samples = [Float](repeating: 0, count: frameCount)
        vDSP_vmul(
            channelData,
            1,
            window,
            1,
            &samples,
            1,
            vDSP_Length(frameCount)
        )

        let log2n = vDSP_Length(log2(Float(frameCount)))
        let fftSetup = vDSP_create_fftsetup(log2n, Int32(kFFTRadix2))!

        var real = [Float](repeating: 0, count: frameCount / 2)
        var imag = [Float](repeating: 0, count: frameCount / 2)
        var magnitudes = [Float](repeating: 0.0, count: frameCount / 2)

        real.withUnsafeMutableBufferPointer { realPtr in
            imag.withUnsafeMutableBufferPointer { imagPtr in
                var complexBuffer = DSPSplitComplex(
                    realp: realPtr.baseAddress!,
                    imagp: imagPtr.baseAddress!
                )

                samples.withUnsafeBufferPointer { samplesPtr in
                    samplesPtr.baseAddress!.withMemoryRebound(
                        to: DSPComplex.self,
                        capacity: frameCount
                    ) { typeConvertedTransferBuffer in
                        vDSP_ctoz(
                            typeConvertedTransferBuffer,
                            2,
                            &complexBuffer,
                            1,
                            vDSP_Length(frameCount / 2)
                        )
                    }
                }

                vDSP_fft_zrip(
                    fftSetup,
                    &complexBuffer,
                    1,
                    log2n,
                    Int32(FFT_FORWARD)
                )

                vDSP_zvmags(
                    &complexBuffer,
                    1,
                    &magnitudes,
                    1,
                    vDSP_Length(frameCount / 2)
                )
            }
        }
        vDSP_destroy_fftsetup(fftSetup)

        let barCount = 300
        let amplitudeScale: CGFloat = 0.03
        let step = magnitudes.count / barCount

        var values: [CGFloat] = []
        for i in 0..<barCount {
            let start = i * step
            let end = (i + 1) * step
            let slice = magnitudes[start..<end]
            let avg = sqrt(slice.reduce(0, +) / Float(slice.count))
            values.append(CGFloat(avg))
        }

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: rect.height))

        for i in 0..<values.count {
            let x = CGFloat(i) * (rect.width / CGFloat(values.count))
            let barHeight = values[i] * (rect.height / 2) * amplitudeScale
            let y = rect.height - barHeight
            
            if i == 0 {
                path.addLine(to: CGPoint(x: x, y: y))
            } else {
                let prevX = CGFloat(i - 1) * (rect.width / CGFloat(values.count))
                let prevBarHeight = values[i - 1] * rect.height * amplitudeScale
                let prevY = rect.height - prevBarHeight
                
                let midX = (prevX + x) / 2
                let midY = (prevY + y) / 2
                
                path.addQuadCurve(to: CGPoint(x: midX, y: midY),
                                  controlPoint: CGPoint(x: prevX, y: prevY))
                path.addQuadCurve(to: CGPoint(x: x, y: y),
                                  controlPoint: CGPoint(x: x, y: y))
            }
        }

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.close()

        let context = UIGraphicsGetCurrentContext()!
        context.clear(rect)
        context.setFillColor(UIColor.red.cgColor)
        context.addPath(path.cgPath)
        context.fillPath()

    }

    func updateBuffer(_ buffer: AVAudioPCMBuffer?) {
        self.buffer = buffer
        setNeedsDisplay()
    }

}
