//
//  ViewController.swift
//  renklistesi
//
//  Created by Erhan BARIŞ on 02/06/15.
//  Copyright (c) 2015 Erhan Baris. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , UIGestureRecognizerDelegate, BaseController, UITextFieldDelegate{
    
    var displayCell : ColorDetail!;
    var realCell : ColorCell!;
    static var dataSource = [(String, UIColor)]();
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.dataSource = self;
        self.table.delegate = self;
        //self.table.registerClass(ColorCell.self, forCellReuseIdentifier: "ColorCell")
        table.registerNib(UINib(nibName: "ColorCell", bundle: nil), forCellReuseIdentifier: "ColorCell")
        self.searchTextField.delegate = self;
        
        ColorContainer.initColors();
        initData();
        
        var result : NSComparisonResult = UIColor.blueColor().compareHue(UIColor.redColor());
        
        let colorView = UIView()
        colorView.backgroundColor = UIColor.clearColor()
        self.table.tableFooterView = UIView();
        
        AppConfig.SetListController(self);
        
        
        // use UITableViewCell.appearance() to configure
        // the default appearance of all UITableViewCells in your app
        //UITableViewCell.appearance().selectedBackgroundView = colorView
        
    }
    
    func getDataSource() -> [(String, UIColor)]
    {
        return ViewController.dataSource;
    }
    
    internal func initData()
    {
        ViewController.dataSource = ColorContainer.getCurrentColors();
        self.table.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getDataSource().count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ColorCell! = tableView.dequeueReusableCellWithIdentifier("ColorCell") as? ColorCell
        
        
        cell.title.text = getDataSource()[indexPath.row].0;
        cell.panel.backgroundColor = getDataSource()[indexPath.row].1;
        cell.color.text = "#" + ColorContainer.hexFromUIColor(getDataSource()[indexPath.row].1);
        
        cell.title.textColor = cell.panel.backgroundColor?.blackOrWhiteContrastingColor();
        cell.color.textColor = cell.panel.backgroundColor?.blackOrWhiteContrastingColor();
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None;
        
        return cell;
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        let animationFrame = POPSpringAnimation(propertyNamed: kPOPViewFrame);
        animationFrame.springBounciness = 20;
        animationFrame.springSpeed = 2;
        animationFrame.fromValue = NSValue(CGRect: CGRectMake(cell.frame.origin.x - 100, cell.frame.origin.y, cell.frame.size.width - 100, cell.frame.size.height));
        animationFrame.toValue = NSValue(CGRect: CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height));
        
        
        let animationAlpha = POPBasicAnimation(propertyNamed: kPOPViewAlpha);
        animationAlpha.fromValue =  0.0;
        animationAlpha.toValue = 1.0;
        
        
        if(indexPath.row != tableView.indexPathsForVisibleRows?.last?.row){
            animationFrame.beginTime = CACurrentMediaTime() + (0.1 * Double(indexPath.row));
        }
        else {
            animationFrame.beginTime = CACurrentMediaTime() + (0.1 * Double(indexPath.row));
        }
        
        //cell.pop_addAnimation(animationFrame, forKey: "animationFrame");
        cell.pop_addAnimation(animationAlpha, forKey: "animationAlpha");
        
        
        // cell.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        /*
        cell.alpha = 0;
        
        var startFrame = CGRectMake(cell.frame.origin.x - 100, cell.frame.origin.y, cell.frame.size.width - 100, cell.frame.size.height);
        var endFrame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
        
        cell.frame = startFrame;
        
        UIView.animateWithDuration(0.5, animations: {
        //cell.transform = CGAffineTransformIdentity;
        cell.alpha = 1;
        cell.frame = endFrame;
        });
        */
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 80;
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        let animationFrame = POPBasicAnimation(propertyNamed: kPOPViewAlpha);
        animationFrame.toValue =  0
        animationFrame.fromValue = 1;
        animationFrame.completionBlock = {(animation, finished) in
            self.displayCell.removeFromSuperview()
        };
        
        displayCell.pop_addAnimation(animationFrame, forKey: "animationFrame");
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath?{
        
        self.view.endEditing(true); //Hide keyboard

        displayCell = NSBundle.mainBundle().loadNibNamed("ColorDetail", owner: self, options: nil)[0] as! ColorDetail;
        realCell = tableView.cellForRowAtIndexPath(indexPath) as! ColorCell;
        
        
        let color = UIColor(fromHexString: realCell.color.text!);

        displayCell.rgb.text = "RGB : " + realCell.color.text!;
        displayCell.colorName.text = realCell.title.text;
        
        displayCell.rgb.textColor = realCell.title.textColor;
        displayCell.colorName.textColor = realCell.title.textColor;
        displayCell.red.textColor = realCell.title.textColor;
        displayCell.green.textColor = realCell.title.textColor;
        displayCell.blue.textColor = realCell.title.textColor;

        displayCell.red.text = "RED : \(color.redByte)";
        displayCell.green.text = "GREEN : \(color.greenByte)";
        displayCell.blue.text = "BLUE : \(color.blueByte)";
        
        displayCell.detailView.alpha = 0;

        displayCell.detailView.backgroundColor = realCell.panel.backgroundColor;
        displayCell.backgroundColor = realCell.panel.backgroundColor;
        
        let tap = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        tap.delegate = self;
        displayCell.addGestureRecognizer(tap);
        
        
        self.view.addSubview(displayCell);
        
        let animationFrame = POPBasicAnimation(propertyNamed: kPOPViewFrame);
        animationFrame.toValue =  NSValue(CGRect: CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, realCell.frame.width, tableView.frame.height));
        animationFrame.fromValue = NSValue(CGRect: CGRectMake(tableView.frame.origin.x, realCell.frame.origin.y - tableView.contentOffset.y, realCell.frame.width, realCell.frame.height));
        
        animationFrame.completionBlock = {(animation, finished) in
            
            let animationAlpha = POPBasicAnimation(propertyNamed: kPOPViewAlpha);
            animationAlpha.toValue =  1.0
            animationAlpha.fromValue = 0.0
            self.displayCell.detailView.pop_addAnimation(animationAlpha, forKey: "animationAlpha");
        };
        
        displayCell.pop_addAnimation(animationFrame, forKey: "animationFrame");
        
        return indexPath;
    }
    
    @IBAction func searchTextChanged(sender: AnyObject) {
        if var textView = sender as? UITextField
        {
            
            if (textView.text.characters.count > 0)
            {
                ViewController.dataSource =  getDataSource().filter{ (item: (String, UIColor)) -> Bool in
                    return (item.0.lowercaseString as NSString).containsString(textView.text.lowercaseString)
                }
                
                self.table.reloadData()

            }
            else
            {
                initData();
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true); //Hide keyboard

    }
    
    func Active()
    {
        
    }
    
    func Inactive()
    {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
    }
}