//
//  GoogleFont.swift
//  Google Font Viewer
//
//  Created by Shao-Ping Lee on 5/30/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import Foundation

struct GoogleFont {
    let family: String
    let variant: String
    let externalDocumentURL: String
    //    let internalDocumentURL: String
    var name: String {
        return "\(family)-\(variant)"
    }
}
