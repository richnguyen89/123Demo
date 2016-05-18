//
//  DetailViewController.h
//  BookManager
//
//  Created by Rich Nguyen on 3/25/16.
//  Copyright © 2016 Rich Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
//log test
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *strTittle;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *lblTittle;
@end
