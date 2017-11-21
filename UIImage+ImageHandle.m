//
//  UIImage+ImageHandle.m
//  MFKCate
//
//  Created by FengkunMei on 2017/11/20.
//  Copyright © 2017年 mei. All rights reserved.
//

#import "UIImage+ImageHandle.h"
#import <float.h>
// 毛玻璃效果的库accelerate.framework
@import Accelerate;

@implementation UIImage (ImageHandle)

/**
 *  返回一张可以随意拉伸不变形的图片
 *
 *  @param imageName 图片名字
 */
+ (instancetype)resizableImageNamed:(NSString *)imageName {
	UIImage *normal = [UIImage imageNamed:imageName];
	CGFloat w = normal.size.width * 0.5;
	CGFloat h = normal.size.height * 0.5;
	return [normal stretchableImageWithLeftCapWidth:w topCapHeight:h];
	// return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}

/**
 *  @brief 关闭图片的自动渲染
 *  @param imageName 图片的名字
 *  @return 返回一张默认不渲染的图片(用于添加到navigation上面去)
 */
+ (instancetype)originRenderingImageNamed:(NSString *)imageName {
	UIImage *image = [UIImage imageNamed:imageName];
	
	return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/**
 *  @brief  根据当前传入的imageNamed加载一张图片并且进行裁剪
 *  @param name 图片名称
 *  @return UIImage实例
 */
+ (instancetype)circleImageNamed:(NSString *)name
{
	return [[self imageNamed:name] circleImage];
}

/**
 *  @brief  把当前的image裁剪生成一个圆形的image 并且带有边框
 *  @param edgingWidth 边框的宽度
 *  @param edgingColor 边框的颜色
 *  @return UIImage实例
 */
+ (instancetype)circleImageWithImageNamed:(NSString *)name edgingWidth:(CGFloat)edgingWidth color:(UIColor*)edgingColor {
	return [[UIImage imageNamed:name] circleImageWithEdgingWidth:edgingWidth color:edgingColor];
}

/**
 *  @brief  生成带有边框的image实例
 *  @param edgingWidth 边框的宽度
 *  @param edgingColor 边框的颜色
 *  @return UIImage实例
 */
+ (instancetype)imageWithEdgingImageNamed:(NSString *)name width:(CGFloat)edgingWidth color:(UIColor*)edgingColor {
	return [[UIImage imageNamed:name] imageWithEdgingWidth:edgingWidth color:edgingColor];
}

/**
 *  @brief  生成带有边框/圆角的image
 *  @param edgingWidth 边框的宽度
 *  @param edgingColor 边框的颜色
 *  @param radiu 圆角半径
 *  @return UIImage实例
 */
+ (instancetype)imageWithEdgingImageNamed:(NSString *)name width:(CGFloat)edgingWidth color:(UIColor*)edgingColor cornerRadius:(CGFloat)radiu {
	return [[UIImage imageNamed:name] imageWithEdgingWidth:edgingWidth color:edgingColor cornerRadius:radiu];
}

#pragma mark - 对象方法

/**
 *  @brief  把当前的image裁剪生成一个圆形的image
 *  @return UIImage实例
 */
- (instancetype)circleImage
{
	return [self circleImageWithEdgingWidth:0 color:[UIColor clearColor]];
}

/**
 *  @brief  把当前的image裁剪生成一个圆形的image 并且带有边框
 *  @return UIImage实例
 */
- (instancetype)circleImageWithEdgingWidth:(CGFloat)edgingWidth color:(UIColor*)edgingColor {
	CGFloat radiu = edgingWidth + self.size.width/2.0;
	return [self imageWithEdgingWidth:edgingWidth color:edgingColor cornerRadius:radiu];
}

/**
 *  @brief  生成带有边框的image实例
 *  @return UIImage实例
 */
- (instancetype)imageWithEdgingWidth:(CGFloat)edgingWidth color:(UIColor*)edgingColor {
	return [self imageWithEdgingWidth:edgingWidth color:edgingColor cornerRadius:0];
}

/**
 *  @brief  生成带有边框/圆角的image
 *  @return UIImage实例
 */
- (instancetype)imageWithEdgingWidth:(CGFloat)edgingWidth color:(UIColor*)edgingColor cornerRadius:(CGFloat)radiu {
	CGSize drawSize = CGSizeMake(self.size.width+2*edgingWidth, self.size.height+2*edgingWidth);
	// 开启图形上下文
	UIGraphicsBeginImageContext(drawSize);
	// 获得上下文
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	// 矩形框
	CGRect rect = CGRectMake(edgingWidth, edgingWidth, self.size.width, self.size.height);
	
	UIBezierPath *path;
	if (radiu == 0) {
		path = [UIBezierPath bezierPathWithRect:rect];
	}else {
		path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radiu];
	}
	// 绘制边框圆角矩形
	CGContextAddPath(ctx, path.CGPath);
	CGContextSetLineWidth(ctx, edgingWidth);
	[edgingColor setStroke];
	CGContextStrokePath(ctx);
	
	// 绘制裁剪圆角矩形
	CGContextAddPath(ctx, path.CGPath);
	// 裁剪(裁剪成刚才添加的图形形状)
	CGContextClip(ctx);
	// 往圆上面画一张图片
	[self drawInRect:rect];
	// 获得上下文中的图片
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	// 关闭图形上下文
	UIGraphicsEndImageContext();
	
	return image;
}

/************************************************ 图片效果 *********************************************/


- (UIImage *)applyLightEffect
{
	UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
	return [self applyBlurWithRadius:30 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyExtraLightEffect
{
	UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
	return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyDarkEffect
{
	UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
	return [self applyBlurWithRadius:20 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
}


- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor
{
	const CGFloat EffectColorAlpha = 0.6;
	UIColor *effectColor = tintColor;
	int componentCount = (int)CGColorGetNumberOfComponents(tintColor.CGColor);
	if (componentCount == 2) {
		CGFloat b;
		if ([tintColor getWhite:&b alpha:NULL]) {
			effectColor = [UIColor colorWithWhite:b alpha:EffectColorAlpha];
		}
	}
	else {
		CGFloat r, g, b;
		if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
			effectColor = [UIColor colorWithRed:r green:g blue:b alpha:EffectColorAlpha];
		}
	}
	return [self applyBlurWithRadius:20
						   tintColor:effectColor
			   saturationDeltaFactor:1.4
						   maskImage:nil];
}

- (UIImage *)blurImage
{
	return [self applyBlurWithRadius:20
						   tintColor:[UIColor colorWithWhite:0 alpha:0.0]
			   saturationDeltaFactor:1.4
						   maskImage:nil];
}

- (UIImage *)blurImageWithRadius:(CGFloat)radius
{
	return [self applyBlurWithRadius:radius
						   tintColor:[UIColor colorWithWhite:0 alpha:0.0]
			   saturationDeltaFactor:1.4
						   maskImage:nil];
}


- (UIImage *)blurImageWithMask:(UIImage *)maskImage
{
	return [self applyBlurWithRadius:20
						   tintColor:[UIColor colorWithWhite:0 alpha:0.0]
			   saturationDeltaFactor:1.4
						   maskImage:maskImage];
}

- (UIImage *)blurImageAtFrame:(CGRect)frame
{
	return [self applyBlurWithRadius:20
						   tintColor:[UIColor colorWithWhite:0 alpha:0.0]
			   saturationDeltaFactor:1.4
						   maskImage:nil
							 atFrame:frame];
}

// 核心代码
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
	// Check pre-conditions.
	if (self.size.width < 1 || self.size.height < 1) {
		NSLog (@"*** error: invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
		return nil;
	}
	if (!self.CGImage) {
		NSLog (@"*** error: image must be backed by a CGImage: %@", self);
		return nil;
	}
	if (maskImage && !maskImage.CGImage) {
		NSLog (@"*** error: maskImage must be backed by a CGImage: %@", maskImage);
		return nil;
	}
	
	CGRect imageRect = { CGPointZero, self.size };
	UIImage *effectImage = self;
	
	BOOL hasBlur = blurRadius > __FLT_EPSILON__;
	BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
	if (hasBlur || hasSaturationChange) {
		UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
		CGContextRef effectInContext = UIGraphicsGetCurrentContext();
		CGContextScaleCTM(effectInContext, 1.0, -1.0);
		CGContextTranslateCTM(effectInContext, 0, -self.size.height);
		CGContextDrawImage(effectInContext, imageRect, self.CGImage);
		
		vImage_Buffer effectInBuffer;
		effectInBuffer.data     = CGBitmapContextGetData(effectInContext);
		effectInBuffer.width    = CGBitmapContextGetWidth(effectInContext);
		effectInBuffer.height   = CGBitmapContextGetHeight(effectInContext);
		effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
		
		UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
		CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
		vImage_Buffer effectOutBuffer;
		effectOutBuffer.data     = CGBitmapContextGetData(effectOutContext);
		effectOutBuffer.width    = CGBitmapContextGetWidth(effectOutContext);
		effectOutBuffer.height   = CGBitmapContextGetHeight(effectOutContext);
		effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
		
		if (hasBlur) {
			// A description of how to compute the box kernel width from the Gaussian
			// radius (aka standard deviation) appears in the SVG spec:
			// http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
			//
			// For larger values of 's' (s >= 2.0), an approximation can be used: Three
			// successive box-blurs build a piece-wise quadratic convolution kernel, which
			// approximates the Gaussian kernel to within roughly 3%.
			//
			// let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
			//
			// ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
			//
			CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
			NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
			if (radius % 2 != 1) {
				radius += 1; // force radius to be odd so that the three box-blur methodology works.
			}
			vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
			vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
			vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t)radius, (uint32_t)radius, 0, kvImageEdgeExtend);
		}
		BOOL effectImageBuffersAreSwapped = NO;
		if (hasSaturationChange) {
			CGFloat s = saturationDeltaFactor;
			CGFloat floatingPointSaturationMatrix[] = {
				0.0722 + 0.9278 * s,  0.0722 - 0.0722 * s,  0.0722 - 0.0722 * s,  0,
				0.7152 - 0.7152 * s,  0.7152 + 0.2848 * s,  0.7152 - 0.7152 * s,  0,
				0.2126 - 0.2126 * s,  0.2126 - 0.2126 * s,  0.2126 + 0.7873 * s,  0,
				0,                    0,                    0,  1,
			};
			const int32_t divisor = 256;
			NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
			int16_t saturationMatrix[matrixSize];
			for (NSUInteger i = 0; i < matrixSize; ++i) {
				saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
			}
			if (hasBlur) {
				vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
				effectImageBuffersAreSwapped = YES;
			}
			else {
				vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
			}
		}
		if (!effectImageBuffersAreSwapped)
			effectImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		if (effectImageBuffersAreSwapped)
			effectImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	
	// Set up output context.
	UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
	CGContextRef outputContext = UIGraphicsGetCurrentContext();
	CGContextScaleCTM(outputContext, 1.0, -1.0);
	CGContextTranslateCTM(outputContext, 0, -self.size.height);
	
	// Draw base image.
	CGContextDrawImage(outputContext, imageRect, self.CGImage);
	
	// Draw effect image.
	if (hasBlur) {
		CGContextSaveGState(outputContext);
		if (maskImage) {
			CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
		}
		CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
		CGContextRestoreGState(outputContext);
	}
	
	// Add in color tint.
	if (tintColor) {
		CGContextSaveGState(outputContext);
		CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
		CGContextFillRect(outputContext, imageRect);
		CGContextRestoreGState(outputContext);
	}
	
	// Output image is ready.
	UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return outputImage;
}

- (UIImage *)grayScale
{
	int width = self.size.width;
	int height = self.size.height;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	
	CGContextRef context = CGBitmapContextCreate(nil,
												 width,
												 height,
												 8, // bits per component
												 0,
												 colorSpace,
												 kCGBitmapByteOrderDefault);
	
	CGColorSpaceRelease(colorSpace);
	
	if (context == NULL) {
		return nil;
	}
	
	CGContextDrawImage(context,
					   CGRectMake(0, 0, width, height), self.CGImage);
	CGImageRef image = CGBitmapContextCreateImage(context);
	UIImage *grayImage = [UIImage imageWithCGImage:image];
	CFRelease(image);
	CGContextRelease(context);
	
	return grayImage;
}

- (UIImage *)scaleWithFixedWidth:(CGFloat)width
{
	float newHeight = self.size.height * (width / self.size.width);
	CGSize size = CGSizeMake(width, newHeight);
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGContextSetBlendMode(context, kCGBlendModeCopy);
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
	
	UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return imageOut;
}

- (UIImage *)scaleWithFixedHeight:(CGFloat)height
{
	float newWidth = self.size.width * (height / self.size.height);
	CGSize size = CGSizeMake(newWidth, height);
	
	UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextTranslateCTM(context, 0.0, size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CGContextSetBlendMode(context, kCGBlendModeCopy);
	CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
	
	UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return imageOut;
}

- (UIColor *)averageColor
{
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	unsigned char rgba[4];
	CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	
	CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
	CGColorSpaceRelease(colorSpace);
	CGContextRelease(context);
	
	if(rgba[3] > 0) {
		CGFloat alpha = ((CGFloat)rgba[3])/255.0;
		CGFloat multiplier = alpha/255.0;
		return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
							   green:((CGFloat)rgba[1])*multiplier
								blue:((CGFloat)rgba[2])*multiplier
							   alpha:alpha];
	}
	else {
		return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
							   green:((CGFloat)rgba[1])/255.0
								blue:((CGFloat)rgba[2])/255.0
							   alpha:((CGFloat)rgba[3])/255.0];
	}
}

- (UIImage *)croppedImageAtFrame:(CGRect)frame
{
	frame = CGRectMake(frame.origin.x * self.scale, frame.origin.y * self.scale, frame.size.width * self.scale, frame.size.height * self.scale);
	CGImageRef sourceImageRef = [self CGImage];
	CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, frame);
	UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[self scale] orientation:[self imageOrientation]];
	CGImageRelease(newImageRef);
	return newImage;
}

- (UIImage *)addImageToImage:(UIImage *)img atRect:(CGRect)cropRect{
	
	CGSize size = CGSizeMake(self.size.width, self.size.height);
	UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
	
	CGPoint pointImg1 = CGPointMake(0,0);
	[self drawAtPoint:pointImg1];
	
	CGPoint pointImg2 = cropRect.origin;
	[img drawAtPoint: pointImg2];
	
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return result;
}

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius
					   tintColor:(UIColor *)tintColor
		   saturationDeltaFactor:(CGFloat)saturationDeltaFactor
					   maskImage:(UIImage *)maskImage
						 atFrame:(CGRect)frame
{
	UIImage *blurredFrame = \
	[[self croppedImageAtFrame:frame] applyBlurWithRadius:blurRadius
												tintColor:tintColor
									saturationDeltaFactor:saturationDeltaFactor
												maskImage:maskImage];
	
	return [self addImageToImage:blurredFrame atRect:frame];
}

- (UIImage *)fillClipSize:(CGSize)size
{
	UIGraphicsBeginImageContext(size);
	CGContextRef imageContext = UIGraphicsGetCurrentContext();
	CGContextDrawTiledImage(imageContext, (CGRect){CGPointZero, self.size}, [self CGImage]);
	UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return outputImage;
}

@end