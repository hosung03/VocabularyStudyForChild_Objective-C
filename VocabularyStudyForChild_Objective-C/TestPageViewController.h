//
//  TestPageViewController.h
//  VocabularyStudyForChild_Objective-C
//
//  Created by Mac on 2016. 8. 6..
//  Copyright © 2016년 Hosung, Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionItem.h"

@interface TestPageViewController : UIPageViewController <NSXMLParserDelegate, UIPageViewControllerDataSource> {
    //// for loading indicator
    @private UIView* boxView;

    //// for view state
    @private NSXMLParser* parser;
    @private NSMutableArray<QuestionItem*>* testXMLList;
    @private NSString* testTitle;;
    @private QuestionItem* testXMLItem;
    @private NSString* curElement;
    @private NSString* curElementID;
}
//// for view state
@property (nonatomic) BOOL reviewState;

//// for test pages
@property (nonatomic) NSMutableArray<QuestionItem*>* testItemList;

- (void) settingPageViewController;
- (void) showIndicator;
- (void) removeIndicator;
- (BOOL) parseXMLFile;
- (NSMutableArray*) makeRandomIndexArray:(NSInteger) max;
- (void) callResultViewController;

@end
