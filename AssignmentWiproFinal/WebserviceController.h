//
//  WebserviceController.h
//  AssignmentWiproFinal
//
//  Created by AvisBudget on 12/5/17.
//  Copyright © 2017 AvisBudget. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebserviceDelegate;

@interface WebserviceController : NSObject
{
	id<WebserviceDelegate> delegate;
}
@property(retain, nonatomic) id<WebserviceDelegate>delegate;
-(void)getData;

@end

@protocol WebserviceDelegate<NSObject>
-(void) getRowArray:(NSArray *)rowArray;
-(void) serviceFailed;
@end
