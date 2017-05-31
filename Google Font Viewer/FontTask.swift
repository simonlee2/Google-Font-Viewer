//
//  FontTask.swift
//  Google Font Viewer
//
//  Created by Shao-Ping Lee on 5/31/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import Foundation
import PromiseKit

struct FontTask {
    let family: String
    let variant: String
    let promise: Promise<UIFont?>
    let cancel: (() -> Void)?
}
