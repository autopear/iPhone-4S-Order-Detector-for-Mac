#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>

@interface iPhone4SAppDelegate : NSObject <GrowlApplicationBridgeDelegate> {
    NSWindow *window;
    IBOutlet NSMenu *statusMenu;
    NSStatusItem * statusItem;
    NSPersistentStoreCoordinator *__persistentStoreCoordinator;
    NSManagedObjectModel *__managedObjectModel;
    NSManagedObjectContext *__managedObjectContext;
    IBOutlet NSComboBox *ComboArea, *ComboTimeUnit;
    IBOutlet NSButton *ButtonSeleceAll, *ButtonSelectReverse, *ButtonOpen, *ButtonStart;
    IBOutlet NSTextField *TextFieldURL, *TextFieldInterval, *TextFieldHelp;
    IBOutlet NSButton *CheckSilent;
    IBOutlet NSButton *CheckBlackS, *CheckBlackM, *CheckBlackL, *CheckWhiteS, *CheckWhiteM, *CheckWhiteL;
    IBOutlet NSTextField *LabelArea, *LabelURL, *LabelInterval, *LabelFollow;
    IBOutlet NSBox *BoxDevices, *BoxInterval, *BoxSilent;
    IBOutlet NSMenuItem *MenuAbout, *MenuReset, *MenuQuit, *AppAbout;
    
    int IntervalUnit;
    int Interval;
    bool ThreadStop, SilentOn;
    NSString *URLTemplate, *AreaCode, *DeviceSuffix;
    NSString *DeviceB16, *DeviceB32, *DeviceB64, *DeviceW16, *DeviceW32, *DeviceW64;
    NSMutableArray *ListURL, *ListDevice;
    NSSound *Ringtone;
}

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;
- (IBAction)selectAll:(id)sender;
- (IBAction)selectReverse:(id)sender;
- (IBAction)openURL:(id)sender;
- (IBAction)areaChanged:(id)sender;
- (IBAction)timeUnitChanged:(id)sender;
- (IBAction)startDetection:(id)sender;
- (IBAction)appQuit:(id)sender;
- (IBAction)showAbout:(id)sender;
- (IBAction)resetWindow:(id)sender;
- (IBAction)visitWeibo:(id)sender;
- (IBAction)silentChanged:(id)sender;
@end
