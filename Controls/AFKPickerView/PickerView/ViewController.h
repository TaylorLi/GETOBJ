#import <UIKit/UIKit.h>
#import "AFPickerView.h"

@interface ViewController : UIViewController <AFPickerViewDataSource, AFPickerViewDelegate> {
    AFPickerView *defaultPickerView;
}

- (IBAction)triggerPicker;

@property(strong, nonatomic) IBOutlet UIButton *showPicker;

@end
