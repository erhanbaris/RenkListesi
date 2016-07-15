//
//  UIColor+Utilities.h
//  ColorAlgorithm
//
//  Created by Quenton Jones on 6/11/11.
//  Copyright 2011 Mysterious Trousers. All rights reserved.
//

#include <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (Distance)

// Determines which color in the array of colors most closely matches receiving color.
- (UIColor *)closestColorInPalette:(NSArray *)palette maxDifference:(CGFloat)max;

@end
