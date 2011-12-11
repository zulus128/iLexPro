//
//  NewsCell.h
//  iBuh
//
//  Created by вадим on 6/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsCell : UITableViewCell {
    
}

@property (nonatomic, retain) IBOutlet UILabel* time;
@property (nonatomic, retain) IBOutlet UILabel* title;
@property (nonatomic, retain) IBOutlet UILabel* rubric;

@end
