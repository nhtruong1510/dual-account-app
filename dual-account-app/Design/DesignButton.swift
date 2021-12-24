//
//  DesignButton.swift
//  babyheartbeat
//
//  Created by Huu Truong Nguyen on 9/11/21.
//

import UIKit

class DesignButton: UIButton {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = CGAffineTransform(rotationAngle: .pi/2)
        UIButton.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform.identity
        })
        super.touchesBegan(touches, with: event)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
