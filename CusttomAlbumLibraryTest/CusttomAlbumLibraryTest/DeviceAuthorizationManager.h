//
//  DeviceAuthorizationManager.h
//  CusttomAlbumLibraryTest
//
//  Created by fyc on 2018/12/13.
//  Copyright © 2018 fyc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface DeviceAuthorizationManager : NSObject


/**
 弹出相册
 
 @param vc 当前界面
 */
+ (void)popupPhotoLibraryInVC:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)vc;

/**
 弹出相机
 
 @param vc 当前界面
 */
+ (void)popupCameraInVC:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)vc;


@end


