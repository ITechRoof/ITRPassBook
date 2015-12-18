//
//  ViewController.m
//  ITRPassBook
//
//  Created by kiruthika selvavinayagam on 11/18/15.
//  Copyright © 2015 kiruthika selvavinayagam. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>

@interface ViewController ()
{
    PKPassLibrary *_passLib;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(![PKPassLibrary isPassLibraryAvailable]) {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Pass Library Error" message:@"The Pass Library is not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    _passLib = [[PKPassLibrary alloc] init];
}

- (IBAction)addPassButtonPressed:(id)sender {
    
    //load  coupon.pkpass from resource bundle
    NSString *passPath = [[NSBundle mainBundle] pathForResource:@"boardingPass" ofType:@"pkpass"];
    NSData *data = [NSData dataWithContentsOfFile:passPath];
    NSError *error;
    
    PKPass *pass = [[PKPass alloc] initWithData:data error:&error];
    
    if (error!=nil) {
        [[[UIAlertView alloc] initWithTitle:@"Passes error"
                                    message:[error
                                             localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
        return;
    }
    
    if(pass){
        //init a pass library
        PKPassLibrary* passLib = [[PKPassLibrary alloc] init];
        
        //check if pass library contains this pass already
        if([passLib containsPass:pass]) {
            
            //pass already exists in library, show an error message
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Pass Exists" message:@"The pass you are trying to add to Passbook is already present." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
        } else {
            
            //present view controller to add the pass to the library
            PKAddPassesViewController *addPassViewController = [[PKAddPassesViewController alloc] initWithPass:pass];
            [addPassViewController setDelegate:(id)self];
            [self presentViewController:addPassViewController animated:YES completion:nil];
        }
    }
   
}

#pragma mark - PKAddPassesViewController delegate
-(void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller {
   
    [controller dismissViewControllerAnimated:YES completion:^{
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Pass Added" message:@"Your pass added to wallet successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }];

}

@end
