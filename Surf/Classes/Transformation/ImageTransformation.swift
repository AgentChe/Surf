//
//  ImageTransformation.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 21/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

final class ImageTransformation {
    typealias UploadedImage = (url: String?, error: String?)
    
    static func imageUrlFromUploadChatImageResponse(response: Any) -> UploadedImage {
        guard let json = response as? [String: Any] else {
            return (nil, nil)
        }
        
        return (json["result"] as? String, nil)
    }
}
