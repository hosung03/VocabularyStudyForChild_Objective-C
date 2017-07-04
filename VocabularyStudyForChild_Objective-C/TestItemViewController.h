//
//  TestItemViewController.h
//  VocabularyStudyForChild_Objective-C
//
//  Created by Mac on 2016. 8. 6..
//  Copyright © 2016년 Hosung, Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestPageViewController.h"
//#import "VerticallyCenteredTextView.h"

@interface TestItemViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    @private NSInteger selectedSection;
    @private NSInteger selectedRow;
    @private NSString* testItemIdentifier;
    
    @private NSString* questionText;
    @private NSString* questionImg;
}
@property (nonatomic) TestPageViewController* testPageViewController;
@property (nonatomic) BOOL reviewState;
@property (nonatomic) NSInteger pageIndex;
@property (nonatomic) NSDictionary* answers;
@property (nonatomic) NSString* user_answer;
@property (nonatomic) NSString* collect_answer;

@property (weak, nonatomic) IBOutlet UITextView *itemTextView;
@property (weak, nonatomic) IBOutlet UIImageView* itemImageView;
@property (weak, nonatomic) IBOutlet UILabel* itemTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton* goTestButton;

- (void)setQuestionText:(NSString*)newText;
- (void)setQuestionImg:(NSString*)newImg;

@end
