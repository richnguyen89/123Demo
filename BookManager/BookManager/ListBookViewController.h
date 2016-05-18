//
//  ListBookViewController.h
//  BookManager
//
//  Created by Rich Nguyen on 3/25/16.
//  Copyright © 2016 Rich Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookViewCell.h"
@interface ListBookViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BookViewCellDelegate>
{
    
    NSMutableArray * books;
    __weak IBOutlet UITableView *booksTableView;
}

@end
