//
//  UIViewController+Derp.h
//  DerpKit
//
//  Created by Steve Streza on 7/15/12.
//  Copyright (c) 2012 Mustacheware. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const struct DerpKeyboardViewHandlerOptions {
	__unsafe_unretained NSString *minHeight; // boxed CGFloat. default is 0.0.
	
} DerpKeyboardViewHandlerOptions;

@interface UIViewController (Derp)

-(BOOL)derp_isViewVisible;
-(void)derp_performIfVisible:(dispatch_block_t)handler;

-(void)derp_addKeyboardViewHandlers;
-(void)derp_addKeyboardViewHandlersWithOptions:(NSDictionary*)options; // see options keys above
-(void)derp_removeKeyboardViewHandlers;

@end
