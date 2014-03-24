//
//  FindObligationViewController.m
//  ProjectGO
//
//  Created by Kyle Brown on 2014-03-13.
//  Copyright (c) 2014 com.ProjectGO. All rights reserved.
//

#import "FindObligationViewController.h"

@interface FindObligationViewController ()

@end

@implementation FindObligationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (IBAction)searchByID:(id)sender {
    
    NSDictionary* json = [self getObligationsByID:_idField.text];
    
    int failed = 0;
    if ([[json valueForKeyPath:@"error"] intValue] > 0) {
        failed = [[json objectForKey:@"error" ] integerValue];
    }
    
    if (failed) {
        [self setFailed];
    }
    else {
        NSString *text2 = [json objectForKey:@"name"];
        NSString *desc2 = [json objectForKey:@"description"];
        NSString *startdate2 = [json objectForKey:@"starttime"];
        NSString *enddate2 = [json objectForKey:@"endtime"];
        NSString *priority2 = [[json objectForKey:@"priority"] stringValue];
        NSString *status2 = [[json objectForKey:@"status"] stringValue];
        NSString *category2 = [[json objectForKey:@"category"] stringValue];
        
        [self setSuccess:(NSString*)text2 arg2:(NSString*)desc2 arg3:(NSString*)startdate2 arg4:(NSString*)enddate2 arg5:(NSString*)priority2 arg6:(NSString*)status2 arg7:(NSString*)category2];
    }
}

- (void)setFailed{
    _name.text = NO_MATCH;
    _desription.text = REVIEW_ID;
    _startdate.text = @"";
    _enddate.text = @"";
    _priority.text = @"";
    _status.text = @"";
    _category.text = @"";
    
}

- (void)setSuccess: text2 arg2:(NSString*)desc2 arg3:(NSString*)startdate2 arg4:(NSString*)enddate2 arg5:(NSString*)priority2 arg6:(NSString*)status2 arg7:(NSString*)category2{
    _name.text = text2;
    _desription.text = desc2;
    _startdate.text = startdate2;
    _enddate.text = enddate2;
    _priority.text = priority2;
    _status.text = status2;
    _category.text = category2;
}

- (NSDictionary*)getObligationsByID:(NSString*)obid{
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@", SERVER_ADDRESS, OBLIGATION_SUB_URL, _idField.text];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest: request
                    returningResponse: &response
                    error: &error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error != nil)
    {
        json = [[NSDictionary alloc] initWithObjectsAndKeys:@"1", @"error", nil];
    }
    
    return json;
}

@end
