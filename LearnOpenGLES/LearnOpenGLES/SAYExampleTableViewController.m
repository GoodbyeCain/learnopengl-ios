//
//  SAYExampleTableViewController.m
//  LearnOpenGLES
//
//  Created by CainGoodbye on 2019/2/28.
//  Copyright © 2019 CainGoodbye. All rights reserved.
//

#import "SAYExampleTableViewController.h"
#import "SAYGLKViewController.h"

@interface SAYExampleTableViewController ()
@property (nonatomic, strong) NSMutableArray *exmples;
@end

@implementation SAYExampleTableViewController

- (NSMutableArray *)exmples {
    if (!_exmples) {
        _exmples = [NSMutableArray array];
    }
    return _exmples;
}

- (void)registerExample:(NSString *) className {
    Class cls = NSClassFromString(className);
    if (!cls) {
        NSLog(@"register example filed, %@ not exist", className);
    }
    
    if (![cls conformsToProtocol:NSProtocolFromString(@"SAYExampleProtocol")]) {
        NSLog(@"register example filed, %@ not conforms to SAYExampleProtocol", className);
    }
    
    
    [self.exmples addObject:className];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Learn OpenGL ES";
    [self registerExample:@"SAYHelloTriangle"];
    [self registerExample:@"SAYFramebuffer"];
    [self registerExample:@"SAYCubeMap"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _exmples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"exampleCellIdentifier"];
    NSString *drawInstanceName = _exmples[indexPath.row];
    cell.textLabel.text = drawInstanceName;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main"  bundle:nil];
    SAYGLKViewController *viewController =
        [storyBoard instantiateViewControllerWithIdentifier:@"SAYGLKViewController"];
    NSString *drawInstanceName = _exmples[indexPath.row];
    Class cls = NSClassFromString(drawInstanceName);
    viewController.drawInstance = [[cls alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
