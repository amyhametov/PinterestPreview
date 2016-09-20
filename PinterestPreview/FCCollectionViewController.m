//
//  FCCollectionViewController.m
//  PinterestPreview
//
//  Created by user01 on 18.09.16.
//  Copyright © 2016 temrov. All rights reserved.
//

#import "FCCollectionViewController.h"
#import "FCPinterestLayoutAttributes.h"
#import "FCPinterestLayout.h"
#import "FCJSonRequest.h"
#import "FCImage.h"
#import "FCCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>

@interface FCCollectionViewController ()
@property (nonatomic) NSArray *recipeImages;
@end

@implementation FCCollectionViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
static NSString * const reuseIdentifier = @"FCCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Register cell classes
#warning Вот эта строка не нужна, потому что у тебя FCCollectionViewCell есть в сториборде, он уже зарегистрирован для self.collectionView
    
   //[self.collectionView registerClass:[FCCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    
    // Set the PinterestLayout delegate
    
    FCPinterestLayout* layout = (FCPinterestLayout* ) self.collectionViewLayout;
    layout.layoutDelegate = self;

    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(23, 5, 10, 5);
    
    // Do any additional setup after loading the view, typically from a nib.
    FCJSonRequest* req = [[FCJSonRequest alloc] init];
    [req configure];
    //RecipeCollectionViewController* weakSelf = self;
    [req loadItemsAtPath:FEATURED_ITEMS_PATH
               OnSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                   self.recipeImages = mappingResult.array;
                   [self.collectionView reloadData];
               }
               OnFailure:^(RKObjectRequestOperation *operation, NSError *error) {
                   NSLog(@"Error getting pictures");
               }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // the only collection
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.recipeImages count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FCCollectionViewCell *cell = (FCCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    // Configure the cell
#warning Из-за неверной строки во viewDidLoad cell.imageView возвращает nil, так как свойство не инитится по умолчанию. А вот при использовании xib, средства SDK автоматически генерируют свойства, у который есть IBOutlet и проставлена связь на сториборде.
    UIImageView *recipeImageView = cell.imageView;
    recipeImageView = [cell viewWithTag:100];
    FCImage* viewingElement = self.recipeImages[indexPath.row];
    NSURL* url = [[NSURL alloc] initWithString:viewingElement.url];
    
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
    recipeImageView.image = [[UIImage alloc] initWithData:imageData];
    
    return cell;
}

#pragma mark <FCPinterestLayoutDelegete>

- (CGFloat) cellHeightInCollectionView : (UICollectionView*) collectionView
                           AtIndexPath : (NSIndexPath*) indexPath
                              WithWidth: (CGFloat) width
{
#warning Пользоваться методом dequeueReusableCellWithReuseIdentifier где-то, кроме метода collectionView:cellForItemAtIndexPath: не стоит, может действетельно получаться рекурсия.
#warning у тебя есть size в метаинфе ответа от сервера. Попробуй использовать её.
    /*
    FCCollectionViewCell *cell = (FCCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    UIImageView *recipeImageView = cell.imageView;
    if (recipeImageView) {
        if (recipeImageView.image) {
            CGRect boundingRect= CGRectMake(0, 0, width, MAXFLOAT);
            CGRect rect = AVMakeRectWithAspectRatioInsideRect(recipeImageView.image.size, boundingRect);
            return rect.size.height;
        }
    }
    */
    return 100;
}

@end
