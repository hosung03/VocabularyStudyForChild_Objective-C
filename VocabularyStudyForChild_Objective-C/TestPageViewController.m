//
//  TestPageViewController.m
//  VocabularyStudyForChild_Objective-C
//
//  Created by Mac on 2016. 8. 6..
//  Copyright © 2016년 Hosung, Lee. All rights reserved.
//

#import "TestPageViewController.h"
#import "TestItemViewController.h"
#import "ResultViewController.h"

@implementation TestPageViewController
@synthesize reviewState, testItemList;

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        self.reviewState = false;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showIndicator];
    
    // for Test Review
    if (self.reviewState) {
        [self settingPageViewController];
        [self removeIndicator];
         return;
    }
    
    // for noraml Test
    if([self parseXMLFile]) {
        if(testXMLList.count == 0) return;
        if (testItemList != nil) testItemList = nil;
        testItemList = [[NSMutableArray alloc] init];
        NSMutableArray* selectedIndexArray = [self makeRandomIndexArray:(NSInteger)testXMLList.count];
        for (NSNumber* index in selectedIndexArray) {
            [testItemList addObject:[testXMLList objectAtIndex:[index intValue]]];
        }
        [self settingPageViewController];
        [self removeIndicator];
    }
    else {
        [self removeIndicator];
    }
}

- (void) settingPageViewController {
    // set pageviewcollor
    self.dataSource = self;    
    NSArray<TestItemViewController*>* arr= [[NSArray alloc] initWithObjects:[self getViewControllerAtIndex:(NSInteger)0], nil];
    [self setViewControllers:arr direction:UIPageViewControllerNavigationDirectionForward animated:true completion:nil];
    
    // set page controller
    UIPageControl* appearance = [UIPageControl appearance];
    appearance.pageIndicatorTintColor = [UIColor grayColor];
    appearance.currentPageIndicatorTintColor = [UIColor whiteColor];
    appearance.backgroundColor = [UIColor darkGrayColor];
}

- (void) showIndicator {
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat midX = CGRectGetMidX(self.view.frame);
    CGFloat midY = CGRectGetMidY(self.view.frame);
    boxView = [[UIView alloc] initWithFrame:CGRectMake(midX - 90, midY - 25, 180, 50)];
    boxView.backgroundColor = [UIColor whiteColor];
    boxView.alpha = 0.8;
    boxView.layer.cornerRadius = 10;
    
    UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake(0, 0, 50, 50);
    [activityView startAnimating];
    
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 50)];
    textLabel.textColor = [UIColor grayColor];
    textLabel.text = @"Loading XML";
    
    [boxView addSubview:activityView];
    [boxView addSubview:textLabel];
    [self.view addSubview:boxView];
}

- (void) removeIndicator {
    [boxView removeFromSuperview];
    self.view.backgroundColor = [UIColor whiteColor];
}

 // for load & parsing XML
- (BOOL) parseXMLFile {
    // load mxl url
    //NSString* urlpath = @"http://";
    //NSURL* url = [[NSURL alloc] initWithString:urlpath];
    
    // load xml file
    NSString* urlpath = [[NSBundle mainBundle] pathForResource:@"workbook" ofType:@"xml"];
    if (urlpath == nil) {
        NSLog(@"Failed to find workbook.xml");
        return false;
    }
    NSURL* url = [[NSURL alloc] initFileURLWithPath:urlpath];
    
    // parsing
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    parser.delegate = self;
    
    // Invoke the parser and check the result
    return [parser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    if (testXMLList == nil) testXMLList = [[NSMutableArray alloc] init];
    else [testXMLList removeAllObjects];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    curElement = elementName;
    if ([curElement isEqualToString:@"workbook"]) {
        testTitle = [attributeDict objectForKey:@"subject"];
    }
    else if ([curElement isEqualToString:@"item"]) {
        if (testXMLItem != nil) testXMLItem = nil;
        testXMLItem = [[QuestionItem alloc] init];
        testXMLItem.question_type = [attributeDict objectForKey:@"type"];
        testXMLItem.user_answer = @"";
        [testXMLList addObject:testXMLItem];
    }
    else if ([curElement isEqualToString:@"answer"]) {
        curElementID = [attributeDict objectForKey:@"id"];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (testXMLItem == nil) return;
    
    if ([curElement isEqualToString:@"question"]) testXMLItem.question = string;
    else if ([curElement isEqualToString:@"question_img"]) testXMLItem.question_img = string;
    else if ([curElement isEqualToString:@"answer"]){
        if (testXMLItem.answers == nil) testXMLItem.answers = [[NSMutableDictionary alloc]init];
        [testXMLItem.answers setObject:string forKey:curElementID];
    }
    else if ([curElement isEqualToString:@"collect_answer"]) testXMLItem.collect_answer = string;
        
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    curElement = @"";
    curElementID = @"";
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    curElement = @"";
    curElementID = @"";
    NSLog(@"failure error: %@", parseError);
}

//// for selecting questions randomly
- (NSMutableArray*) makeRandomIndexArray:(NSInteger) max{
    NSMutableArray* indexArray = [[NSMutableArray alloc] init];
    while (indexArray.count < 5) {
        NSNumber* value = [NSNumber numberWithInteger:arc4random_uniform((int)max)];
        if(![indexArray containsObject:value]){
            [indexArray addObject:value];
        }
    }
    return indexArray;
}

//// for page view controll
- (TestItemViewController*) getViewControllerAtIndex:(NSInteger) index {
    TestItemViewController* testItemViewController = (TestItemViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"TestItemViewController"];
    testItemViewController.testPageViewController = self;
    testItemViewController.pageIndex = index;
    testItemViewController.reviewState = reviewState;
    [testItemViewController setQuestionText:testItemList[index].question];
    [testItemViewController setQuestionImg:testItemList[index].question_img];
    testItemViewController.answers = testItemList[index].answers;
    testItemViewController.collect_answer = testItemList[index].collect_answer;
    if (reviewState) {
        testItemViewController.user_answer = testItemList[index].user_answer;
    }
    return testItemViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    TestItemViewController* testItemController = (TestItemViewController*)viewController;
    NSInteger index = testItemController.pageIndex;
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index -= 1;
    return [self getViewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    TestItemViewController* testItemController = (TestItemViewController*)viewController;
    NSInteger index = testItemController.pageIndex;
    
    if (index == NSNotFound) return nil;
    index += 1;
    if (index == testItemList.count) return nil;
    return [self getViewControllerAtIndex:index];
}

//// for page controller
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return testItemList.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

- (void) callResultViewController {
    ResultViewController* resultViewController = (ResultViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ResultViewController"];
    if(resultViewController == nil) return;
    resultViewController.testItemList = testItemList;
    [self presentViewController:resultViewController animated:true completion:nil];
}

@end
