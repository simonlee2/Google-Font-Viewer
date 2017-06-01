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
            // round corners
            fontBackgroundView.layer.cornerRadius = 5.0
            
            // shadows
            fontBackgroundView.layer.shadowColor = UIColor.black.cgColor
            fontBackgroundView.layer.shadowOpacity = 0.1
            fontBackgroundView.layer.shadowRadius = 3
            fontBackgroundView.layer.shadowOffset = CGSize.zero
            fontBackgroundView.layer.shadowPath = UIBezierPath(rect: fontBackgroundView.bounds).cgPath
        }
    }
    
    var task: FontTask?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.layer.setAffineTransform(CGAffineTransform(scaleX: 0.95, y: 0.95))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.layer.setAffineTransform(CGAffineTransform.identity)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.layer.setAffineTransform(CGAffineTransform.identity)
        }
        
    }
    
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
