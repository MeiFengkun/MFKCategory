//
//  UIImage+ImageHandle.h
//  MFKCate
//
//  Created by FengkunMei on 2017/11/20.
//  Copyright © 2017年 mei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageHandle)

/**
 *  返回一张可以随意拉伸不变形的图片
 *
 *  @param imageName 图片名字
 */
+ (instancetype)resizableImageNamed:(NSString *)imageName;

/**
 *  @brief 关闭图片的自动渲染
 *  @param imageName 图片的名字
 *  @return 返回一张默认不渲染的图片(用于添加到navigation上面去)
 */
+ (instancetype)originRenderingImageNamed:(NSString *)imageName;

/**
 * 返回一张圆形图片
 */
+ (instancetype)circleImageNamed:(NSString *)name;

/**
 *  @brief  把当前的image裁剪生成一个圆形的image 并且带有边框
 *  @param name 本地图片的名字
 *  @param edgingWidth 边框的宽度
 *  @param edgingColor 边框的颜色
 *  @return UIImage实例
 */
+ (instancetype)circleImageWithImageNamed:(NSString *)name edgingWidth:(CGFloat)edgingWidth color:(UIColor*)edgingColor;

/**
 *  @brief  生成带有边框的image实例
 *  @param name 本地图片的名字
 *  @param edgingWidth 边框的宽度
 *  @param edgingColor 边框的颜色
 *  @return UIImage实例
 */
+ (instancetype)imageWithEdgingImageNamed:(NSString *)name width:(CGFloat)edgingWidth color:(UIColor*)edgingColor;

/**
 *  @brief  生成带有边框/圆角的image
 *  @param name 本地图片的名字
 *  @param edgingWidth 边框的宽度
 *  @param edgingColor 边框的颜色
 *  @param radiu 圆角半径
 *  @return UIImage实例
 */
+ (instancetype)imageWithEdgingImageNamed:(NSString *)name width:(CGFloat)edgingWidth color:(UIColor*)edgingColor cornerRadius:(CGFloat)radiu;

#pragma mark - 对象方法
/**
 * 返回一张圆形图片
 */
- (instancetype)circleImage;

/**
 *  @brief  把当前的image裁剪生成一个圆形的image 并且带有边框
 *  @param edgingWidth 边框的宽度
 *  @param edgingColor 边框的颜色
 *  @return UIImage实例
 */
- (instancetype)circleImageWithEdgingWidth:(CGFloat)edgingWidth color:(UIColor*)edgingColor;

/**
 *  @brief  生成带有边框的image实例
 *  @param edgingWidth 边框的宽度
 *  @param edgingColor 边框的颜色
 *  @return UIImage实例
 */
- (instancetype)imageWithEdgingWidth:(CGFloat)edgingWidth color:(UIColor*)edgingColor;

/**
 *  @brief  生成带有边框/圆角的image
 *  @param edgingWidth 边框的宽度
 *  @param edgingColor 边框的颜色
 *  @param radiu 圆角半径
 *  @return UIImage实例
 */
- (instancetype)imageWithEdgingWidth:(CGFloat)edgingWidth color:(UIColor*)edgingColor cornerRadius:(CGFloat)radiu;


/************************************************ 图片效果 *********************************************/

// 模糊效果(渲染很耗时间,建议在子线程中渲染)
- (UIImage *)blurImage;
- (UIImage *)blurImageWithMask:(UIImage *)maskImage;
- (UIImage *)blurImageWithRadius:(CGFloat)radius;
- (UIImage *)blurImageAtFrame:(CGRect)frame;

// 灰度效果
- (UIImage *)grayScale;

// 固定宽度与固定高度
- (UIImage *)scaleWithFixedWidth:(CGFloat)width;
- (UIImage *)scaleWithFixedHeight:(CGFloat)height;

// 平均的颜色
- (UIColor *)averageColor;

// 裁剪图片的一部分
- (UIImage *)croppedImageAtFrame:(CGRect)frame;

// 将自身填充到指定的size
- (UIImage *)fillClipSize:(CGSize)size;

@end
