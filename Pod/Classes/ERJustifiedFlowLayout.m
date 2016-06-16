//  ERJustifiedFlowLayout.m

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

#import "ERJustifiedFlowLayout.h"

@implementation ERJustifiedFlowLayout

-(CGSize)collectionViewContentSize {
    if (self.horizontalJustification == FlowLayoutHorizontalJustificationLeft) {
        CGSize oldSize = [super collectionViewContentSize];
        NSArray *attributes = [self layoutAttributesForElementsInRect:CGRectMake(0, 0, oldSize.width, oldSize.height)];
        UICollectionViewLayoutAttributes *attrs = attributes.lastObject;
        CGFloat height = attrs.frame.origin.y + attrs.size.height;

        return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), height + self.sectionInset.bottom);
    }

    return [super collectionViewContentSize];
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
	
	if (self.horizontalJustification == FlowLayoutHorizontalJustificationLeft) {
        CGSize oldSize = [super collectionViewContentSize];
		NSArray *attributesForElementsInRect = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, oldSize.width, oldSize.height)];
		NSMutableArray *attrsCopy = [self attributesDeepCopyForOriginalAttributes:attributesForElementsInRect];
		NSMutableArray *newAttributesForElementsInRect = [[NSMutableArray alloc] initWithCapacity:attributesForElementsInRect.count];
		
		CGFloat leftMargin = self.sectionInset.left;
        CGFloat topMargin = self.sectionInset.top;
		
		// Assumes attributes are in order by index path
        for (NSUInteger idx = 0; idx < attrsCopy.count; idx++) {
            UICollectionViewLayoutAttributes *attributes = attrsCopy[idx];

            CGRect newLeftAlignedFrame = attributes.frame;
            newLeftAlignedFrame.origin.x = leftMargin;
            newLeftAlignedFrame.origin.y = topMargin;
            attributes.frame = newLeftAlignedFrame;

            if (leftMargin + attributes.frame.size.width > CGRectGetWidth(rect) - self.sectionInset.right) {
                CGRect newLeftAlignedFrame = attributes.frame;
                newLeftAlignedFrame.origin.x = self.sectionInset.left;
                newLeftAlignedFrame.origin.y += CGRectGetHeight(newLeftAlignedFrame) + MAX(self.sectionInset.top, self.minimumLineSpacing);

                attributes.frame = newLeftAlignedFrame;
                leftMargin = self.sectionInset.left;
                topMargin = newLeftAlignedFrame.origin.y;
            }

            leftMargin += attributes.frame.size.width + self.horizontalCellPadding;
            
            [newAttributesForElementsInRect addObject:attributes];
        }
		
		return newAttributesForElementsInRect;
	}
	if (self.horizontalJustification == FlowLayoutHorizontalJustificationFull) {
		return [super layoutAttributesForElementsInRect:rect];
	}
	
	if (self.horizontalJustification == FlowLayoutHorizontalJustificationRight) {
		NSArray *attributesForElementsInRect = [super layoutAttributesForElementsInRect:rect];
		
		// Deep copy attributes to avoid debugger error
		NSMutableArray *attrsCopy = [self attributesDeepCopyForOriginalAttributes:attributesForElementsInRect];
		NSMutableArray *newAttributesForElementsInRect = [[NSMutableArray alloc] initWithCapacity:attrsCopy.count];
		
		CGFloat rightMargin = 0.0;
		int startingRowIndex = 0;
		int endingRowIndex = 0;
		int idx = 0;
		
		// Assumes attributes are in order by index path
		for (UICollectionViewLayoutAttributes *anAttribute in attrsCopy) {
			[newAttributesForElementsInRect addObject:anAttribute];
			
			// Pull out the last cell on each line, indicated by its x-origin and width adding up to the size of the collectionView minus
			// the right sectionInset.  On the last line of the collection view, the right-most cell may not be initially placed at the
			// far right-hand side, so we check if it's the last element in the array in that case
			if (anAttribute.frame.origin.x + anAttribute.frame.size.width == rect.size.width - self.sectionInset.right || [attrsCopy indexOfObjectIdenticalTo:anAttribute] == attrsCopy.count-1) {
				rightMargin = rect.size.width - anAttribute.bounds.size.width - self.sectionInset.right;
				CGRect newRightAlignedFrame = anAttribute.frame;
				newRightAlignedFrame.origin.x = rightMargin;
				anAttribute.frame = newRightAlignedFrame;
				endingRowIndex = idx;
				
				// Iterate back to the first cell in that row from the current position and readjust x-origin based on the last cell's position
				for (int i = endingRowIndex-1; i >= startingRowIndex; i--) {
					UICollectionViewLayoutAttributes *prevAttribute = attrsCopy[i];
					newRightAlignedFrame = prevAttribute.frame;
					newRightAlignedFrame.origin.x = rightMargin - prevAttribute.bounds.size.width - self.horizontalCellPadding;

                    if (newRightAlignedFrame.origin.x < 0) {
                        newRightAlignedFrame.origin.x = CGRectGetWidth(rect) - self.sectionInset.right - CGRectGetWidth(prevAttribute.frame);
                    }

					prevAttribute.frame = newRightAlignedFrame;
					rightMargin = newRightAlignedFrame.origin.x;
					[newAttributesForElementsInRect replaceObjectAtIndex:i withObject:prevAttribute];
				}
				
				startingRowIndex = ++endingRowIndex;
			}
			idx++;
		}
		
		return newAttributesForElementsInRect;
	}
	
	NSAssert(NO, @"Must provide a horizontal justification for FlowLayoutHorizontalJustification");
	return nil;
}

-(void)setHorizontalJustification:(FlowLayoutHorizontalJustification)horizontalJustification {
	if (horizontalJustification == FlowLayoutHorizontalJustificationCenter) {
		NSAssert(NO, @"Sorry, centered horizontal justification hasn't been implemented yet.");
	}
	else {
		_horizontalJustification = horizontalJustification;
	}
}

-(void)setVerticalJustification:(FlowLayoutVerticalJustification)verticalJustification {
	NSAssert(NO, @"Sorry, vertical justification hasn't been implemented yet.");
}

- (NSMutableArray *)attributesDeepCopyForOriginalAttributes:(NSArray *)originalAttributes {
	NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:originalAttributes.count];
	
	for (UICollectionViewLayoutAttributes *originalAttribute in originalAttributes) {
		[returnArray addObject:[originalAttribute copy]];
	}
	
	return returnArray;
}

@end