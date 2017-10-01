//
//  ViewController.swift
//  Deep Zone
//
//  Created by Hendrik Schäfer and Nicolo Frisiani on 20.01.17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import AudioKit

let mic = AKMicrophone()
let lpf = AKLowPassFilter.init(mic, cutoffFrequency: 500, resonance: 0)
let effect = AKOperationEffect(lpf, numberOfChannels: 2) {
    _, parameters in
    let leftDelay = AKOperation.leftInput.scaledBy(-1)
    let rightDelay = AKOperation.rightInput.scaledBy(-1)
    return [leftDelay, rightDelay]
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        AudioKit.output = effect
        
        if mic.isStarted
        mic.stop()
        
        AudioKit.start()
        setupPlot()
        setupPlot2()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LPF(_ sender: UISlider) {
        lpf.cutoffFrequency = Double(sender.value)
    }
    
    @IBAction func Gain(_ sender: UISlider) {
        mic.volume = Double(sender.value)
    }
    
    @IBAction func slider_effect(_ sender: UISlider) {
        //  wurst.balance = Double(sender.value)
    }
    
    @IBOutlet weak var OnOff: UISwitch!
    
    @IBOutlet var audioInputPlot: EZAudioPlot!
    func setupPlot()
    {
        let plot = AKNodeOutputPlot(lpf, frame: audioInputPlot.bounds)
        plot.plotType = .buffer
        plot.shouldFill = false
        plot.shouldMirror = false
        plot.color = UIColor.blue
        audioInputPlot.addSubview(plot)
    }
    
    @IBOutlet var helloplot: EZAudioPlot!
    func setupPlot2() {
        let plot2 = AKNodeOutputPlot(effect, frame: helloplot.bounds)
        plot2.plotType = .buffer
        plot2.shouldFill = false
        plot2.shouldMirror = false
        plot2.color = UIColor.red
        helloplot.addSubview(plot2)
    }
    
    @IBAction func onOffTapped(_ sender: Any) {
        if OnOff.isOn
        mic.start()
        else
        mic.stop()
    }
}

