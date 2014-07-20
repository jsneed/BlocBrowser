//
//  BLCWebBrowserViewController.h
//  BlocBrowser
//
//  Created by Jeanne on 7/19/14.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLCWebBrowserViewController : UIViewController

/**
 Replaces the web view with a fresh one, erasing all history. Also updates the URL field and toolbar buttons appropriately.
 */
- (void) resetWebView;

@end
