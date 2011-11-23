//
//  MenuViewController.m
//  Rolodex
//
//  Created by Peter Shih on 11/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"

#import "MenuCell.h"

#import "PSDrawerController.h"
#import "ProfileViewController.h"
#import "RolodexViewController.h"

@implementation MenuViewController

#pragma mark - Init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    
  }
  return self;
}

- (void)viewDidUnload {
  [super viewDidUnload];
  RELEASE_SAFELY(_searchField);
}

- (void)dealloc {
  [super dealloc];
  
  // Views
  RELEASE_SAFELY(_searchField);
}

#pragma mark - View Config
- (UIView *)backgroundView {
  UIImageView *bgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundLeather.jpg"]] autorelease];
  return bgView;
}

#pragma mark - View
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Search
  UIView *searchView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.0)] autorelease];
  searchView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  UIImageView *searchBgView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"BackgroundNavigationBar.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:1]] autorelease];
  searchBgView.autoresizingMask = searchView.autoresizingMask;
  [searchView addSubview:searchBgView];
  
  CGFloat searchWidth = searchView.width - 20;
  _searchField = [[PSSearchField alloc] initWithFrame:CGRectMake(10, 7, searchWidth, 30) style:PSSearchFieldStyleBlack];
  _searchField.delegate = self;
  _searchField.placeholder = @"Search";
//  [_searchField addTarget:self action:@selector(searchTermChanged:) forControlEvents:UIControlEventEditingChanged];
  [searchView addSubview:_searchField];
  
  [self.view addSubview:searchView];
  
  // Add a TableView
  [self setupTableViewWithFrame:CGRectMake(0, searchView.bottom, self.view.width, self.view.height - searchView.height) style:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleNone separatorColor:nil];
  
  [self loadDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  if ([_searchField isFirstResponder]) {
    [_searchField resignFirstResponder];
  }
}

#pragma mark - State Machine
- (void)loadDataSource {
  [super loadDataSource];
  
  // Prepare Data
  
  // First section
  NSMutableArray *items = [NSMutableArray array];
  NSMutableArray *firstSection = [NSMutableArray array];
  NSDictionary *s0r0 = [NSDictionary dictionaryWithObjectsAndKeys:@"First Controller", @"title", nil];
  [firstSection addObject:s0r0];
  NSDictionary *s0r1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Second Controller", @"title", nil];
  [firstSection addObject:s0r1];
  [items addObject:firstSection];
  
  [self dataSourceShouldLoadObjects:items shouldAnimate:NO];
}

- (void)dataSourceDidLoad {
  [super dataSourceDidLoad];
}

#pragma mark - TableView
- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath {
  return [MenuCell class];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  Class cellClass = [self cellClassAtIndexPath:indexPath];
  return [cellClass rowHeight];
}

- (void)tableView:(UITableView *)tableView configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath {
  NSMutableDictionary *object = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  [cell fillCellWithObject:object];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  Class cellClass = [self cellClassAtIndexPath:indexPath];
  id cell = nil;
  NSString *reuseIdentifier = [cellClass reuseIdentifier];
  
  cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if(cell == nil) { 
    cell = [[[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
    [_cellCache addObject:cell];
  }
  
  [self tableView:tableView configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  NSMutableDictionary *object = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

  if (indexPath.row == 0) {
    ProfileViewController *pvc = [[ProfileViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nc = [[[[NSBundle mainBundle] loadNibNamed:@"PSNavigationController" owner:self options:nil] lastObject] retain];
    nc.viewControllers = [NSArray arrayWithObject:pvc];
    [pvc release];
    
    [APP_DELEGATE.drawerController setViewControllers:[NSArray arrayWithObjects:self, nc, nil]];
    [nc release];
  } else if (indexPath.row == 1) {
    RolodexViewController *rvc = [[RolodexViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nc = [[[[NSBundle mainBundle] loadNibNamed:@"PSNavigationController" owner:self options:nil] lastObject] retain];
    nc.viewControllers = [NSArray arrayWithObject:rvc];
    [rvc release];
    
    [APP_DELEGATE.drawerController setViewControllers:[NSArray arrayWithObjects:self, nc, nil]];
    [nc release];
  }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [APP_DELEGATE hide];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  [APP_DELEGATE hide];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  if (![textField isEditing]) {
    [textField becomeFirstResponder];
  }
  [textField resignFirstResponder];
  
  return YES;
}

@end
