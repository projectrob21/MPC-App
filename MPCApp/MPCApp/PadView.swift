//
//  PadView.swift
//  MPCApp
//
//  Created by Robert Deans on 12/19/16.
//  Copyright © 2016 Robert Deans. All rights reserved.
//

import Foundation
import UIKit

class PadView: UIView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}
