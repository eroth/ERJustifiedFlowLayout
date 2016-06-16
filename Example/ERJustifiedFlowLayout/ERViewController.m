//
//  ERViewController.m
//  ERJustifiedFlowLayout
//
//  Created by Evan Roth on 06/15/2015.
//  Copyright (c) 2014 Evan Roth. All rights reserved.
//

#import "ERViewController.h"
#import "ERCollectionViewCell.h"
#import <ERJustifiedFlowLayout/ERJustifiedFlowLayout.h>

@interface ERViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ERCollectionViewCell *sizingCell;
@property (nonatomic, strong) NSArray *dataSourceArray;
@property (weak, nonatomic) IBOutlet ERJustifiedFlowLayout *customJustifiedFlowLayout;

@end

@implementation ERViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	UINib *cellNib = [UINib nibWithNibName:@"ERCollectionViewCell" bundle:nil];
	[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"ERCollectionViewCell"];
	
	self.sizingCell = [[cellNib instantiateWithOwner:nil options:nil] firstObject];
	
	NSString *dataSourceString = @"\"Accordingly, we anticipate that cost of revenue and operating expenses will increase substantially in the foreseeable future. These efforts may prove more expensive than we currently anticipate and we may not succeed in increasing our revenue sufficiently to offset these higher expenses. We cannot assure you that we will achieve profitability in the future or that, if we do become profitable, we will be able to sustain or increase profitability. Our prior losses, combined with our expected future losses, have had and will continue to have an adverse effect on our stockholders’ equity and working capital. As a result of these factors, we may need to raise additional capital through debt or equity financings in order to fund our operations, and such capital may not be available on reasonable terms, if at all.\"";

	self.dataSourceArray = [dataSourceString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	// ERJustifiedFlowLayout customization point-- set horizontal justification type and cell padding here.
	// Vertical justification is not yet supported. It is not necessary to set the sectionInset property.
	
	self.customJustifiedFlowLayout.horizontalJustification = FlowLayoutHorizontalJustificationRight;
	self.customJustifiedFlowLayout.horizontalCellPadding = 5;
	self.customJustifiedFlowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 0, 20);	
}

-(void)configureCell:(ERCollectionViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
	
	cell.labelText = self.dataSourceArray[indexPath.row % self.dataSourceArray.count];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return 205;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	ERCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ERCollectionViewCell" forIndexPath:indexPath];
	
	[self configureCell:cell forIndexPath:indexPath];
	
	return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
	[self configureCell:self.sizingCell forIndexPath:indexPath];
	
	return [self.sizingCell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

@end