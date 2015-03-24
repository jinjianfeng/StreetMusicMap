//
//    Copyright (c) 2013 Shyam Bhat
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of
//    this software and associated documentation files (the "Software"), to deal in
//    the Software without restriction, including without limitation the rights to
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "InstagramMedia.h"
#import "InstagramUser.h"
#import "InstagramComment.h"


@interface InstagramMedia ()
{
    NSMutableArray *mLikes;
    NSMutableArray *mComments;
}
@end

@implementation InstagramMedia
@synthesize likes = mLikes;
@synthesize comments = mComments;

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super initWithInfo:info];
    if (self && IKNotNull(info)) {
        
        _user = [[InstagramUser alloc] initWithInfo:info[kUser]];
        _userHasLiked = [info[kUserHasLiked] boolValue];
        _createdDate = [[NSDate alloc] initWithTimeIntervalSince1970:[info[kCreatedDate] doubleValue]];
       // _locationName = [[NSString alloc] initWithString:info[kLocationName]];
        _link = [[NSString alloc] initWithString:info[kLink]];
        _caption = [[InstagramComment alloc] initWithInfo:info[kCaption]];
        _likesCount = [(info[kLikes])[kCount] integerValue];
        mLikes = [[NSMutableArray alloc] init];
        for (NSDictionary *userInfo in (info[kLikes])[kData]) {
            InstagramUser *user = [[InstagramUser alloc] initWithInfo:userInfo];
            [mLikes addObject:user];
        }
        
        _commentCount = [(info[kComments])[kCount] integerValue];
        mComments = [[NSMutableArray alloc] init];
        for (NSDictionary *commentInfo in (info[kComments])[kData]) {
            InstagramComment *comment = [[InstagramComment alloc] initWithInfo:commentInfo];
            [mComments addObject:comment];
        }
        _tags = [[NSArray alloc] initWithArray:info[kTags]];
        
        if (IKNotNull(info[kLocation])) {
            _location = CLLocationCoordinate2DMake([(info[kLocation])[kLatitude] doubleValue], [(info[kLocation])[kLongitude] doubleValue]);
            
          
                
                
               NSString *haystack = _caption.text;
                
               NSRange range1 = [haystack.lowercaseString rangeOfString:@" at "];
               NSRange range2 = [haystack.lowercaseString rangeOfString:@". filmed"];
                
                NSString * temp = [haystack substringWithRange:NSMakeRange(range1.location + 4, range2.location - range1.location - 4)];
                
                if ([temp.lowercaseString rangeOfString:@"the "].location == 0) {
                    
                    temp = [temp substringWithRange:NSMakeRange(4, temp.length -4)];
                }

                _locationName = [self sentenceCapitalizedString:temp];
            
            
            if (!_locationName) {
                
                if ((info[kLocation])[kLocationName]) {
                    _locationName = (info[kLocation])[kLocationName];
                }
                
            }
        
            
           
        }
        
        _filter = info[kFilter];
        
        [self initializeImages:info[kImages]];
        
        NSString* mediaType = info[kType];
        _isVideo = [mediaType isEqualToString:[NSString stringWithFormat:@"%@",kMediaTypeVideo]];
        if (_isVideo) {
            [self initializeVideos:info[kVideos]];
        }
    }
    return self;
}

- (NSString *)sentenceCapitalizedString:(NSString*)value {
    if (![value length]) {
        return [NSString string];
    }
    NSString *uppercase = [[value substringToIndex:1] uppercaseString];
    NSString *lowercase = [value substringFromIndex:1];
    return [uppercase stringByAppendingString:lowercase];
}

- (void)initializeImages:(NSDictionary *)imagesInfo
{
    NSDictionary *thumbInfo = imagesInfo[kThumbnail];
    _thumbnailURL = [[NSURL alloc] initWithString:thumbInfo[kURL]];
    _thumbnailFrameSize = CGSizeMake([thumbInfo[kWidth] floatValue], [thumbInfo[kHeight] floatValue]);
    
    NSDictionary *lowResInfo = imagesInfo[kLowResolution];
    _lowResolutionImageURL = [[NSURL alloc] initWithString:lowResInfo[kURL]];
    _lowResolutionImageFrameSize = CGSizeMake([lowResInfo[kWidth] floatValue], [lowResInfo[kHeight] floatValue]);
    
    NSDictionary *standardResInfo = imagesInfo[kStandardResolution];
    _standardResolutionImageURL = [[NSURL alloc] initWithString:standardResInfo[kURL]];
    _standardResolutionImageFrameSize = CGSizeMake([standardResInfo[kWidth] floatValue], [standardResInfo[kHeight] floatValue]);
}

- (void)initializeVideos:(NSDictionary *)videosInfo
{
    NSDictionary *lowResInfo = videosInfo[kLowResolution];
    _lowResolutionVideoURL = [[NSURL alloc] initWithString:lowResInfo[kURL]];
    _lowResolutionVideoFrameSize = CGSizeMake([lowResInfo[kWidth] floatValue], [lowResInfo[kHeight] floatValue]);
    
    NSDictionary *standardResInfo = videosInfo[kStandardResolution];
    _standardResolutionVideoURL = [[NSURL alloc] initWithString:standardResInfo[kURL]];
    _standardResolutionVideoFrameSize = CGSizeMake([standardResInfo[kWidth] floatValue], [standardResInfo[kHeight] floatValue]);
}

@end
