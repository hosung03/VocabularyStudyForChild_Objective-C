//
//  ResultViewController.h
//  VocabularyStudyForChild_Objective-C
//
//  Created by Mac on 2016. 8. 6..
//  Copyright © 2016년 Hosung, Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionItem.h"

@interface ResultViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
    @private NSString* reuseIdentifier;
    @private NSInteger testScore;
}
@property (weak, nonatomic) NSMutableArray<QuestionItem*>* testItemList;
@property (weak, nonatomic) IBOutlet UILabel* titleViewLabel;
@property (weak, nonatomic) IBOutlet UILabel* scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel* evaluationLabel;

@end
