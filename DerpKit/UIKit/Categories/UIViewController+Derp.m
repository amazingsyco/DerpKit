//
//  UIViewController+Derp.m
//  DerpKit
//
//  Created by Steve Streza on 7/15/12.
//  Copyright (c) 2012 Steve Streza
//  
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

#import "UIViewController+Derp.h"
#import <objc/runtime.h>
#import "NSObject+YMOptionsAndDefaults.h"

const struct DerpKeyboardViewHandlerOptions DerpKeyboardViewHandlerOptions = {
	.minHeight = @"DerpKeyboardViewHandlerOptionMinimumHeight",
};

@implementation UIViewController (Derp)

-(BOOL)derp_isViewVisible{
	return self.isViewLoaded && self.view.window;
}

-(void)derp_performIfVisible:(dispatch_block_t)handler{
	if([self derp_isViewVisible] && handler){
		handler();
	}
}

-(void)derp_addKeyboardViewHandlers{
	[self derp_addKeyboardViewHandlersWithOptions:nil];
}

-(void)derp_addKeyboardViewHandlersWithOptions:(NSDictionary*)options{
	[self ym_registerOptions:options defaults:@{
		 DerpKeyboardViewHandlerOptions.minHeight : @(0.0),
	 }];
	NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
	id willShow = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:mainQueue usingBlock:^(NSNotification *note) {
		[self derp_performIfVisible:^{
			CGRect keyboardFrame = [self.view convertRect:[(NSValue *)note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]
												 fromView:nil];
			CGRect viewFrame = [self derp_viewFrameForKeyboardAppearing:YES toFrame:keyboardFrame];
			
			[UIView beginAnimations:@"UIKeyboard" context:nil];
			
			[UIView setAnimationDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
			[UIView setAnimationCurve:[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
			
			self.view.frame = viewFrame;
			
			[UIView commitAnimations];
		}];
	}];
	
	id willHide = [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:mainQueue usingBlock:^(NSNotification *note) {
		[self derp_performIfVisible:^{
			CGRect keyboardFrame = [self.view convertRect:[(NSValue *)note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]
												 fromView:nil];
			CGRect viewFrame = [self derp_viewFrameForKeyboardAppearing:NO toFrame:keyboardFrame];
			
			[UIView beginAnimations:@"UIKeyboard" context:nil];
			
			[UIView setAnimationDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
			[UIView setAnimationCurve:[note.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
			
			self.view.frame = viewFrame;
			
			[UIView commitAnimations];
		}];
	}];
	
	objc_setAssociatedObject(self, "derp_willShowKeyboardNotification", willShow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	objc_setAssociatedObject(self, "derp_willHideKeyboardNotification", willHide, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGRect)derp_viewFrameForKeyboardAppearing:(BOOL)isAppearing toFrame:(CGRect)keyboardFrame{
	CGFloat minimumHeight = [[self ym_optionOrDefaultForKey:DerpKeyboardViewHandlerOptions.minHeight] floatValue];
	CGRect viewFrame = self.view.frame;
	CGFloat keyboardHeight = (isAppearing ? -1.0 : +1.0) * keyboardFrame.size.height;
	if (viewFrame.size.height - keyboardFrame.size.height < minimumHeight) {
		// pin at minimum height and nudge the whole frame up/down
		viewFrame.size.height = minimumHeight;
		viewFrame.origin.y = viewFrame.origin.y + keyboardHeight;
	}
	else {
		// just adapt height
		viewFrame.size.height = viewFrame.size.height + keyboardHeight;
	}
	return viewFrame;
}

-(void)derp_removeKeyboardViewHandlers{
	id willShow = objc_getAssociatedObject(self, "derp_willShowKeyboardNotification");
	id willHide = objc_getAssociatedObject(self, "derp_willHideKeyboardNotification");
	
	if(willShow){
		[[NSNotificationCenter defaultCenter] removeObserver:willShow];
		objc_setAssociatedObject(self, "derp_willShowKeyboardNotification", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}

	if(willHide){
		[[NSNotificationCenter defaultCenter] removeObserver:willHide];
		objc_setAssociatedObject(self, "derp_willHideKeyboardNotification", nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

@end
