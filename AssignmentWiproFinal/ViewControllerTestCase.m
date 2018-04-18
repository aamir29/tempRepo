//
//  ViewControllerTestCase.m
//  AssignmentWiproFinal
//
//  Created by AvisBudget on 12/6/17.
//  Copyright © 2017 AvisBudget. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"

@interface ViewControllerTestCase : XCTestCase
@property (nonatomic, strong) ViewController *viewController;
@end

@implementation ViewControllerTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	self.viewController = [storyboard instantiateViewControllerWithIdentifier:@"DataTableView"];
    [self.viewController setUpView];
	[self.viewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
	self.viewController = nil;
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

#pragma mark - View loading tests
-(void)testThatViewLoads
{
	XCTAssertNotNil(self.viewController.view, @"View not initiated properly");
}

-(void)testThatTableViewLoads
{
	XCTAssertNotNil(self.viewController.dataTableView, @"TableView not initiated");
}

#pragma mark - UITableView tests
- (void)testThatViewConformsToUITableViewDataSource
{
	XCTAssertTrue([self.viewController conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

- (void)testThatTableViewHasDataSource
{
	XCTAssertNotNil(self.viewController.dataTableView.dataSource, @"Table datasource cannot be nil");
}

- (void)testThatViewConformsToUITableViewDelegate
{
	XCTAssertTrue([self.viewController conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

- (void)testTableViewIsConnectedToDelegate
{
	XCTAssertNotNil(self.viewController.dataTableView.delegate, @"Table delegate cannot be nil");
}

- (void)testDataResponse
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    XCTAssertNotNil(filePath);
    
    NSString *myJSON = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    NSString *containsTitle = [myJSON containsString:@"title"] ? @"title" : nil;
    XCTAssertNotNil(containsTitle);
    
    NSString *containsDescription = [myJSON containsString:@"description"] ? @"description" : nil;
    XCTAssertNotNil(containsDescription);
    
    NSString *containsImageURL = [myJSON containsString:@"imageHref"] ? @"imageHref" : nil;
    XCTAssertNotNil(containsImageURL);
}
@end
