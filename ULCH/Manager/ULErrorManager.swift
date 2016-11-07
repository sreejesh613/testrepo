//
//  ULErrorManager.swift
//  ULCH
//
//  Created by Smitha on 06/10/16.
//  Copyright © 2016 Smitha. All rights reserved.
//


import Foundation
import UIKit

class ULErrorManager: NSObject
{
    class var sharedInstance: ULErrorManager {
        struct Singleton {
            static let instance = ULErrorManager()
        }
        return Singleton.instance
    }
    
    func noNetworkConnection(_ parentView: UIViewController)
    {
        alert("Network Error", message: "Oops, it looks like you don't have a working internet connection. Please connect and try again.", parentView: parentView)
    }

}
