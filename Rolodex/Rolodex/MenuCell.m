//
//  MenuCell.m
//  Rolodex
//
//  Created by Peter Shih on 11/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuCell.h"

@implementation MenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [PSStyleSheet applyStyle:@"menuCellTitle" forLabel:self.textLabel];
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    [PSStyleSheet applyStyle:@"menuCellSubtitle" forLabel:self.detailTextLabel];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
  }
  return self;
}

#pragma mark - Fill and Height
- (void)fillCellWithObject:(id)object
{
  NSDictionary *info = (NSDictionary *)object;
  self.textLabel.text = [info objectForKey:@"title"];
  self.detailTextLabel.text = [info objectForKey:@"subtitle"];
}

+ (CGFloat)rowHeight {
  return 44.0;
}

+ (CGFloat)rowHeightForObject:(id)object forInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return 44.0;
}

@end
