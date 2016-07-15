//
//  ViewController.swift
//  renklistesi
//
//  Created by Erhan BARIŞ on 02/06/15.
//  Copyright (c) 2015 Erhan Baris. All rights reserved.
//

import UIKit

class ConfigViewController: UITableViewController, BaseController{
    
    @IBOutlet weak var colorDetectionMode: UISegmentedControl!
    @IBOutlet weak var languageSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        languageSegment.selectedSegmentIndex = AppConfig.GetColorPalette().rawValue;
        colorDetectionMode.selectedSegmentIndex = AppConfig.GetColorDetectionMode().rawValue;
        
        self.tableView.tableFooterView = UIView();
    }
    
    @IBAction func languageSelection(sender: AnyObject) {
        
        if let segment = sender as? UISegmentedControl{
            AppConfig.SetColorPalette(ColorPalette(rawValue: segment.selectedSegmentIndex)!);
            AppConfig.Save();
            
            if let list = AppConfig.GetListController()
            {
                list.initData();
            }
            if let camera = AppConfig.GetCameraController()
            {
                camera.initData();
            }
        }
    }
    
    @IBAction func colorDetectionModeChanged(sender: AnyObject) {
        if let segment = sender as? UISegmentedControl{
            AppConfig.SetColorDetectionMode(ColorDetectionMode(rawValue: segment.selectedSegmentIndex)!);
            AppConfig.Save();
            
            if let camera = AppConfig.GetCameraController()
            {
                camera.initCamera();
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Active()
    {
        
    }
    
    func Inactive()
    {
        
    }
}