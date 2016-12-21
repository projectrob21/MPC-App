//
//  Pad View.swift
//  MPCApp
//
//  Created by Robert Deans on 12/18/16.
//  Copyright © 2016 Robert Deans. All rights reserved.
//

import Foundation
import AVFoundation
import SnapKit
import UIKit

class MPCView: UIView {
    
    var padButton1: PadButton!
    var padButton2: PadButton!
    var padButton3: PadButton!
    
    var padView1: PadView!
    var padView2: PadView!
    var padView3: PadView!

    var padButtonArray = [PadButton]()
    var padViewArray = [PadView]()
    
    var reverbSlider: UISlider!
    var delaySlider: UISlider!
    var pitchSlider: UISlider!
    
    var recordButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        configure()
        constrain()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        padButton1 = PadButton()
        padButton2 = PadButton()
        padButton3 = PadButton()
        
        padView1 = PadView()
        padView2 = PadView()
        padView3 = PadView()
        
        padButtonArray = [padButton1, padButton2, padButton3]
        padViewArray = [padView1, padView2, padView3]
        
        var padViewTag = 0
        for view in padViewArray {
            padViewTag += 1
            view.tag = padViewTag
            view.backgroundColor = UIColor.orange
            view.layer.cornerRadius = 25
        }

        var padButtonTag = 0
        for button in padButtonArray {
            padButtonTag += 1
            button.tag = padButtonTag
            button.layer.cornerRadius = 20
            button.backgroundColor = UIColor.cyan
        }

        reverbSlider = UISlider()
        delaySlider = UISlider()
        pitchSlider = UISlider()
        
        recordButton = UIButton()
        recordButton.titleLabel?.text = "Record"
        recordButton.titleLabel?.textColor = UIColor.white
        recordButton.backgroundColor = UIColor.red.withAlphaComponent(0.5)

    }
    
    func constrain() {
        
        addSubview(padView1)
        padView1.snp.makeConstraints() {
            $0.topMargin.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalToSuperview().dividedBy(4)
            $0.height.equalTo(padView1.snp.width)
        }
        
        padView1.addSubview(padButton1)
        padButton1.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsetsMake(5, 5, 5, 5))
        }
        
        addSubview(padView2)
        padView2.snp.makeConstraints {
            $0.topMargin.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(4)
            $0.height.equalTo(padView2.snp.width)
        }
        
        padView2.addSubview(padButton2)
        padButton2.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsetsMake(5, 5, 5, 5))
        }

        addSubview(padView3)
        padView3.snp.makeConstraints {
            $0.topMargin.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalToSuperview().dividedBy(4)
            $0.height.equalTo(padView3.snp.width)
        }
        
        padView3.addSubview(padButton3)
        padButton3.snp.makeConstraints {
            $0.edges.equalTo(UIEdgeInsetsMake(5, 5, 5, 5))
        }
        
        addSubview(reverbSlider)
        reverbSlider.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.75)
        }
        
        addSubview(recordButton)
        recordButton.snp.makeConstraints {
            $0.bottomMargin.equalToSuperview().offset(-10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(2)
            $0.height.equalToSuperview().dividedBy(10)
        }
        
    }
    
    
    
}
