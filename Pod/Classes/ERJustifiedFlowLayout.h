//  ERJustifiedFlowLayout.h

/* Copyright (c) 2015 Evan Roth

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation 
 files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
 modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
 is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS 
 BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF 
 OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */

#import <UIKit/UIKit.h>

/** Selected type of horizontal justification to perform. */
typedef NS_ENUM(NSInteger, FlowLayoutHorizontalJustification) {
	FlowLayoutHorizontalJustificationLeft = 1,
	FlowLayoutHorizontalJustificationCenter = 2,
	FlowLayoutHorizontalJustificationRight = 3,
	FlowLayoutHorizontalJustificationFull = 4
};

/** Selected type of vertical justification to perform. Note: not yet implemented.*/
typedef NS_ENUM(NSInteger, FlowLayoutVerticalJustification) {
	FlowLayoutVerticalJustificationTop = 1,
	FlowLayoutVerticalJustificationMiddle = 2,
	FlowLayoutVerticalJustificationBottom = 3
};

/**
 * Subclass of UICollectionViewFlowLayout to support cell horizontal and vertical justification, as well as to maintain fixed space between cells
 */
@interface ERJustifiedFlowLayout : UICollectionViewFlowLayout

/** Set horizontal justification from FlowLayoutHorizontalJustification enum options */
@property (nonatomic, assign) FlowLayoutHorizontalJustification horizontalJustification;

/** Set vertical justification from FlowLayoutVerticalJustification enum options. Note: not yet implemented. */
@property (nonatomic, assign) FlowLayoutVerticalJustification verticalJustification;

/** Set a constant for a fixed horizontal distance between cells. Note: will have no effect when used with FlowLayoutHorizontalJustificationFull. */
@property (nonatomic, assign) CGFloat horizontalCellPadding;

@end
