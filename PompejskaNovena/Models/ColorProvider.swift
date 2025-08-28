//
//  ColorProvider.swift
//  PompejskaNovena
//
//  Created by Jozef Pazúrik on 28/07/2025.
//
import UIKit

class ColorProvider {
    static let shared = ColorProvider()
    
    var backgroundColour: UIColor {
            return UIColor { trait in
                switch trait.userInterfaceStyle {
                case .dark:
                    return UIColor(red: 30/255, green: 30/255, blue: 40/255, alpha: 1.0) // Dark mode color
                default:
                    return UIColor(red: 153.0/225, green: 153.0/255, blue: 255.0/255, alpha: 1.0) // Light mode color
                }
            }
        }
        
    var buttonColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(red: 5/255, green: 5/255, blue: 30.0/255, alpha: 1.0)
            default:
                return UIColor.black.withAlphaComponent(0.2)
            }
        }
    }
    
    var grouppedBackroundColor: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor.black
            default:
                return UIColor.white.withAlphaComponent(0.7)
            }
        }
    }
}
