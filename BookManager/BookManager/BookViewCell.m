//
//  BookViewCell.m
//  BookManager
//
//  Created by Rich Nguyen on 3/25/16.
//  Copyright © 2016 Rich Nguyen. All rights reserved.
//

#import "BookViewCell.h"

@implementation BookViewCell

@synthesize delegate;
@synthesize isDownload;
@synthesize dict;
@synthesize imgURL;
- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) cellLoadTitle
{
    self.lblTitle.text  = [self.dict valueForKey:@"booktitle"];
}
- (void) loadImage:(NSString *) link
{
    NSLog(@"link %@",link );
    __block UIImage *image = [UIImage imageNamed:@"no_user_profile_pic.png"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager GET:link
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             image = (UIImage *) responseObject;
             self.imgView.image = image;
             self.isDownload = true;
             [delegate downloadSuccess:self];
             [self saveImage:image withFileName:[self.dict valueForKey:@"image"]];
             
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Load Image error - %@", [error description]);
         }];

}

- (void) saveImage : (UIImage *)img withFileName:(NSString *)name
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    
    NSData * binaryImageData = UIImagePNGRepresentation(img);
    NSString *url = [basePath stringByAppendingPathComponent:name];
    [binaryImageData writeToFile:url atomically:YES];
    self.imgURL = url;
    [self performSelector:@selector(insertDB) withObject:nil afterDelay:1.0f];
    
    NSLog(@"path : %@",url);
}

- (void)insertDB
{
    
    db = [[Database alloc] init];
    [db connectToDatabase:@"Book" ofType:@"db"];
    
    db.sqlQuery = [NSString stringWithFormat:@"INSERT INTO tbl_book (Name, URL) VALUES('%@','%@')",[self.dict valueForKey:@"booktitle"],self.imgURL];
    [db excuteQueryInsertOrUpdate];
    [db close];
    
}
@end
