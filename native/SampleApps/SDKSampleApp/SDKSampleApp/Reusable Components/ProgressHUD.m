//
//  ProgressHUD.m
//  SalesApp
//
//  Created by Ravi Kiran on 9/11/14.
//  Copyright (c) 2014 Apple Inc. All rights reserved.
//


#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#define Hud_Width 150.0f
#define Hud_Height 130.0f

#define kActivityIndicatorHeight 40.0f

@class ProgressHUDView;

static ProgressHUDView *progressView;

#import "ProgressHUD.h"

@interface ProgressHUDView : UIView

@property (nonatomic,strong)NSString * message;

@property (nonatomic,strong)UILabel * messageLabel;

@end
@implementation ProgressHUDView


- (void)layoutHud
{

    [self clearSubviews];
        
    //self.frame = [[UIApplication sharedApplication] keyWindow].frame;

    // set transparent background
    self.backgroundColor =[UIColor colorWithRed:196/224.0f green:196/224.0f blue:(196/224.0f) alpha:.4f];
    ///---------------------
    /// @HUD Initialization
    ///---------------------
    
         UIView *_hudview = [UIView new];
        _hudview.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    
        _hudview.layer.cornerRadius = 10.0f;
        _hudview.layer.borderColor = [UIColor clearColor].CGColor;
        _hudview.layer.borderWidth = 3.0f;
        [self addSubview:_hudview];
    
    
    // say NO ro autoresizingConstraints
    _hudview.translatesAutoresizingMaskIntoConstraints = NO;
    
    // add constaraints
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_hudview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_hudview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:_hudview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:Hud_Height]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:_hudview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:Hud_Width]];

    ///---------------------
    /// @Activity Indicator Initialization
    ///---------------------
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator startAnimating];
    [_hudview addSubview:activityIndicator];
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *activityIndicatorViews = @{@"activityIndicator":activityIndicator};
    
    NSNumber *padding = [NSNumber numberWithFloat:(((Hud_Height - kActivityIndicatorHeight))/2 + 10)] ;
    
    NSDictionary *indicatorMetrics = @{@"padding":padding,@"indicatorHeight":@kActivityIndicatorHeight,@"vPadding":[NSNumber numberWithFloat:([padding floatValue] - 25)]};
    
    [_hudview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[activityIndicator(indicatorHeight)]" options:0 metrics:indicatorMetrics views:activityIndicatorViews]];
    [_hudview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-vPadding-[activityIndicator(indicatorHeight)]" options:0 metrics:indicatorMetrics views:activityIndicatorViews]];
    


    ///---------------------
    /// @_messageLabel Initialization
    ///---------------------
    
    if ( nil != self.message && self.message.length > 0) {
            
            
            _messageLabel = [UILabel new];
            
            _messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
            _messageLabel.textColor =  [UIColor whiteColor];
            _messageLabel.text = self.message;
            _messageLabel.backgroundColor = [UIColor clearColor];
            _messageLabel.textAlignment = NSTextAlignmentCenter;
            _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _messageLabel.numberOfLines = 0;
            [_hudview addSubview:_messageLabel];
            
            
            _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSDictionary *messageLBLViews = @{@"_messageLabel":_messageLabel,@"activityindicator":activityIndicator};
        
            [_hudview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_messageLabel]-10-|" options:0 metrics:nil views:messageLBLViews]];
            [_hudview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[activityindicator]-10-[_messageLabel]-5-|" options:0 metrics:nil views:messageLBLViews]];

            
        }
        
    
    
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    
  
}


- (void)setMessage:(NSString *)message
{

    _message = message;
    
    _messageLabel.text = message;
    
}
/*
 * Clear all subviews ex:ActivityIndicator , _messageLabel , Hud
 */
- (void)clearSubviews
{
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
}

@end


////////++++++++++///////////////////////////////////

@implementation ProgressHUD

/*
 * Create Hud with the Custom Message
 */

+(void)hudWithMessage:(NSString *)message
{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!progressView) {
 
            progressView = [[ProgressHUDView alloc] init];
            progressView.message = message;

            [progressView layoutHud];
            
            [[[UIApplication sharedApplication] keyWindow] addSubview:progressView];
            
            //add constaraints for ProgressHud View
            progressView.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSDictionary *views = @{@"progressView": progressView};
            
            UIView * superView = [[UIApplication sharedApplication] keyWindow];
            
            [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[progressView]-0-|" options:0 metrics:nil views:views]];
            
            [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[progressView]-0-|" options:0 metrics:nil views:views]];


        }
        
        progressView.message = message;
        
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:progressView];

        

    });
}

/*
 * Dismiss the Hud
 */
+(void)dismissHud

{

    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            if (progressView) {
                [progressView clearSubviews];
                [progressView removeFromSuperview];
                progressView = nil;
            }
        
        
    });

}
@end

