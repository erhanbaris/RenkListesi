//
//  AppConfig.swift
//  renklistesi
//
//  Created by Erhan BARIŞ on 07/06/15.
//  Copyright (c) 2015 Erhan Baris. All rights reserved.
//

import Foundation

public enum ColorPalette : Int
{
    case Turkish = 0
    case English = 1
    case Combine = 2
}

public enum ColorDetectionMode : Int
{
    case Avg = 0
    case Max = 1
}

public class AppConfig
{
    private static var colorPalette : ColorPalette = .Turkish
    private static var colorDetectionMode : ColorDetectionMode = .Avg
    private static var listController : ViewController?
    private static var cameraController : CameraViewController?
    
    class func SetCameraController(controller : CameraViewController)
    {
        AppConfig.cameraController = controller
    }
    
    class func SetListController(controller : ViewController)
    {
        AppConfig.listController = controller
    }
    
    class func SetColorDetectionMode(mode : ColorDetectionMode)
    {
        AppConfig.colorDetectionMode = mode
    }
    
    class func SetColorPalette(color : ColorPalette)
    {
        AppConfig.colorPalette = color
    }
    
    class func GetListController() -> ViewController?
    {
        return  AppConfig.listController
    }
    
    class func GetCameraController() -> CameraViewController?
    {
        return  AppConfig.cameraController
    }
    
    class func GetColorPalette() -> ColorPalette
    {
        return  AppConfig.colorPalette
    }
    
    class func GetColorDetectionMode() -> ColorDetectionMode
    {
        return  AppConfig.colorDetectionMode
    }
    
    class func Save()
    {
        NSUserDefaults.standardUserDefaults().setObject(colorPalette.rawValue, forKey: "colorPalette")
        NSUserDefaults.standardUserDefaults().setObject(colorDetectionMode.rawValue, forKey: "colorDetectionMode")
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "kayit");
        
    }
    
    class func Load()
    {
        if (NSUserDefaults.standardUserDefaults().boolForKey("kayit"))
        {
            colorPalette = ColorPalette(rawValue: NSUserDefaults.standardUserDefaults().objectForKey("colorPalette") as! Int)!;
            
            if let item = NSUserDefaults.standardUserDefaults().objectForKey("colorDetectionMode"){
                colorDetectionMode = ColorDetectionMode(rawValue: item as! Int)!;
            }
        }
    }
}