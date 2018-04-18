//
//  ViewController.h
//  AssignmentWiproFinal
//
//  Created by AvisBudget on 12/5/17.
//  Copyright © 2017 AvisBudget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebserviceController.h"


@interface ViewController : UIViewController <WebserviceDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *rowArray;
@property (strong, nonatomic) UITableView *dataTableView;
-(void) setUpView;
@end
