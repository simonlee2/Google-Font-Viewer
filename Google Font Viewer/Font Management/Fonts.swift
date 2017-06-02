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
    internal let downloader: GoogleFontDownloader
    internal let manager: FontManager
    
    // Keep track of on-going font tasks
    internal var tasks: [String: FontTask] = [:]
    
    private init() {
        downloader = GoogleFontDownloader()
        manager = FontManager()
    }
    
    internal func fontTask(for font: GoogleFont, size: CGFloat) -> FontTask? {
        let (promise, cancel) = self.manager.font(for: font, size: size)
        return FontTask(family: font.family, variant: font.variant, promise: promise, cancel: cancel)
    }
}


// Public API
extension Fonts {
    
    /// An array of fonts by taking one font for each available family and prioritizing their regular variant
    var fontFamilies: [GoogleFont] {
        let families = downloader.fontMapping.values.sorted { a, b in
            a.family < b.family
        }
        
        return families.flatMap { family in
            downloader.font(family: family.family, variant: "regular")
        }
    }
    
    // MARK: Add and remove tasks
    
    
    /// Add task for a font. A new task will be created if none exist yet. 
    /// The caller can modify the task and is responsible for starting the task
    ///
    /// - Parameters:
    ///   - font: `GoogleFont`
    ///   - size: font size
    /// - Returns: Task for fetching the font
    func addTask(for font: GoogleFont, size: CGFloat) -> FontTask? {
        let task = tasks[font.name] ?? fontTask(for: font, size: size)
        tasks[font.name] = task
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
