//
//  Fonts.swift
//  DoggyBag
//
//  Created by Andrey Chernyshev on 18/11/2019.
//  Copyright © 2019 Andrey Chernyshev. All rights reserved.
//

import UIKit

final class Font {
    struct OpenSans {
        static func semibold(size: CGFloat) -> UIFont {
            UIFont(name: "OpenSans-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "OpenSans-Regular", size: size)!
        }
        
        static func light(size: CGFloat) -> UIFont {
            UIFont(name: "OpenSans-Light", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "OpenSans-Bold", size: size)!
        }
    }
    
    struct Montserrat {
        static func semibold(size: CGFloat) -> UIFont {
            UIFont(name: "Montserrat-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Montserrat-Regular", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Montserrat-Bold", size: size)!
        }
    }
    
    struct Poppins {
        static func semibold(size: CGFloat) -> UIFont {
            UIFont(name: "Poppins-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Poppins-Regular", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Poppins-Bold", size: size)!
        }
    }
    
    struct SFProText {
        static func semibold(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Semibold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Regular", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Medium", size: size)!
        }
        
        static func light(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Light", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Bold", size: size)!
        }
    }
}
