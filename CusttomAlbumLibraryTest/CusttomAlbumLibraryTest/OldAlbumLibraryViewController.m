//
//  OldAlbumLibraryViewController.m
//  CusttomAlbumLibraryTest
//
//  Created by fyc on 2018/12/13.
//  Copyright © 2018 fyc. All rights reserved.
//

#import "OldAlbumLibraryViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIImage+GIF.h"
#import "NSData+ImageContentType.h"

@interface OldAlbumLibraryViewController ()

@property (nonatomic, strong)NSMutableArray *photosModelArray;
@property (nonatomic, strong)NSMutableArray *albumandPhotosDict;

@end

@implementation OldAlbumLibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)getAllPic{

    /**
    // 获取图片data
     ALAssetRepresentation *re = [self representationForUTI:(__bridge NSString *)kUTTypeGIF];;
     long long size = re.size;
     uint8_t *buffer = malloc(size);
     NSError *error;
     NSUInteger bytes = [re getBytes:buffer fromOffset:0 length:size error:&error];
     NSData *data = [NSData dataWithBytes:buffer length:bytes];
     free(buffer);
    //the content type as string (i.e. image/jpeg, image/gif)
    NSString *imageTypeString = [NSData sd_contentTypeForImageData:data];
     */
    
    self.photosModelArray = [[NSMutableArray alloc]init];
    self.albumandPhotosDict = [[NSMutableDictionary alloc]init];
    
    NSMutableArray *assetURLDictionaries = [[NSMutableArray alloc] init];
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        //group 相册分组
        if (group) {
            NSMutableArray *tempArray = [[NSMutableArray alloc]init];
            // if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == 16) {
            //16 表示系统默认相册
            /*
             //查看相册的名字
             NSLog(@"ALAssetsGroupPropertyName:%@",[group valueForProperty:ALAssetsGroupPropertyName]);
             //查看相册的类型
             NSLog(@"ALAssetsGroupPropertyType:%@",[group valueForProperty:ALAssetsGroupPropertyType]);
             */
            
            //从相册中获取照片
            [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop){
                
                //
                
                if (asset) {
                    if([[asset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                        [assetURLDictionaries addObject:[asset valueForProperty:ALAssetPropertyURLs]];
                        //NSURL *url= (NSURL*) [[asset defaultRepresentation]url];
                        //NSLog(@"%@,%@",[asset valueForProperty:ALAssetPropertyDate],url);
                        
                        
                        if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == 16){
                            [self.photosModelArray addObject:asset];
                        }
                        
                        [tempArray addObject:asset];
                    }
                    //获取资源图片的详细资源信息
                    ALAssetRepresentation *representation = [asset defaultRepresentation];
                    
                    //获取资源图片的长宽
                    CGSize dimension = [representation dimensions];
                    //获取资源图片的高清图
                    [representation fullResolutionImage];
                    //获取资源图片的全屏图
                    [representation fullScreenImage];
                    //获取资源图片的名字
                    [representation filename];
                    //缩放倍数
                    [representation scale];
                    //图片资源容量大小
                    [representation size];
                    //图片资源原数据
                    [representation metadata];
                    //旋转方向
                    [representation orientation];
                    //资源图片url地址，该地址和ALAsset通过ALAssetPropertyAssetURL获取的url地址是一样的
                    NSURL* url = [representation url];
                    //资源图片uti，唯一标示符
                    [representation UTI];
                    
                    NSLog(@"assets==== %@===uti====%@",[representation filename],[representation UTI]);
                    
                }
                
            }];
            
        }
        
        
    } failureBlock:^(NSError *error) {
        NSLog(@"获取照片失败");
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

@end
