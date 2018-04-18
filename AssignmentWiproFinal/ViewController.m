//
//  ViewController.m
//  AssignmentWiproFinal
//
//  Created by AvisBudget on 12/5/17.
//  Copyright © 2017 AvisBudget. All rights reserved.
//

#import "ViewController.h"
#import "WebserviceController.h"
#import "DataModel.h"

@interface ViewController (){
    UINavigationBar* navbar;
    
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) WebserviceController *webserviceController;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(orientationChanged:)
     name:UIDeviceOrientationDidChangeNotification
     object:[UIDevice currentDevice]];
    
	[self setUpView];

	self.webserviceController = [[WebserviceController alloc] init];
	self.rowArray = [[NSMutableArray alloc] init];
	[self.webserviceController setDelegate:self];
	[self.webserviceController getData];
	
	self.refreshControl = [[UIRefreshControl alloc]init];
	[self.dataTableView addSubview:self.refreshControl];
	[self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(void) getRowArray:(NSArray *)rowArray;
{
    [self parseData:rowArray];
	dispatch_async(dispatch_get_main_queue(), ^{
		// do your UI stuff here
		[self.refreshControl endRefreshing];
		[self.dataTableView reloadData];
	});
}

#pragma mark - Table View Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
	}
    
    DataModel *datamodel = [self.rowArray objectAtIndex:indexPath.row];
    cell.textLabel.text = datamodel.title;
    cell.detailTextLabel.text = datamodel.desc;
    NSString *imageURL = datamodel.imageURL;

	cell.imageView.image = nil;
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_async(queue, ^(void) {
		
	NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
						 
						 UIImage* image = [[UIImage alloc] initWithData:imageData];
						 if (image) {
							 dispatch_async(dispatch_get_main_queue(), ^{
								 if (cell.tag == indexPath.row) {
									 cell.imageView.image = image;
									 [cell setNeedsLayout];
								 }
							 });
						 }
	});
	
	[cell.imageView sizeToFit];
	
	cell.detailTextLabel.numberOfLines = 5;
	cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
	[cell.detailTextLabel sizeToFit];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataModel *datamodel = [self.rowArray objectAtIndex:indexPath.row];
    NSString *descriptionString = datamodel.desc;
	
	NSAttributedString *attributedText =
	[[NSAttributedString alloc] initWithString:descriptionString
									attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:14]}];
	CGRect rect = [attributedText boundingRectWithSize:(CGSize){280.0f, CGFLOAT_MAX}
											   options:NSStringDrawingUsesLineFragmentOrigin
											   context:nil];
	CGSize size = rect.size;
		
	return 80 + size.height;
}

#pragma mark - Refresh controller Methods
- (void)refreshTable {
	//TODO: refresh your data
	[self.webserviceController getData];
}

-(void) serviceFailed
{
	[self.refreshControl endRefreshing];
}

-(void) setUpView
{
	navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
	UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle:@"About Canada"];
	[navbar setItems:@[navItem]];

	
	self.dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 44, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
	self.dataTableView.delegate = self;
	self.dataTableView.dataSource = self;
	
	[self.view addSubview:self.dataTableView];
	[self.view addSubview:navbar];
}

#pragma mark - Orientation
- (void) orientationChanged:(NSNotification *)note
{
    [self.dataTableView setFrame:CGRectMake(self.view.frame.origin.x, 44, self.view.frame.size.width, self.view.frame.size.height)];
    [navbar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
}

#pragma mark - Parsing Logic
-(void) parseData:(NSArray *)dataArray
{
    for (int i = 0; i < [dataArray count]; i++)
    {
        DataModel *datamodel = [[DataModel alloc] init];
        datamodel.title = ([[dataArray objectAtIndex:i] objectForKey:@"title"] != [NSNull null]) ? [[dataArray objectAtIndex:i] objectForKey:@"title"] : @"";
        datamodel.desc = ([[dataArray objectAtIndex:i] objectForKey:@"description"] != [NSNull null]) ? [[dataArray objectAtIndex:i] objectForKey:@"description"] : @"";
        datamodel.imageURL = ([[dataArray objectAtIndex:i] objectForKey:@"imageHref"] != [NSNull null]) ? [[dataArray objectAtIndex:i] objectForKey:@"imageHref"] : @"";
        [self.rowArray addObject:datamodel];
    }
}
@end
