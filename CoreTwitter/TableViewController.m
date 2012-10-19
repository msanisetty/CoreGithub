//
//  TableViewController.m
//  CoreTwitter
//
//  Created by Dave Henke on 10/19/12.
//  Copyright (c) 2012 Solstice Mobile. All rights reserved.
//

#import "TableViewController.h"
#import "GitHubService.h"
#import "Event.h"

@interface TableViewController ()

@property (nonatomic, strong) NSArray *data;

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[GitHubService shared] storedEventsWithCompletion:^(NSArray *array){
        self.data = array;
    } andErrors:^(NSError *err){
        [[[UIAlertView alloc] initWithTitle:@"Failed Fetch Request" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Event *event = [self.data objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",event.userName,event.type];
    return cell;
}

- (IBAction)refresh:(id)sender {
    [[GitHubService shared] eventsWithCompletion:^(NSArray *objects){
        self.data = objects;
        [self.tableView reloadData];
    } andErrors:^(NSError *err){
        [[[UIAlertView alloc] initWithTitle:@"Failed REST Request" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}
@end
