#import "ViewController.h"

@implementation ViewController

@synthesize showPicker;

- (IBAction)triggerPicker {
    if (defaultPickerView == nil) {
        defaultPickerView = [[AFPickerView alloc] initWithFrame:CGRectMake(0,245,320,216) backgroundImage:@"PickerBG.png" shadowImage:@"PickerShadow.png" glassImage:@"PickerGlass.png" title:@"AFPicker"];
        defaultPickerView.dataSource = self;
        defaultPickerView.delegate = self;
        [self.view addSubview:defaultPickerView];
    }
    [defaultPickerView showPicker];
    [defaultPickerView reloadData];
}

#pragma mark - AFPickerViewDataSource

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView {
    return 15;
}


- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row {
    return [NSString stringWithFormat:@"%i", row + 1];
}


#pragma mark - AFPickerViewDelegate

- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row {
}

@end
