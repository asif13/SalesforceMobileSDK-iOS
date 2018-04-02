//
//  ProgressHUD.h
//  SalesApp
//
//  Created by Ravi Kiran on 03/24/16.
//  Copyright (c) 2014 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


/**
 * @class ProgressHUD
 *
 * @author Ravi Kiran Halbawi
 * @date 20/01/16
 *
 * @version 1.0
 *
 * @discussion This class is basically derived from UIView With custom implematation of UIActivityIndicator and label inside it.When intialised adds traparent overlay on self with  animating Activity Indicator and message in it.
 *
 */

@interface ProgressHUD : NSObject

/**
 * show LoadingHUD with message
 * @discussion This methods calls ProgressHud  to display a overlay on self  with a loading message and ActivityIndicator
 *
 * @author Ravi Kiran
 *
 * @param loadingMessage the message to be displayed in HUD
 *
 */
+(void)hudWithMessage:(NSString *)loadingMessage;

/**
 * dismissHud
 * @discussion This methods removes ProgressHud view from superview
 *
 * @author Ravi Kiran
 *
 */
+(void)dismissHud;

@end
