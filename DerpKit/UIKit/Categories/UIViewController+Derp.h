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

/**
 For Auto Layout, use `-derp_addKeyboardViewHandlersWithConstraint:options:` instead.
 */
-(void)derp_addKeyboardViewHandlers;

/**
 For Auto Layout, use `-derp_addKeyboardViewHandlersWithConstraint:options:` instead.
 @param options	see options keys above
 */
-(void)derp_addKeyboardViewHandlersWithOptions:(NSDictionary*)options;

/**
 Supports Auto Layout.
 @param options	see options keys above
 @param constraints	pass flush-bottom constraint (bottom space to superview is 0) - its constant will be increased to make space for the keyboard, and reset to 0 when the keyboard is dismissed
 */
-(void)derp_addKeyboardViewHandlersWithConstraint:(NSLayoutConstraint *)constraint options:(NSDictionary*)options;

-(void)derp_removeKeyboardViewHandlers;

@end
