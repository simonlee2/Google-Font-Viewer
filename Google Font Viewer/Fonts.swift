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
    
    // Take one font for each available family, prioritizing regular variants
    var fontFamilies: [GoogleFont] {
        let families = downloader.fontMapping.values.sorted { a, b in
            a.family < b.family
        }
        
        return families.flatMap { family in
            downloader.font(family: family.family, variant: "regular")
        }
    }
    
    private init() {
        downloader = GoogleFontDownloader()
        manager = FontManager()
    }
    
    private func font(for family: String, variant: String = "regular", size: CGFloat) -> FontTask? {
        guard let font = self.downloader.font(family: family, variant: variant) else {
            return nil
        }
        
        let (promise, cancel) = self.manager.font(for: font, size: size)
        return FontTask(family: family, variant: variant, promise: promise, cancel: cancel)
    }
    
    // MARK: Add and remove tasks
    
    func task(for family: String, variant: String = "regular", size: CGFloat) -> FontTask? {
        let key = "\(family)-\(variant)"
        let task = tasks[key] ?? font(for: family, variant: variant, size: size)
        tasks[key] = task
        return task
    }
    
    @discardableResult func removeTask(for family: String, variant: String = "regular") -> FontTask? {
        let key = "\(family)-\(variant)"
        if let task = tasks[key] {
            task.cancel?()
            tasks[key] = nil
            return task
        }
        
        return nil
    }
    
    func fetchAllFamilies(sortType: SortType? = nil) -> Promise<[GoogleFontFamily]> {
        return downloader.fetchAllFamilies(sortType: sortType)
    }
}
