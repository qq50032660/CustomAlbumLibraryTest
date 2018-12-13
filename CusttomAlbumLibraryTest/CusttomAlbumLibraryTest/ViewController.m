//
//  ViewController.m
//  CusttomAlbumLibraryTest
//
//  Created by fyc on 2018/12/13.
//  Copyright © 2018 fyc. All rights reserved.
//

#import "ViewController.h"
#import "DeviceAuthorizationManager.h"
#import "OldAlbumLibraryViewController.h"
#import "NewAlbumLibraryViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)presentAlbum:(id)sender {
    [DeviceAuthorizationManager popupPhotoLibraryInVC:self];
}
- (IBAction)getOldAlbumAllPic:(id)sender {
    OldAlbumLibraryViewController *oldVC = [OldAlbumLibraryViewController new];
    [self.navigationController pushViewController:oldVC animated:YES];
}
- (IBAction)getNewAlbumAllPic:(id)sender {
    NewAlbumLibraryViewController *newVC = [NewAlbumLibraryViewController new];
    [self.navigationController pushViewController:newVC animated:YES];
}

@end
