//
//  DetailViewController.m
//  BookManager
//
//  Created by Rich Nguyen on 3/25/16.
//  Copyright © 2016 Rich Nguyen. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()


@end

@implementation DetailViewController
@synthesize lblTittle;
@synthesize imageView;
@synthesize image;
@synthesize strTittle;
- (void)viewDidLoad {
    //log add
    [super viewDidLoad];
    self.imageView.image = self.image;
    self.lblTittle.text = self.strTittle;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
