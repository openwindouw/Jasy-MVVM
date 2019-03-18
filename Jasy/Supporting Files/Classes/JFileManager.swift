//
//  JFileManager.swift
//  Jasy
//
//  Created by Vladimir Espinola on 3/18/19.
//  Copyright © 2019 Vladimir Espinola. All rights reserved.
//

import UIKit

struct JFileManager {
    
    static let folderName = "upload"
    
    private init() {}
    static let shared = JFileManager()

    static func writeImageTo(path:String, image:UIImage) {
        let uploadURL = URL.createFolder(folderName: JFileManager.folderName)!.appendingPathComponent(path)
        
        if !FileManager.default.fileExists(atPath: uploadURL.path) {
            print("File does NOT exist -- \(uploadURL) -- is available for use")
            let data = image.jpegData(compressionQuality: 1)
            do {
                print("Write image")
                try data!.write(to: uploadURL)
            }
            catch {
                print("Error Writing Image: \(error)")
            }
        } else {
            print("This file exists -- something is already placed at this location")
        }
    }

    static func getImageTo(path: String) -> UIImage? {
        guard let uploadURL = URL.createFolder(folderName: JFileManager.folderName)?.appendingPathComponent(path) else { return nil }
        guard FileManager.default.fileExists(atPath: uploadURL.path), let image = UIImage(contentsOfFile: uploadURL.path) else { return nil }
        return image
    }
    
    static func deleteAll() {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let folderURL = documentDirectory.appendingPathComponent(JFileManager.folderName)
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
            
            for fileURL in fileURLs {
                try FileManager.default.removeItem(at: fileURL)
            }
            
        } catch  { print(error) }
    }
}


