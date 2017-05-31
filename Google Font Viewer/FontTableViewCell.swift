//
//  FontTableViewCell.swift
//  Google Font Viewer
//
//  Created by Shao-Ping Lee on 5/31/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import UIKit
import PromiseKit

class FontTableViewCell: UITableViewCell {
    let fontSize: CGFloat = 30
    var cancel: (() -> Void)?
    
    func configure(for family: String) {
        textLabel?.text = ""
        textLabel?.alpha = 0
        
        let (fontPromise, cancel) = Fonts.shared.font(for: family, size: fontSize)
        self.cancel = cancel
        
        fontPromise.then { [weak self] uifont -> Void in
            self?.textLabel?.font = uifont
            self?.textLabel?.text = family
            
            UIView.animate(withDuration: 0.3) {
                self?.textLabel?.alpha = 1
            }
        }.catch { error in
            print(error)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancel?()
        
        textLabel?.text = ""
        textLabel?.alpha = 0
    }
}
