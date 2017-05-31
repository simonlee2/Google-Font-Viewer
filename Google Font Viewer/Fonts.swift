//
//  Fonts.swift
//  Google Font Viewer
//
//  Created by Shao-Ping Lee on 5/30/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import UIKit
import PromiseKit

class Fonts {
    static let shared = Fonts()
    private let downloader: GoogleFontDownloader
    private let manager: FontManager
    
    
    private init() {
        downloader = GoogleFontDownloader()
        manager = FontManager()
    }
    
    func font(for family: String, size: CGFloat) -> (Promise<UIFont?>, () -> Void) {
        let getFont: () -> (Promise<UIFont?>, () -> Void) = {
            if let font = self.downloader.font(family: family, variant: "regular") {
                return self.manager.font(for: font, size: size)
            }
            
            return (Promise(value: nil), {})
        }
        
        let (promise, cancel) = getFont()
        
        if downloader.fontMapping.isEmpty {
            return (firstly {
                fetchAllFamilies()
            }.then { _ in
                return promise
            }, cancel)
        }
        
        return (promise, cancel)
    }
    
    func fetchAllFamilies(sortType: SortType? = nil) -> Promise<[GoogleFontFamily]> {
        return downloader.fetchAllFamilies(sortType: sortType)
    }
    
    var fontFamilies: [String] {
        return Array(downloader.fontMapping.keys.sorted())
    }
}
