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
                return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
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
                return UIColor(red: 47/255, green: 69/255, blue: 120/255, alpha: 1.0)
            default:
                return UIColor(red: 47/255, green: 69/255, blue: 120/255, alpha: 1.0)
            }
        }
    }

    var onPrimaryContainerColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor.white
            default:
                return UIColor.white
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

    var errorColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(red: 242/255, green: 184/255, blue: 181/255, alpha: 1.0)
            default:
                return UIColor(red: 179/255, green: 38/255, blue: 30/255, alpha: 1.0)
            }
        }
    }

    var onErrorColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(red: 96/255, green: 20/255, blue: 16/255, alpha: 1.0)
            default:
                return UIColor.white
            }
        }
    }

    var errorContainerColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(red: 140/255, green: 29/255, blue: 24/255, alpha: 1.0)
            default:
                return UIColor(red: 249/255, green: 222/255, blue: 220/255, alpha: 1.0)
            }
        }
    }

    var onErrorContainerColour: UIColor {
        return UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return UIColor(red: 249/255, green: 222/255, blue: 220/255, alpha: 1.0)
            default:
                return UIColor(red: 65/255, green: 14/255, blue: 11/255, alpha: 1.0)
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
