//
//  AdSpace.h
//  AdSpaceFramework
//
//  Created by Bluscheme on 8/17/17.
//  Copyright © 2017 Widespace. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdSpaceDelegate

@required
- (void)willPresentAd;
- (void)didPresentAd;
- (void)willDismissAd;
- (void)didDismissAd;

@end

@interface AdSpace : UIView {
    id<AdSpaceDelegate> delegate;
}

- (void)setDelegate:(id<AdSpaceDelegate>)newDelegate;
- (void)runAd;
- (void)closeAd;

@end
