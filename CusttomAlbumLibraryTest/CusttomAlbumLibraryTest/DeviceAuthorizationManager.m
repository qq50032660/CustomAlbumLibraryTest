//
//  DeviceAuthorizationManager.m
//  CusttomAlbumLibraryTest
//
//  Created by fyc on 2018/12/13.
//  Copyright © 2018 fyc. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import "DeviceAuthorizationManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation DeviceAuthorizationManager

+ (void)popupPhotoLibraryInVC:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)vc
{
    if (!vc) {
        //        DebugLog(@"vc 为空");
        return;
    }
    
    void(^popImagePickerVC)(void) = ^() {
        // 键盘未收起时，非main线程crash
        //        dispatch_main_async_safe(^{
        UIImagePickerController *imagePC = [UIImagePickerController new];
        imagePC.delegate = vc;
        //imagePC.allowsEditing = YES;
        //UIImagePickerControllerMediaType 包含着KUTTypeImage 和KUTTypeMovie
        /*
         const CFStringRef  kUTTypeImage ;抽象的图片类型
         const CFStringRef  kUTTypeJPEG ;
         const CFStringRef  kUTTypeJPEG2000 ;
         const CFStringRef  kUTTypeTIFF ;
         const CFStringRef  kUTTypePICT ;
         const CFStringRef  kUTTypeGIF ;
         const CFStringRef  kUTTypePNG ;
         const CFStringRef  kUTTypeQuickTimeImage ;
         const CFStringRef  kUTTypeAppleICNS
         const CFStringRef kUTTypeBMP;
         const CFStringRef  kUTTypeICO;

         这些类型只能通过 Asset中的  获取资源图片的详细资源信息 ios 4-9
         ALAssetRepresentation *representation = [asset defaultRepresentation];
         10以后
         [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeDefault options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
         //            NSLog(@"图片：%@ %@ %ld", result, [NSThread currentThread],(long)asset.mediaType);
         }];
         */
        //KUTTypeMovie 包含
        /*
         const CFStringRef  kUTTypeAudiovisualContent ;抽象的声音视频
         const CFStringRef  kUTTypeMovie ;抽象的媒体格式（声音和视频）
         const CFStringRef  kUTTypeVideo ;只有视频没有声音
         const CFStringRef  kUTTypeAudio ;只有声音没有视频
         const CFStringRef  kUTTypeQuickTimeMovie ;
         const CFStringRef  kUTTypeMPEG ;
         const CFStringRef  kUTTypeMPEG4 ;
         const CFStringRef  kUTTypeMP3 ;
         const CFStringRef  kUTTypeMPEG4Audio ;
         const CFStringRef  kUTTypeAppleProtectedMPEG4Audio;

         */

        imagePC.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        
        imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [vc presentViewController:imagePC animated:YES completion:nil];
        //        });
    };
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //权限判断
        PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
        if (author == PHAuthorizationStatusNotDetermined) {
            //还没决定
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                //发起权限请求
                if (status == PHAuthorizationStatusAuthorized) {
                    //用户授权
                    popImagePickerVC();
                } else {
                    //用户拒绝
                    //暂时什么都不做
                }
            }];
        } else if (author ==PHAuthorizationStatusRestricted || author ==PHAuthorizationStatusDenied) {
            //无权限 引导去开启
            //颖姿：相册权限缺失不需要弹框,所以注释下方代码
            [self showAlertInVC:vc title:nil message:@"请在iphone的“设置-隐私-照片”选项中，允许访问您的相册。"];
        } else {
            //先弹出vc
            popImagePickerVC();
        }
    }
    else
    {
        [self showAlertInVC:vc title:nil message:@"相册不可用"];
    }
}

+ (void)popupCameraInVC:(UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)vc
{
    if (!vc) {
        //        DebugLog(@"vc 为空");
        return;
    }
    
    void(^popCameraVC)(void) = ^() {
        //弹出vc
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = vc;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [vc presentViewController:imagePicker animated:YES completion:nil];
    };
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        //权限判断
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusNotDetermined) {
            //还没决定
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    //用户同意
                    popCameraVC();
                } else {
                    //如果第一次用户拒绝了，回调并不在主线程。（注意，此时的status仍然是用户并未决定）
                    //暂时什么都不做
                }
            }];
        }
        else if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
            [self showAlertInVC:vc title:nil message:@"请在iphone的“设置-隐私-相机”选项中，允许访问您的相机。"];
        } else {
            //权限允许
            popCameraVC();
        }
    } else {
        [self showAlertInVC:vc title:nil message:@"摄像头不可用"];
    }
}

+ (void)showAlertInVC:(UIViewController*)vc title:(NSString*)title message:(NSString*)msg
{
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        return;
    }];
    
    [alertVC addAction:action];
    
    [vc presentViewController:alertVC animated:YES completion:nil];
}

@end
