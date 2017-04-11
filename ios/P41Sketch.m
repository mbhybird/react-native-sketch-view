
#import "P41Sketch.h"


@implementation P41Sketch

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_CUSTOM_VIEW_PROPERTY(selectedTool, NSInteger, SketchViewContainer)
{
    SketchViewContainer *currentView = !view ? defaultView : view;
    [currentView.sketchView setToolType:[RCTConvert NSInteger:json]];
}

RCT_EXPORT_MODULE()

-(UIView *)view
{
    self.sketchViewContainer = [[[NSBundle mainBundle] loadNibNamed:@"SketchViewContainer" owner:self options:nil] firstObject];
    return self.sketchViewContainer;
}

RCT_EXPORT_METHOD(saveSketch:(nonnull NSNumber *)reactTag) {
    dispatch_async(dispatch_get_main_queue(), ^{
        SketchFile *sketchFile = [self.sketchViewContainer saveToLocalCache];
        [self onSaveSketch:sketchFile];
    });
}

RCT_EXPORT_METHOD(clearSketch:(nonnull NSNumber *)reactTag) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.sketchViewContainer.sketchView clear];
    });
}

RCT_EXPORT_METHOD(changeTool:(nonnull NSNumber *)reactTag toolId:(NSInteger) toolId) {
    [self.sketchViewContainer.sketchView setToolType:toolId];
}

-(void)onSaveSketch:(SketchFile *) sketchFile
{
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"onSaveSketch" body:
  @{
    @"localFilePath": sketchFile.localFilePath,
    @"imageWidth": [NSNumber numberWithFloat:sketchFile.size.width],
    @"imageHeight": [NSNumber numberWithFloat:sketchFile.size.height]
    }];
}

@end
  
