//
//  ResultViewController.m
//  VocabularyStudyForChild_Objective-C
//
//  Created by Mac on 2016. 8. 6..
//  Copyright © 2016년 Hosung, Lee. All rights reserved.
//

#import "ResultViewController.h"
#import "TestPageViewController.h"
#import "ResultCollectionViewCell.h"

@implementation ResultViewController
@synthesize testItemList, titleViewLabel, scoreLabel, evaluationLabel;

- (void) viewDidLoad {
    [super viewDidLoad];
    reuseIdentifier = @"resultCollectionViewCell";
    titleViewLabel.text = @"Test Result";
    testScore = 0;
    evaluationLabel.text = @"";
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return testItemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ResultCollectionViewCell* cell = (ResultCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.numberLabel.text = [@(indexPath.row + 1) stringValue];
    if (testItemList[indexPath.item].collect_answer == testItemList[indexPath.item].user_answer){
        cell.resultImage.image = [UIImage imageNamed: @"right"];
        testScore += 1;
    } else {
        cell.resultImage.image = [UIImage imageNamed: @"wrong"];
    }
    
    if (indexPath.item + 1 == testItemList.count) {
        scoreLabel.text = [NSString stringWithFormat:@"Score: %ld/5", (long)testScore];
        if (testScore == 5) evaluationLabel.text = @"You Are A Genius!";
        else if (testScore == 4) evaluationLabel.text = @"Excellent Work!";
        else if (testScore == 3) evaluationLabel.text = @"Good Job!";
        else if (testScore < 3) evaluationLabel.text = @"Please Try Again!";
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"TestReview"]) {
        TestPageViewController* testPageViewController = (TestPageViewController*)[segue destinationViewController];
        testPageViewController.reviewState = true;
        testPageViewController.testItemList = self.testItemList;
    }
}

@end
