//
//  ERCollectionViewCell.m
//  ERJustifiedFlowLayout
//
//  Created by Evan Roth on 6/16/15.
//  Copyright (c) 2015 Evan Roth. All rights reserved.
//

#import "ERCollectionViewCell.h"

@interface ERCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *stringLabel;

@end

@implementation ERCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)drawRect:(CGRect)rect {
	
	// inset by half line width to avoid cropping where line touches frame edges
	CGRect insetRect = CGRectInset(rect, 0.5, 0.5);
	UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:rect.size.height/2.0];
	
	// white background
	[[UIColor whiteColor] setFill];
	[path fill];
	
	// red outline
	[[UIColor redColor] setStroke];
	[path stroke];
}

-(void)setLabelText:(NSString *)labelText {
	self.stringLabel.text = labelText;
}

@end
