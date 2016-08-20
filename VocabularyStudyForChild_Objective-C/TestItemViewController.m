//
//  TestItemViewController.m
//  VocabularyStudyForChild_Objective-C
//
//  Created by Mac on 2016. 8. 6..
//  Copyright © 2016년 Hosung, Lee. All rights reserved.
//

#import "TestItemViewController.h"

@implementation TestItemViewController
@synthesize goTestButton, itemTitleLabel, itemImageView, itemTextView;


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        selectedSection = -1;
        selectedRow = -1;
    }
    return self;
}

- (void)setQuestionText:(NSString*)newText{
    if (questionText != newText) {
        itemTextView.text = newText;
        questionText = newText;
    }
}

- (void)setQuestionImg:(NSString*)newImg{
    if (questionImg != newImg) {
        NSString* urlpath = [[NSBundle mainBundle] pathForResource:newImg ofType:@"png"];
        if (urlpath == nil) return;
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:urlpath]];
        itemImageView.image = [[UIImage alloc] initWithData:imageData];
        questionImg = newImg;
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    itemTitleLabel.text = [NSString stringWithFormat: @"Question %ld", self.pageIndex + 1];
    itemTextView.text = questionText;
    if (self.reviewState)  goTestButton.hidden = false;
    else goTestButton.hidden = true;
    
    NSString* urlpath = [[NSBundle mainBundle] pathForResource:questionImg ofType:@"png"];
    if (urlpath == nil) return;
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:urlpath]];
    itemImageView.image = [[UIImage alloc] initWithData:imageData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.answers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:testItemIdentifier];
    if (cell == nil) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:testItemIdentifier];
    }
    
    NSString* key = [@(indexPath.row + 1) stringValue];
    cell.textLabel.text = [self.answers objectForKey:key];
    
    if (self.reviewState && key == self.user_answer)
        cell.imageView.image = [UIImage imageNamed:@"ic_check_box"];
    else if (selectedSection == indexPath.section && selectedRow == indexPath.row)
        cell.imageView.image = [UIImage imageNamed:@"ic_check_box"];
    else
        cell.imageView.image = [UIImage imageNamed:@"ic_uncheck_box"];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedSection = indexPath.section;
    selectedRow = indexPath.row;
    
    for (int i=0; i<tableView.numberOfSections; i++){
        for(int j=0; j<[tableView numberOfRowsInSection:i];j++){
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
            if (cell != nil) {
                if (selectedSection == i && selectedRow == j)
                    cell.imageView.image = [UIImage imageNamed:@"ic_check_box"];
                else
                    cell.imageView.image = [UIImage imageNamed:@"ic_uncheck_box"];
            }
        }
    }
    self.testPageViewController.testItemList[self.pageIndex].user_answer = [@(indexPath.row + 1) stringValue];
    
    if (self.pageIndex + 1 == self.testPageViewController.testItemList.count) {
        UIAlertController* controller = [UIAlertController alertControllerWithTitle: @"Answer" message:@"You want to get a result!" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
            [self.testPageViewController callResultViewController];
        }];
        UIAlertAction* noAction = [UIAlertAction actionWithTitle: @"No" style:UIAlertActionStyleCancel handler:nil];
        
        [controller addAction:yesAction];
        [controller addAction:noAction];
        [self presentViewController:controller animated:true completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"GoTest"]) {
        self.testPageViewController = (TestPageViewController*) segue.destinationViewController;
        self.testPageViewController.reviewState = false;
    }
}

@end
