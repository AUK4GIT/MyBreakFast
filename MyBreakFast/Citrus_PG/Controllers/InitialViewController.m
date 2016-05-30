//
//  InitialViewController.m
//  CTS iOS Sdk
//
//  Created by Vikas Singh on 1/13/16.
//  Copyright © 2016 Citrus. All rights reserved.
//

#import "InitialViewController.h"
#import "SignUpViewController.h"
#import "MyBreakFast-Swift.h"

@interface InitialViewController (){
    
    int selectionType;

}

@end

@implementation InitialViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
     self.signupOptionOneButton.layer.cornerRadius = 4;
     self.signupOptionTwoButton.layer.cornerRadius = 4;
     self.signupOptionThreeButton.layer.cornerRadius = 4;
    
    if (authLayer.requestSignInOauthToken.length != 0) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self performSegueWithIdentifier:@"HomeScreenIdentifier" sender:nil];
            return;
        }];
    } else if ([Helper sharedInstance].order.modeOfPayment == PaymentTypeCARDS || [Helper sharedInstance].order.modeOfPayment == PaymentTypeNB){
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self performSegueWithIdentifier:@"HomeScreenIdentifier" sender:nil];
            return;
        }];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)selectLoginTypeAction:(UIButton *)sender{

    if (sender.tag == 1000) {
        selectionType = 0;
    }
    else if (sender.tag == 1001) {
        selectionType = 1;
    }
    else if (sender.tag == 1002) {
        selectionType = 2;
    }

    [self performSegueWithIdentifier:@"InitialViewIdentifier" sender:self];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"InitialViewIdentifier"]) {
        SignUpViewController *signUpViewController = (SignUpViewController *)[segue destinationViewController];
        
        // loginType = 0 -> by using Email Id & Mobile
        // loginType = 1 -> by using Mobile only
        // loginType = 2 -> by using either Email Id or Mobile
        
        signUpViewController.loginType = selectionType;
    }
    
}


- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
