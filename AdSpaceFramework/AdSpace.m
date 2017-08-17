//
//  AdSpace.m
//  AdSpaceFramework
//
//  Created by Bluscheme on 8/17/17.
//  Copyright © 2017 Widespace. All rights reserved.
//

#import "AdSpace.h"

@implementation AdSpace {
    UIWebView *webView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        webView = [[UIWebView alloc] init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        webView = [[UIWebView alloc] init];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        webView = [[UIWebView alloc] init];
    }
    return self;
}

// public methods
- (void)runAd {
    if(![webView isDescendantOfView:self]) {
        [delegate willPresentAd];
        [self fetchJsonData];
    }
    
}

- (void)closeAd {
    if ([webView isDescendantOfView:self]) {
        [delegate willDismissAd];
        [webView removeFromSuperview];
        [delegate didDismissAd];
    }
}

- (void)setDelegate:(id<AdSpaceDelegate>)newDelegate {
    delegate = newDelegate;
}

// private methods
- (void)fetchJsonData {
    NSString *urlAsString = [NSString stringWithFormat:@"http://test72.widespace.com/sdk_masum/ad.json"];
    
    NSCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodedUrlAsString = [urlAsString stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithURL:[NSURL URLWithString:encodedUrlAsString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Response: %@", response);
        NSLog(@"Data: %@", data);
        
        if (!error) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSError *jsonError;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                if (jsonError) {
                    NSLog(@"Error Parsing JSON: %@", jsonError);
                } else {
                    NSLog(@"JSON Response: %@", jsonResponse);
                    [self parseJsonData:jsonResponse];
                }
            } else {
                NSLog(@"Server Error");
            }
        } else {
            NSLog(@"error : %@", error.description);
        }
    }] resume];
}

- (void)parseJsonData:(NSDictionary *)jsonResponse {
    NSString *status = [jsonResponse objectForKey:@"status"];
    
    NSLog(@"Status: %@", status);
    if ([status isEqualToString:@"ok"]) {
        NSDictionary *sizeObj = [jsonResponse objectForKey:@"size"];
        
        CGFloat width = [self getFloatValueFromString:[sizeObj objectForKey:@"width"]];
        CGFloat height = [self getFloatValueFromString:[sizeObj objectForKey:@"height"]];
        
        NSString *code = [jsonResponse objectForKey:@"code"];
        [self showHTML:code withWidth:width andHeight:height];
    }
}

- (CGFloat)getFloatValueFromString:(NSString *)string {
    float floatVal;
    NSScanner *scanner = [[NSScanner alloc] initWithString:string];
    [scanner scanFloat:&floatVal];
    
    NSLog(@"float val: %f", floatVal);
    
    return floatVal;
}

- (void)showHTML:(NSString *)code withWidth:(CGFloat)width andHeight:(CGFloat)height {
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        webView.frame = CGRectMake(self.bounds.size.width/2 - width/2, self.bounds.size.height/2 - height/2, width, height);
        
        [self addSubview:webView];
    });
    
    [webView loadHTMLString:code baseURL:nil];
    [delegate didPresentAd];
}

@end
