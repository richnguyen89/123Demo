//
//  ListBookViewController.m
//  BookManager
//
//  Created by Rich Nguyen on 3/25/16.
//  Copyright © 2016 Rich Nguyen. All rights reserved.
//

#import "ListBookViewController.h"

#import "DetailViewController.h"
#import "AFHTTPSessionManager.h"

@interface ListBookViewController ()
{
    NSMutableArray *arrayCell ;
}
@end

@implementation ListBookViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    books = [[NSMutableArray alloc] init];
    [self loadData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (void)loadData
{
    arrayCell = [[NSMutableArray alloc] init];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://192.168.6.111:8080/data.json" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        if([responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = responseObject;
            //NSLog(@"results: %@", results);
            books = [results valueForKey:@"data"];
            for(int i  = 0;i<[books count];i++)
            {
                NSDictionary * dict = (NSDictionary *)[books objectAtIndex:i];
                [self addCell:dict];
            }
            [booksTableView reloadData];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
-(void)addCell:(NSDictionary *)dict
{
    BookViewCell *cell = (BookViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"BookViewCell" owner:self options:nil] objectAtIndex:0];//[[array
    cell.dict = dict;
    cell.isDownload = NO;
    cell.delegate = self;
    [cell cellLoadTitle];
    [arrayCell addObject:cell];
}
- (NSInteger)tableView:(UITableView *)tableViews numberOfRowsInSection:(NSInteger)section
{
    
    return [books count];
}
- (UITableViewCell *)tableView:(UITableView *)tableViews cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%li%li", (long)indexPath.section, (long)indexPath.row];
//    BookViewCell *cell = (BookViewCell *)[tableViews dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell = (BookViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"BookViewCell" owner:self options:nil] objectAtIndex:0];//[[array objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//        
//        NSDictionary *dict = (NSDictionary *)[books objectAtIndex:indexPath.row];
//        cell.lblTitle.text = [dict valueForKey:@"booktitle"];
//        if(!cell.isDownload)
//        {
//            [cell loadImage:[NSString stringWithFormat:@"http://192.168.6.111:8080/image/%@",[dict valueForKey:@"image"]]];
//        }
//        
//        cell.delegate = self;
//    }
    BookViewCell *cell = (BookViewCell *) [arrayCell objectAtIndex:indexPath.row];
    if(cell.isDownload == NO)
    {
        [cell loadImage:[NSString stringWithFormat:@"http://192.168.6.111:8080/image/%@",[cell.dict valueForKey:@"image"]]];
    }
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableViews didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableViews deselectRowAtIndexPath:indexPath animated:YES];
    
    BookViewCell *cell = (BookViewCell *) [arrayCell objectAtIndex:indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Book" bundle:nil];
    DetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DetailViewController"];
    NSData *imageData = [[NSData alloc] initWithContentsOfFile:cell.imgURL];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    vc.image = image;
    vc.strTittle = [cell.dict valueForKey:@"booktitle"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    //vc.imageView.image = image;
    //vc.lblTittle.text = cell.lblTitle.text;
    
}
- (void)downloadSuccess:(id)sender
{
    BookViewCell *cell = (BookViewCell *)sender;
    NSIndexPath* rowToReload = [booksTableView indexPathForCell:cell];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [booksTableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
}
//- (void)loadImage:(NSString *)imgURL
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // UI UPDATION 1
//        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
//        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
//        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"Response: %@", responseObject);
//            _imageView.image = responseObject;
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Image error: %@", error);
//        }];
//        [requestOperation start];
//    });
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
