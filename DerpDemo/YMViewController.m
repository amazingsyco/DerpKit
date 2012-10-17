
//  Created by YangMeyer on 17.10.12.
//  Copyright (c) 2012 Yang Meyer. All rights reserved.

#import "YMViewController.h"
#import "UIViewController+Derp.h"

@implementation YMViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self derp_addKeyboardViewHandlers];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	[self derp_removeKeyboardViewHandlers];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

@end
