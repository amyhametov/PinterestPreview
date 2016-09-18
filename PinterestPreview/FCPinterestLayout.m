//
//  FCPinterestLayout.m
//  PinterestPreview
//
//  Created by user01 on 18.09.16.
//  Copyright © 2016 temrov. All rights reserved.
//

#import "FCPinterestLayout.h"
#import "FCCollectionViewCell.h"
#import "FCPinterestLayoutAttributes.h"

@interface FCPinterestLayout()


@end


@implementation FCPinterestLayout

- (CGFloat)getContentWigth
{
    UIEdgeInsets insets = [self.collectionView contentInset];
    return CGRectGetWidth([self.collectionView bounds]) - (insets.left + insets.right);
}

- (void)prepareLayout
{
    if (self.cashe.count == 0) {
        //Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
        CGFloat columnWidth = [self getContentWigth] / self.numberOfColumns;
        CGFloat xOffset[self.numberOfColumns];
        NSInteger column;
        for( column = 0; column < self.numberOfColumns; column++ )
        {
            xOffset[column] = column * columnWidth;
        }
        CGFloat yOffset[self.numberOfColumns];
        column = 0;
        
        for(UICollectionViewCell* cell in self.collectionView)
        {
            NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
            // Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
           
            CGFloat width = columnWidth - self.cellPadding;
           
            CGFloat photoHeight = [self.layoutDelegate cellHeightInCollectionView:self.collectionView AtIndexPath:indexPath WithWidth:width];
           
            CGFloat height = self.cellPadding + photoHeight + self.cellPadding;
           
            CGRect frame = CGRectMake(xOffset[column], yOffset[column],width, height);
            CGRect insetFrame = CGRectInset(frame, self.cellPadding, self.cellPadding);
            
            // Creates an UICollectionViewLayoutItem with the frame and add it to the cache
            
            FCPinterestLayoutAttributes* attributes = [[FCPinterestLayoutAttributes alloc] init];
            attributes.indexPath = indexPath;
            attributes.itemHeight = photoHeight;
            attributes.frame = insetFrame;
            [self.cashe addObject:attributes];
            
            //  Updates the collection view content height
            self.contentHeight = MAX(self.contentHeight, CGRectGetMaxY(frame));
            
            yOffset[column] = yOffset[column] + height;
            
            column = column >= (self.numberOfColumns - 1) ? 0 : ++column;
        }
    }
}

- (CGSize) collectionViewContentSize
{
    return CGSizeMake([self getContentWigth], self.contentHeight);
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* attributeList = [[NSMutableArray alloc] init];
    for (FCPinterestLayoutAttributes* attributes in self.cashe) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [attributeList addObject:attributes];
        }
    }
    return attributeList;
}


@end
