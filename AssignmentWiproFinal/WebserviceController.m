//
//  WebserviceController.m
//  AssignmentWiproFinal
//
//  Created by AvisBudget on 12/5/17.
//  Copyright © 2017 AvisBudget. All rights reserved.
//

#import "WebserviceController.h"


@implementation WebserviceController

@synthesize delegate;

-(void)getData
{
    // Asynchronously API is hit here
    NSURL *url = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *iso = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
         NSData *dutf8 = [iso dataUsingEncoding:NSUTF8StringEncoding];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dutf8 options:NSJSONReadingMutableContainers error:&error];
         [delegate getRowArray:[dict objectForKey:@"rows"]];
     }];
}

@end
