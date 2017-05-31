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
    // Single shared instance
    static let shared = Fonts()
    
    // Private instances to manage the downloading and registration of fonts
    private let downloader: GoogleFontDownloader
    private let manager: FontManager
    
    // Keep track of on-going font tasks
    var tasks: [String: FontTask] = [:]
    
    var fontFamilies: [String] {
        return Array(downloader.fontMapping.keys.sorted())
    }
    
    private init() {
        downloader = GoogleFontDownloader()
        manager = FontManager()
    }
    
    func task(for family: String, variant: String = "regular", size: CGFloat) -> FontTask {
        let (promise, cancel) = font(for: family, size: size)
        return FontTask(family: family, variant: variant, promise: promise, cancel: cancel)
    }
    
    func font(for family: String, variant: String = "regular", size: CGFloat) -> (Promise<UIFont?>, () -> Void) {
        let getFont: () -> (Promise<UIFont?>, () -> Void) = {
            if let font = self.downloader.font(family: family, variant: variant) {
                return self.manager.font(for: font, size: size)
            }
            print("No font mapping for \(family) \(variant)")
            return (Promise(value: nil), {})
        }
        
        let (promise, cancel) = getFont()
        
//        if downloader.fontMapping.isEmpty {
//            return (firstly {
//                fetchAllFamilies()
//            }.then { _ in
//                return promise
//            }, cancel)
//        }
        
        return (promise, cancel)
    }
    
    func fetchAllFamilies(sortType: SortType? = nil) -> Promise<[GoogleFontFamily]> {
        return downloader.fetchAllFamilies(sortType: sortType)
    }
}
