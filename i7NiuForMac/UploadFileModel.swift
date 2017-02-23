//
//  UploadFileModel.swift
//  i7NiuForMac
//
//  Created by hocgin on 20/02/2017.
//  Copyright © 2017 hocgin. All rights reserved.
//

import Foundation
import Cocoa

struct UploadFileModel {
    var imageUrl: String
    var filename: String
    var image: NSImage
    
    init(image: NSImage, url: String, filename: String) {
        self.image = image
        self.imageUrl = url
        self.filename = filename
    }
}
