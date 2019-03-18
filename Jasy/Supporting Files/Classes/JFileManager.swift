//
//  JFileManager.swift
//  Jasy
//
//  Created by Vladimir Espinola on 3/18/19.
//  Copyright © 2019 Vladimir Espinola. All rights reserved.
//

import UIKit

class JFileManager {
    static let folderName = "upload"
    static var shared = JFileManager()
    private init() {}

    func writeImageTo(path:String, image:UIImage) {
        let uploadURL = URL.createFolder(folderName: JFileManager.folderName)!.appendingPathComponent(path)
        
        let data = image.jpegData(compressionQuality: 1)
        do {
            print("Write image")
            try data!.write(to: uploadURL)
        }
        catch {
            print("Error Writing Image: \(error)")
        }
    }

    func getImageTo(path: String) -> UIImage? {
        guard let uploadURL = URL.createFolder(folderName: JFileManager.folderName)?.appendingPathComponent(path) else { return nil }
        guard FileManager.default.fileExists(atPath: uploadURL.path), let image = UIImage(contentsOfFile: uploadURL.path) else { return nil }
        return image
    }
    
    func deleteAll() {
        
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


