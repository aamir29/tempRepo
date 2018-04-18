//
//  AppDelegate.h
//  AssignmentWiproFinal
//
//  Created by AvisBudget on 12/5/17.
//  Copyright © 2017 AvisBudget. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

