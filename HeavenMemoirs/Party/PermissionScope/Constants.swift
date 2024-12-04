//
//  Constants.swift
//  PermissionScope
//
//  Created by Nick O'Neill on 8/21/15.
//  Copyright © 2015 That Thing in Swift. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
    static var supportFilters:[FilterModel] = [
        FilterModel("Brightness", edit: EditMenu.exposure),
        FilterModel("Contrast", edit: EditMenu.contrast),
        FilterModel("Saturation", edit: EditMenu.saturation),
        FilterModel("White Blance",image:"temperature", edit: EditMenu.white_balance),
        FilterModel("Tone",image: "tone", edit: EditMenu.tone),
        FilterModel("HSL",image: "hls", edit: EditMenu.hls),
        FilterModel("Fade", edit: EditMenu.fade),
    ]
    
    struct UI {
        static let contentWidth: CGFloat                 = 280.0
        static let dialogHeightSinglePermission: CGFloat = 260.0
        static let dialogHeightTwoPermissions: CGFloat   = 360.0
        static let dialogHeightThreePermissions: CGFloat = 460.0
    }
    
//    struct NSUserDefaultsKeys {
//        static let requestedInUseToAlwaysUpgrade = "PS_requestedInUseToAlwaysUpgrade"
//        static let requestedBluetooth            = "PS_requestedBluetooth"
//        static let requestedMotion               = "PS_requestedMotion"
//        static let requestedNotifications        = "PS_requestedNotifications"
//    }
//    
//    struct InfoPlistKeys {
//        static let locationWhenInUse             = "NSLocationWhenInUseUsageDescription"
//        static let locationAlways                = "NSLocationAlwaysUsageDescription"
//    } 
}
