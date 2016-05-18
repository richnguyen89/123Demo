//
//  BookViewCell.h
//  BookManager
//
//  Created by Rich Nguyen on 3/25/16.
//  Copyright © 2016 Rich Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPSessionManager.h"
#import "Database.h"
@protocol BookViewCellDelegate;
@interface BookViewCell : UITableViewCell
{
        Database *db;
    //id<BookViewCellDelegate>    delegate;
}

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (readwrite, nonatomic) BOOL isDownload;
@property (readwrite, nonatomic) NSDictionary *dict;
@property (readwrite, nonatomic) NSString *imgURL;
- (void) loadImage:(NSString *) link;
- (void) cellLoadTitle;
@property(nonatomic,assign)IBOutlet id<BookViewCellDelegate> delegate;
@end

@protocol BookViewCellDelegate

-(void)downloadSuccess:(id)sender;

@end

