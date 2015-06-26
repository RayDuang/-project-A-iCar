//
//  MovieListViewController.m
//  DouBan
//
//  Created by 怒煮西兰花 on 15/6/16.
//  Copyright (c) 2015年 蓝鸥科技有限公司. All rights reserved.
//

#import "MovieListViewController.h"
#import "RequestHandle.h"
#import "Movie.h"
#import "DouBanURL.h"
#import "MovieTableCell.h"
#import "MovieDetailViewController.h"
@interface MovieListViewController ()<RequestHandleDelegate>
@property(nonatomic,retain)NSMutableArray *movieArr;
@end

@implementation MovieListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieTableCell" bundle:nil] forCellReuseIdentifier:@"movieCell"];

    //请求数据
    [self requestData];
}
//请求数据
- (void)requestData
{
    [[RequestHandle alloc]initWithURL:kMovieListURL method:@"GET" parameter:nil delegate:self];
    
    
}
//请求成功
- (void)requestHandle:(RequestHandle *)request didSucceedWithData:(NSData *)data
{
    //数据解析
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *dataArr = [dataDic valueForKey:@"result"];
    //遍历数据获取movie字典
    for (NSDictionary *movieDic in dataArr) {
        //封装对象
        Movie *movie = [[Movie alloc]init];
        //KVC赋值
        [movie setValuesForKeysWithDictionary:movieDic];
        //将对象放入数组
        if (_movieArr == nil) {
            self.movieArr = [NSMutableArray array];
        }
        [self.movieArr addObject:movie];
        [movie release];
    }
    NSLog(@"%@",self.movieArr);
    //刷新数据
    [self.tableView reloadData];
    
}

//请求失败
- (void)requestHandle:(RequestHandle *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

#pragma mark - DataSouce Delegate
//分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _movieArr.count;
}
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell" forIndexPath:indexPath];
    cell.movie_pic.image = [UIImage imageNamed:@"picholder.png"];
    //获取movie对象
    Movie *movie = [self.movieArr objectAtIndex:indexPath.row];
    //赋值
    cell.movie_name.text = movie.movieName;
    //图片赋值
    if (movie.movie_pic == nil && movie.isLoading == NO) {
        //图片下载
        [movie loadImage];
        //添加观察者
        [movie addObserver:self forKeyPath:@"movie_pic" options:(NSKeyValueObservingOptionNew) context:[indexPath retain]];
    }else
    {
        cell.movie_pic.image = movie.movie_pic;
    }
    
    return cell;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //获取图片
    UIImage *image = [change valueForKey:@"new"];
    //获取cell
    NSIndexPath *indexPath = (NSIndexPath *)context;
    MovieTableCell *cell = (MovieTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    //赋值
    cell.movie_pic.image = image;
    [indexPath release];
}
         
//设置cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
//点击cell触发事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieDetailViewController *detailVC = [[[MovieDetailViewController alloc]init] autorelease];
    [self.navigationController pushViewController:detailVC animated:YES];
    detailVC.view.backgroundColor = [UIColor whiteColor];
    
    //属性传值
    //获取对应的movie对象
    Movie *movie = self.movieArr[indexPath.row];
    detailVC.movie = movie;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
