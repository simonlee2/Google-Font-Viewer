//
//  FontManager.swift
//  Google Font Viewer
//
//  Created by Shao-Ping Lee on 5/30/17.
//  Copyright © 2017 Simon Lee. All rights reserved.
//

import Foundation
import PromiseKit

class FontManager {
    var postScriptNameMapping: [String: String]
    
    init(postScriptNameMapping: [String: String] = [:]) {
        self.postScriptNameMapping = postScriptNameMapping
    }
    
    func loadFont(font: GoogleFont) -> Promise<Bool> {
        //TODO: Request goes through GoogleFontAPI
        return Alamofire.request(font.externalDocumentURL).responseData().then { data in
            self.registerFont(font, data: data as CFData)
        }
    }
    
    func registerFont(_ font: GoogleFont, data: CFData) -> Bool {
        let provider = CGDataProvider(data: data)
        let cgfont = CGFont(provider!)
        var err: Unmanaged<CFError>?
        
        guard CTFontManagerRegisterGraphicsFont(cgfont, &err) else {
            print("Cannot load \(font.name)")
            return false
        }
        
        guard let postScriptName = cgfont.postScriptName as String? else {
            CTFontManagerUnregisterGraphicsFont(cgfont, nil)
            return false
        }
        
        postScriptNameMapping[font.name] = postScriptName
        print("Loaded \(cgfont.postScriptName ?? font.name as CFString)")
        
        return true
    }
    
    func downloadFont(url: String) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
            documentsURL.appendPathComponent("font.ttf")
            return (documentsURL, [.removePreviousFile])
            
        }
        
        Alamofire.download(url, to: destination).response { response in
            print(response.destinationURL ?? "")
        }
    }
}
