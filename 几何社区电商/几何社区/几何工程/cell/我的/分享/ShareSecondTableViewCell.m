//
//  ShareSecondTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/9/25.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "ShareSecondTableViewCell.h"
@implementation ShareSecondTableViewCell
-(void)layoutSubviews{
    [super layoutSubviews];
    self.QRCodeIv.image = [self generateQRCode:self.url width:SCREEN_WIDTH/3 height:SCREEN_WIDTH/3];
    
//    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:self.url] withSize:100.0f];
//    UIImage *customQrcode = [self imageBlackToTransparent:qrcode withRed:60.0f andGreen:74.0f andBlue:89.0f];
//    self.QRCodeIv.image = customQrcode;
//    self.QRCodeIv.layer.shadowOffset = CGSizeMake(0, 2);
//    self.QRCodeIv.layer.shadowRadius = 2;
//    self.QRCodeIv.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.QRCodeIv.layer.shadowOpacity = 0.5;
}
- (void)awakeFromNib {
    
    // Initialization code
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2);
    UIImageView *yaoyiyao = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, SCREEN_WIDTH/3)];
    yaoyiyao.image = [UIImage imageNamed:@"yiy"];
    yaoyiyao.center = CGPointMake(SCREEN_WIDTH/4, 12+SCREEN_WIDTH/6);
    [self addSubview:yaoyiyao];
    
    UILabel *yaoyiyaoLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2-20, 17)];
    yaoyiyaoLbl.textColor = [UIColor colorWithRed:0.267 green:0.792 blue:0.690 alpha:1.000];
    yaoyiyaoLbl.textAlignment = NSTextAlignmentCenter;
    yaoyiyaoLbl.font = [UIFont systemFontOfSize:17];
    yaoyiyaoLbl.text = @"摇一摇有惊喜";
    yaoyiyaoLbl.center = CGPointMake(yaoyiyao.center.x, self.bounds.size.height-12-8);
    [self addSubview:yaoyiyaoLbl];
    
    
    self.QRCodeIv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, SCREEN_WIDTH/3)] ;
    self.QRCodeIv.center =CGPointMake(SCREEN_WIDTH/4*3, 12+SCREEN_WIDTH/6);
    //self.QRCodeIv.image = [QRCodeGenerator qrImageForString:@"www.baidu.com" imageSize:SCREEN_WIDTH/3];
    [self addSubview:self.QRCodeIv];
     
    UILabel *QRLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2-20, 17)];
    QRLbl.textColor = [UIColor blackColor];
    QRLbl.textAlignment = NSTextAlignmentCenter;
    QRLbl.font = [UIFont systemFontOfSize:17];
    QRLbl.text = @"扫描二维码邀请";
    QRLbl.center = CGPointMake(self.QRCodeIv.center.x, self.bounds.size.height-12-8);
    [self addSubview:QRLbl];
    
    
}
#pragma mark - 生成二维码
- (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    
    // 生成二维码图片
    CIImage *qrcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / qrcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}



//#pragma mark - InterpolatedUIImage
//- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
//    CGRect extent = CGRectIntegral(image.extent);
//    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
//    // create a bitmap image that we'll draw into a bitmap context at the desired size;
//    size_t width = CGRectGetWidth(extent) * scale;
//    size_t height = CGRectGetHeight(extent) * scale;
//    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
//    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
//    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
//    CGContextScaleCTM(bitmapRef, scale, scale);
//    CGContextDrawImage(bitmapRef, extent, bitmapImage);
//    // Create an image with the contents of our bitmap
//    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
//    // Cleanup
//    CGContextRelease(bitmapRef);
//    CGImageRelease(bitmapImage);
//    return [UIImage imageWithCGImage:scaledImage];
//}
//
//#pragma mark - QRCodeGenerator
//- (CIImage *)createQRForString:(NSString *)qrString {
//    // Need to convert the string to a UTF-8 encoded NSData object
//    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
//    // Create the filter
//    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    // Set the message content and error-correction level
//    [qrFilter setValue:stringData forKey:@"inputMessage"];
//    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
//    // Send the image back
//    return qrFilter.outputImage;
//}
//
//#pragma mark - imageToTransparent
//void ProviderReleaseData (void *info, const void *data, size_t size){
//    free((void*)data);
//}
//- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
//    const int imageWidth = image.size.width;
//    const int imageHeight = image.size.height;
//    size_t      bytesPerRow = imageWidth * 4;
//    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
//    // create context
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
//                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
//    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
//    // traverse pixe
//    int pixelNum = imageWidth * imageHeight;
//    uint32_t* pCurPtr = rgbImageBuf;
//    for (int i = 0; i < pixelNum; i++, pCurPtr++){
//        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
//            // change color
//            uint8_t* ptr = (uint8_t*)pCurPtr;
//            ptr[3] = red; //0~255
//            ptr[2] = green;
//            ptr[1] = blue;
//        }else{
//            uint8_t* ptr = (uint8_t*)pCurPtr;
//            ptr[0] = 0;
//        }
//    }
//    // context to image
//    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
//    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
//                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
//                                        NULL, true, kCGRenderingIntentDefault);
//    CGDataProviderRelease(dataProvider);
//    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
//    // release
//    CGImageRelease(imageRef);
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    return resultUIImage;
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
