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
                    return UIColor(red: 28/255, green: 27/255, blue: 31/255, alpha: 1.0)
                default:
                    return UIColor(red: 255/255, green: 251/255, blue: 254/255, alpha: 1.0)
                }
            }
        }

    var surfaceColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(red: 28/255, green: 27/255, blue: 31/255, alpha: 1.0)
            default:
                return UIColor(red: 255/255, green: 251/255, blue: 254/255, alpha: 1.0)
            }
        }
    }

    var elevatedSurfaceColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(red: 33/255, green: 31/255, blue: 38/255, alpha: 1.0)
            default:
                return UIColor(red: 255/255, green: 251/255, blue: 254/255, alpha: 1.0)
            }
        }
    }

    var strokeColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(red: 73/255, green: 69/255, blue: 79/255, alpha: 1.0)
            default:
                return UIColor(red: 202/255, green: 196/255, blue: 208/255, alpha: 1.0)
            }
        }
    }

    var primaryColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(red: 208/255, green: 188/255, blue: 255/255, alpha: 1.0)
            default:
                return UIColor(red: 103/255, green: 80/255, blue: 164/255, alpha: 1.0)
            }
        }
    }

    var primaryContainerColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(red: 79/255, green: 55/255, blue: 139/255, alpha: 1.0)
            default:
                return UIColor(red: 234/255, green: 221/255, blue: 255/255, alpha: 1.0)
            }
        }
    }

    var onPrimaryContainerColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(red: 234/255, green: 221/255, blue: 255/255, alpha: 1.0)
            default:
                return UIColor(red: 33/255, green: 0/255, blue: 93/255, alpha: 1.0)
            }
        }
    }

    var secondaryContainerColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(red: 74/255, green: 68/255, blue: 88/255, alpha: 1.0)
            default:
                return UIColor(red: 232/255, green: 222/255, blue: 248/255, alpha: 1.0)
            }
        }
    }

    var primaryTextColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(red: 56/255, green: 30/255, blue: 114/255, alpha: 1.0)
            default:
                return UIColor.white
            }
        }
    }

    var secondaryButtonColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(red: 208/255, green: 188/255, blue: 255/255, alpha: 0.12)
            default:
                return UIColor(red: 103/255, green: 80/255, blue: 164/255, alpha: 0.12)
            }
        }
    }

    var mutedTextColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(red: 202/255, green: 196/255, blue: 208/255, alpha: 1.0)
            default:
                return UIColor(red: 73/255, green: 69/255, blue: 79/255, alpha: 1.0)
            }
        }
    }
        
    var buttonColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return self.secondaryButtonColour.resolvedColor(with: trait)
            default:
                return self.secondaryButtonColour.resolvedColor(with: trait)
            }
        }
    }
    
    var grouppedBackroundColor: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return self.surfaceColour.resolvedColor(with: traitCollection)
            default:
                return self.surfaceColour.resolvedColor(with: traitCollection)
            }
        }
    }
    
    var tabBarTintColor: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return self.primaryColour.resolvedColor(with: traitCollection)
            default:
                return self.primaryColour.resolvedColor(with: traitCollection)
            }
        }
    }
    
    var tabBarUnselectedColor: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor.systemGray2
            default:
                return UIColor(red: 73/255, green: 69/255, blue: 79/255, alpha: 1.0)
            }
        }
    }
    
    var secondHalfProgressBarColor: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 255/255, green: 191/255, blue: 0/255, alpha: 1.0) // Dark mode color
            default:
                return UIColor(red: 103/255, green: 80/255, blue: 164/255, alpha: 1.0)
            }
        }
    }
    
    var firstHalfProgressBarColor: UIColor {
        return UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(red: 117/255, green: 196/255, blue: 139/255, alpha: 1.0)
            default:
                return UIColor(red: 50/255, green: 125/255, blue: 82/255, alpha: 1.0)
            }
        }
    }
}
