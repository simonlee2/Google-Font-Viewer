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
    var task: FontTask?
    
    func configure(for fontTask: FontTask) {
        textLabel?.text = ""
        textLabel?.alpha = 0
        
        self.task = fontTask
        
        fontTask.promise.then { [weak self] uifont -> Void in
            
            self?.textLabel?.font = uifont
            self?.textLabel?.text = uifont?.familyName
            
            UIView.animate(withDuration: 0.3) {
                self?.textLabel?.alpha = 1
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
        
        textLabel?.text = ""
        textLabel?.alpha = 0
    }
}
