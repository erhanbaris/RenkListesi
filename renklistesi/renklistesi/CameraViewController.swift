//
//  CameraViewController.swift
//  renklistesi
//
//  Created by Erhan BARIŞ on 04/06/15.
//  Copyright (c) 2015 Erhan Baris. All rights reserved.
//

import Foundation
import GPUImage

public class CameraViewController : UIViewController, BaseController
{
    @IBOutlet weak var cameraView: GPUImageView!
    @IBOutlet weak var tmpView: GPUImageView!
    @IBOutlet weak var engineView: GPUImageView!
    
    var colors = [UIColor]();
    var cameraCaptureStatus : Bool = true;
    
    var videoCamera : GPUImageVideoCamera! = nil;
    var filter : GPUImageOutput! = nil;
    var blurFilter1 : GPUImageOutput! = nil;
    var blurFilter2 : GPUImageOutput! = nil;
    var blendImage: GPUImagePicture?
    var colorFilter : GPUImageAverageColor?;
    let colorGenerator = GPUImageSolidColorGenerator()
    var pixellateFilter = GPUImagePixellateFilter();
    var brightnesFilter = GPUImageBrightnessFilter();
    
    var cropFilter = GPUImageCropFilter();
    //var imageView : GPUImageView?
    
    
    @IBOutlet weak var bridSlider: ASValueTrackingSlider!
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var flashImage: UIImageView!
    @IBOutlet weak var cameraInverseImage: UIImageView!
    @IBOutlet weak var colorPanel: UIView!
    @IBOutlet weak var label: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad();
        
        
        let  formatter = NSNumberFormatter();
        formatter.numberStyle = NSNumberFormatterStyle.PercentStyle;
        bridSlider.numberFormatter = formatter;
        bridSlider.popUpViewCornerRadius = 12.0;
        bridSlider.popUpViewAnimatedColors = [UIColor.purpleColor(), UIColor.redColor(), UIColor.orangeColor()];
        bridSlider.popUpViewArrowLength = 20.0;
        
        initCamera();
        initData();
    }
    
    public func initCamera()
    {
        
        //imageView = GPUImageView(frame: CGRectMake(0, 61, self.view.frame.width - 12, 350));
        
        if (cameraView != nil)
        {
            cameraView.backgroundColor = UIColor.whiteColor();
            cameraView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill
        }
        self.view.backgroundColor = UIColor.blackColor();
        //self.view.addSubview(imageView!);
        
        
        
        // (self.view as! GPUImageView).setBackgroundColorRed(1, green: 1, blue: 1, alpha: 1.0);
        
        
        if (TARGET_IPHONE_SIMULATOR != 0)
        {
            return;
        }
        
        videoCamera = GPUImageVideoCamera(sessionPreset: AVCaptureSessionPresetiFrame960x540, cameraPosition: .Back)
        videoCamera.outputImageOrientation = .Portrait;
        
        if (videoCamera.inputCamera.isFocusModeSupported(AVCaptureFocusMode.AutoFocus) && videoCamera.inputCamera.lockForConfiguration())
        {
            if (videoCamera.inputCamera.isWhiteBalanceModeSupported(AVCaptureWhiteBalanceMode.AutoWhiteBalance))
            {
                videoCamera.inputCamera.whiteBalanceMode = AVCaptureWhiteBalanceMode.AutoWhiteBalance;
            }
            
            /*
            
            videoCamera.inputCamera.flashMode = AVCaptureFlashMode.On
            videoCamera.inputCamera.torchMode = AVCaptureTorchMode.On;
            */
            videoCamera.inputCamera.focusPointOfInterest = CGPointMake(0.5, 0.5);
            videoCamera.inputCamera.unlockForConfiguration();
        }
        
        filter = GPUImageMultiplyBlendFilter();
        brightnesFilter = GPUImageBrightnessFilter()
        videoCamera.addTarget(brightnesFilter);
        
        if (UIDevice.currentDevice().isIPhone)
        {
            //Büyük blur daire
            blurFilter1 = GPUImageGaussianSelectiveBlurFilter();
            (self.blurFilter1 as! GPUImageGaussianSelectiveBlurFilter).blurRadiusInPixels = 10;
            (self.blurFilter1 as! GPUImageGaussianSelectiveBlurFilter).excludeCircleRadius = 0.17;
            (self.blurFilter1 as! GPUImageGaussianSelectiveBlurFilter).excludeCirclePoint = CGPointMake(0.5,0.5);
            (self.blurFilter1 as! GPUImageGaussianSelectiveBlurFilter).excludeBlurSize = 0;
            (self.blurFilter1 as! GPUImageGaussianSelectiveBlurFilter).aspectRatio = 960 / 540;
            
            
            //Küçük blur daire
            blurFilter2 = GPUImageGaussianSelectiveBlurFilter();
            (self.blurFilter2 as! GPUImageGaussianSelectiveBlurFilter).blurRadiusInPixels = 60;
            (self.blurFilter2 as! GPUImageGaussianSelectiveBlurFilter).excludeCircleRadius = 0.3;
            (self.blurFilter2 as! GPUImageGaussianSelectiveBlurFilter).excludeCirclePoint = CGPointMake(0.5,0.5);
            (self.blurFilter2 as! GPUImageGaussianSelectiveBlurFilter).excludeBlurSize = 0;
            (self.blurFilter2 as! GPUImageGaussianSelectiveBlurFilter).aspectRatio = 960 / 540;
            
            brightnesFilter.addTarget((blurFilter1 as! GPUImageInput))
            blurFilter1.addTarget((blurFilter2 as! GPUImageInput)) // Zincir yapısına uygun filtreler arası veri gönderimi
            
            blurFilter2.addTarget(filter as! GPUImageInput);
        }
        else {
            
            //Büyük blur daire
            blurFilter1 = GPUImageGaussianSelectiveBlurFilter();
            (self.blurFilter1 as! GPUImageGaussianSelectiveBlurFilter).blurRadiusInPixels = 10;
            (self.blurFilter1 as! GPUImageGaussianSelectiveBlurFilter).excludeCircleRadius = 0.17;
            (self.blurFilter1 as! GPUImageGaussianSelectiveBlurFilter).excludeCirclePoint = CGPointMake(0.5,0.5);
            (self.blurFilter1 as! GPUImageGaussianSelectiveBlurFilter).excludeBlurSize = 0;
            (self.blurFilter1 as! GPUImageGaussianSelectiveBlurFilter).aspectRatio = 960 / 540;
            
            
            brightnesFilter.addTarget((blurFilter1 as! GPUImageInput))
            
            blurFilter1.addTarget(filter as! GPUImageInput);
        }
        
        
        // ##################
        
        let inputImage = UIImage(named:"cameraLayer.png");
        var bigCircle = self.drawEclipse(inputImage!, x: 0.5, y: 0.5, size: 0.3, color: UIColor.lightGrayColor());
        var middleCircle = self.drawEclipse(bigCircle, x: 0.5, y: 0.5, size: 0.17, color: UIColor.lightGrayColor());
        var smallCircle = self.drawEclipse(middleCircle, x: 0.5, y: 0.5, size: 0.075, dashActive: true);
        
        // ##################
        
        
        self.blendImage = GPUImagePicture(image: smallCircle)
        self.blendImage?.addTarget((filter as! GPUImageInput))
        self.blendImage?.processImage()
        
        var circleRoundSize : CGFloat = 0.075;
        var rect = CGRectMake(0.5 - (circleRoundSize / 2), 0.5 -  (circleRoundSize / 2), circleRoundSize, circleRoundSize);
        cropFilter = GPUImageCropFilter(cropRegion: CGRectMake(0.5 - (circleRoundSize / 2), 0.5 -  (circleRoundSize / 2), circleRoundSize, circleRoundSize))
        brightnesFilter.addTarget((cropFilter as GPUImageInput))
        
        if (AppConfig.GetColorDetectionMode() == ColorDetectionMode.Avg)
        {
            // Renk ortalamasına göre arama filtresi
            colorFilter = GPUImageAverageColor();
            
            
            var sizeInPixels = CGSizeMake(50, 50);
            //var sizeInPixels = CGSizeMake(self.imageView?.frame.width * circleRoundSize, self.imageView?.frame.height * circleRoundSize);
            colorGenerator.forceProcessingAtSize(sizeInPixels)
            NSLog(sizeInPixels.width.description + " " + sizeInPixels.height.description)
            cropFilter.addTarget((colorFilter as! GPUImageInput))
            
            
            colorFilter?.colorAverageProcessingFinishedBlock = {(redComponent, greenComponent, blueComponent, alphaComponent, frameTime) in
                var color : UIColor = UIColor(red: (redComponent ), green: (greenComponent ), blue: (blueComponent ), alpha: 1);
                self.changeColorInfo(color);
            }
            
            self.colorFilter!.addTarget(engineView)
            
        }
        else
        {
            
            // En yoğun renge göre arama filtresi
            pixellateFilter = GPUImagePixellateFilter()
            pixellateFilter.fractionalWidthOfAPixel = 2;
            cropFilter.addTarget((pixellateFilter as GPUImageInput))
            
            pixellateFilter.colorAverageProcessingFinishedBlock = {(redComponent, greenComponent, blueComponent, alphaComponent, frameTime) in
                var color : UIColor = UIColor(red: (redComponent ), green: (greenComponent ), blue: (blueComponent ), alpha: 1);
                self.changeColorInfo(color);
            }
            
            self.pixellateFilter.addTarget(engineView)
        }
        
        
        cropFilter.addTarget(tmpView);
        
        filter.addTarget(cameraView)
        videoCamera.startCameraCapture()
        
        var gesture = UITapGestureRecognizer(target: self, action: Selector("changeCamera"))
        self.cameraInverseImage.addGestureRecognizer(gesture);
        
        var gesture2 = UITapGestureRecognizer(target: self, action: Selector("changeFlashStatus"))
        self.flashImage.addGestureRecognizer(gesture2);
        
        var gesture3 = UITapGestureRecognizer(target: self, action: Selector("changePlayStatus"))
        self.playImage.addGestureRecognizer(gesture3);
        
        cameraCaptureStatus = true;
        self.playImage.image = UIImage(named: "Circular_Play_Button_128.png");
        
        AppConfig.SetCameraController(self);
    }
    
    func drawEclipse(image : UIImage, x : CGFloat, y : CGFloat, var size : CGFloat, color : UIColor = UIColor.blackColor(), dashActive : Bool = false) -> UIImage
    {
        size = size * 2.0;
        UIGraphicsBeginImageContext(image.size);
        
        // draw original image into the context
        image.drawAtPoint(CGPointZero);
        
        // get the context for CoreGraphics
        let ctx = UIGraphicsGetCurrentContext();
        
        // set stroking color and draw circle
        color.setStroke();
        
        // make circle rect 5 px from border
        
        var imageYCordinate = (image.size.height - image.size.width) / 2;
        
        let realX = image.size.width * (x - (size / 2));
        let realY = image.size.width * (y - (size / 2)) + ((image.size.height - image.size.width) / 2);
        let realSize = image.size.width * size;
        
        
        
        NSLog("Height : " + image.size.height.description + " Width : " + image.size.width.description);
        NSLog("realX \(realX) realY \(realY) realSize \(realSize)");
        
        var circleRect = CGRectMake(realX, realY,
            realSize,
            realSize);
        
        circleRect = CGRectInset(circleRect, 5, 5);
        
        
        if (dashActive)
        {
            CGContextSetLineDash(ctx, 0, [6, 5], 2);
        }
        
        // draw circle
        CGContextStrokeEllipseInRect(ctx, circleRect);
        
        // make image out of bitmap context
        let retImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // free the context
        UIGraphicsEndImageContext();
        
        return retImage;
    }
    
    internal func initData()
    {
        colors = ColorContainer.getCurrentColors().map{$0.1};
    }
    
    @IBAction func brigChanged(sender: AnyObject) {
        let value : CGFloat = CGFloat((sender as! UISlider).value);
        self.brightnesFilter.brightness = value;
    }
    
    func changePlayStatus()
    {
        if (cameraCaptureStatus)
        {
            videoCamera.stopCameraCapture();
            cameraCaptureStatus = false;
            self.playImage.image = UIImage(named: "Circular_Stop_Button_128.png");
        }
        else
        {
            videoCamera.startCameraCapture();
            cameraCaptureStatus = true;
            self.playImage.image = UIImage(named: "Circular_Play_Button_128.png");
        }
        
    }
    
    func changeCamera()
    {
        videoCamera.rotateCamera();
    }
    
    func changeFlashStatus()
    {
        if (videoCamera.inputCamera.isFlashModeSupported(AVCaptureFlashMode.On) &&
            videoCamera.inputCamera.lockForConfiguration() &&
            videoCamera.inputCamera.isTorchModeSupported(AVCaptureTorchMode.On))
        {
            
            if (videoCamera.inputCamera.flashMode == AVCaptureFlashMode.Off)
            {
                videoCamera.inputCamera.flashMode = AVCaptureFlashMode.On;
                videoCamera.inputCamera.torchMode = AVCaptureTorchMode.On;
                self.flashImage.image = UIImage(named: "Lightning_in_a_circle_64.png");
            }
            else {
                videoCamera.inputCamera.flashMode = AVCaptureFlashMode.Off;
                videoCamera.inputCamera.torchMode = AVCaptureTorchMode.Off;
                self.flashImage.image = UIImage(named: "Not_flash_allowed_64.png");
            }
            
            videoCamera.inputCamera.unlockForConfiguration();
        }
        
    }
    
    func changeColorInfo(var color : UIColor)
    {   var tmpContainer = [String, UIColor]();
        var maxDifference : CGFloat = 6.0;
        
        var closestColor : UIColor! = color.closestColorInPalette(self.colors, maxDifference: maxDifference);
        tmpContainer = ColorContainer.getCurrentColors();
        
        
        if (closestColor != nil)
        {
            var (colorName,_) = tmpContainer.filter{$0.1 == closestColor}.first!;
            
            dispatch_async(dispatch_get_main_queue(), {
                self.label.text = colorName;
                self.colorPanel.backgroundColor = color;
                self.label.textColor = color.blackOrWhiteContrastingColor();
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), {
                self.label.text = "-";
                self.colorPanel.backgroundColor = color;
                self.label.textColor = color.blackOrWhiteContrastingColor();
            });
        }
        //NSLog(closestColor.hexString() + " " + colorName);
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Active()
    {
        if let camera = videoCamera{
            camera.stopCameraCapture();
        }
    }
    
    func Inactive()
    {
        if let camera = videoCamera{
            if (self.cameraCaptureStatus)
            {
                camera.startCameraCapture();
            }
        }
    }
}