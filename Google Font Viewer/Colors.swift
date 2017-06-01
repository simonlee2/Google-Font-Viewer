//
//  Colors.swift
//  Google Font Viewer
//
//  Created by Shao-Ping Lee on 6/1/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import UIKit

enum Colors {
    case text
    case background
    case shadow
    
    var uicolor: UIColor {
        switch self {
        case .text:
            return UIColor(red: 5/255.0, green: 5/255.0, blue: 5/255.0, alpha: 1)
        case .background:
            return UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
        case .shadow:
            return UIColor.black
        }
    }
}

