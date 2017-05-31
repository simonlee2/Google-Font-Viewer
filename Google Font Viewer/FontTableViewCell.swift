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
    let fontSize: CGFloat = 25
    
    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var fontBackgroundView: UIView! {
        didSet {
            fontBackgroundView.layer.cornerRadius = 5.0
            fontBackgroundView.clipsToBounds = true
        }
    }
    
    var task: FontTask?
    
    func configure(for fontTask: FontTask) {
        fontLabel?.text = ""
        fontLabel?.alpha = 0
        layer.backgroundColor = UIColor.clear.cgColor
        
        self.task = fontTask
        
        fontTask.promise.then { [weak self] uifont -> Void in
            
            self?.fontLabel?.font = uifont
            self?.fontLabel?.text = uifont?.familyName
            
            UIView.animate(withDuration: 0.3) {
                self?.fontLabel?.alpha = 1
            }
        }.catch { error in
            print(error)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let task = task {
            task.cancel?()
            Fonts.shared.tasks[task.family] = nil
        }
        
        fontLabel?.text = ""
        fontLabel?.alpha = 0
    }
}
