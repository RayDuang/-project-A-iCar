//
//  MovieDetailViewController.h
//  DouBan
//
//  Created by 怒煮西兰花 on 15/6/16.
//  Copyright (c) 2015年 蓝鸥科技有限公司. All rights reserved.
//

#import "MyDetailViewController.h"
#import "Movie.h"
@interface MovieDetailViewController : MyDetailViewController
@property (retain, nonatomic) IBOutlet UILabel *rateScore;
@property (retain, nonatomic) IBOutlet UILabel *rateCountLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *runtimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *genresLabel;
@property (retain, nonatomic) IBOutlet UILabel *countryLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet UIImageView *moviePic;
@property (retain, nonatomic) IBOutlet UILabel *actorsLabel;

@property(nonatomic,retain)Movie *movie;
@end
