//
//  FontTableViewCell.swift
//  Google Font Viewer
//
//  Created by Shao-Ping Lee on 5/31/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import UIKit

class FontTableViewCell: UITableViewCell {
    let fontSize: CGFloat = 20
    
    func configure(for family: String) {
        Fonts.shared.font(for: family, size: fontSize).then { uifont -> Void in
            self.textLabel?.font = uifont
            self.textLabel?.text = family
            UIView.animate(withDuration: 0.3) {
                self.textLabel?.alpha = 1
            }
            }.catch { error in
                print(error)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel?.text = nil
        textLabel?.alpha = 0
    }
}
