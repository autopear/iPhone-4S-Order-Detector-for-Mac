#import "iPhone4SAppDelegate.h"

@implementation iPhone4SAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //Load localized strings
    [window setTitle:[NSLocalizedString(@"iPhone 4S Online Order Detector", @"iPhone 4S Online Order Detector") stringByAppendingString:@" v1.1"]];
    //Press buttons
    [ButtonOpen setTitle:NSLocalizedString(@"Open", @"Open")];
    [ButtonSeleceAll setTitle:NSLocalizedString(@"Select All", @"Select All")];
    //[ButtonSeleceAll sizeToFit];
    [ButtonSelectReverse setTitle:NSLocalizedString(@"Select Inverse", @"Select Inverse")];
    //[ButtonSelectReverse sizeToFit];
    [ButtonStart setTitle:NSLocalizedString(@"Start", @"Start")];
    //Group boxes
    [BoxDevices setTitle:NSLocalizedString(@"Select Device", @"Select Device")];
    [BoxInterval setTitle:NSLocalizedString(@"Detection Interval", @"Detection Interval")];
    [BoxSilent setTitle:NSLocalizedString(@"Silent Mode", @"Silent Mode")];
    //Time units
    [ComboTimeUnit removeAllItems];
    [ComboTimeUnit addItemWithObjectValue:NSLocalizedString(@"H", @"H")];
    [ComboTimeUnit addItemWithObjectValue:NSLocalizedString(@"M", @"M")];
    [ComboTimeUnit addItemWithObjectValue:NSLocalizedString(@"S", @"S")];
    //Check boxes
    [CheckBlackS setTitle:[NSLocalizedString(@"Black", @"Black") stringByAppendingString:@" 16GB"]];
    [CheckBlackM setTitle:[NSLocalizedString(@"Black", @"Black") stringByAppendingString:@" 32GB"]];
    [CheckBlackL setTitle:[NSLocalizedString(@"Black", @"Black") stringByAppendingString:@" 64GB"]];
    [CheckWhiteS setTitle:[NSLocalizedString(@"White", @"White") stringByAppendingString:@" 16GB"]];
    [CheckWhiteM setTitle:[NSLocalizedString(@"White", @"White") stringByAppendingString:@" 32GB"]];
    [CheckWhiteL setTitle:[NSLocalizedString(@"White", @"White") stringByAppendingString:@" 64GB"]];
    [CheckSilent setTitle:NSLocalizedString(@"Enabled", @"Enabled")];
    //Status bar
    [MenuQuit setTitle:NSLocalizedString(@"Quit", @"Quit")];
    [MenuAbout setTitle:NSLocalizedString(@"About", @"About")];
    [MenuReset setTitle:NSLocalizedString(@"Reset", @"Reset")];
    //Labels
    [LabelURL setTitleWithMnemonic:NSLocalizedString(@"URL:", @"URL:")];
    [LabelArea setTitleWithMnemonic:NSLocalizedString(@"Area:", @"Area:")];
    [LabelInterval setTitleWithMnemonic:NSLocalizedString(@"Interval:", @"Interval:")];
    [LabelFollow setTitleWithMnemonic:NSLocalizedString(@"Follow autopear at:", @"Follow autopear at:")];
    //Others
    [TextFieldHelp setTitleWithMnemonic:NSLocalizedString(@"1. Select an area where you want to order iPhone 4S from.\n\n2. Select the device(s) you want to order.\n\n3. Set the detection interval and the time unit.\n\n4. You can enable silent mode, which will only warn you when an order is available.", @"1. Select an area where you want to order iPhone 4S from.\n\n2. Select the device(s) you want to order.\n\n3. Set the detection interval and the time unit.\n\n4. You can enable silent mode, which will only warn you when an order is available.")];
    [AppAbout setTitle:[[NSLocalizedString(@"About", @"About") stringByAppendingString:@" "] stringByAppendingString:NSLocalizedString(@"iPhone 4S Online Order Detector", @"iPhone 4S Online Order Detector")]];
    //Set UI element;
    [ComboArea selectItemAtIndex:0];
    [ComboTimeUnit selectItemAtIndex:1];
    
    [TextFieldURL setStringValue:@"http://store.apple.com/hk/browse/home/shop_iphone/family/iphone/iphone4s"];
    
    //Set values for variables
    URLTemplate = @"http://store.apple.com/AREACODE/configure/DEVICECODE/A?select=select&product=DEVICECODE%2FA&cppart=UNLOCKED%2FWW&mco=";
    AreaCode = @"hk";
    DeviceSuffix = @"ZP";
    DeviceB16 = @"235";
    DeviceB32 = @"242";
    DeviceB64 = @"258";
    DeviceW16 = @"239";
    DeviceW32 = @"254";
    DeviceW64 = @"261";
    IntervalUnit = 60;
    SilentOn = FALSE;
    [window makeKeyAndOrderFront:self];
}

/**
    Returns the directory the application uses to store the Core Data store file. This code uses a directory named "iPhone4S" in the user's Library directory.
 */
- (NSURL *)applicationFilesDirectory {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *libraryURL = [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
    return [libraryURL URLByAppendingPathComponent:@"iPhone4S"];
}

/**
    Creates if necessary and returns the managed object model for the application.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (__managedObjectModel) {
        return __managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iPhone4S" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
    Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (__persistentStoreCoordinator) {
        return __persistentStoreCoordinator;
    }

    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;
    
    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:&error];
        
    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    else {
        if ([[properties objectForKey:NSURLIsDirectoryKey] boolValue] != YES) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]]; 
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];
            
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }
    
    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"iPhone4S.storedata"];
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        [__persistentStoreCoordinator release], __persistentStoreCoordinator = nil;
        return nil;
    }

    return __persistentStoreCoordinator;
}

/**
    Returns the managed object context for the application (which is already
    bound to the persistent store coordinator for the application.) 
 */
- (NSManagedObjectContext *)managedObjectContext {
    if (__managedObjectContext) {
        return __managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];

    return __managedObjectContext;
}

/**
    Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
 */
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}

/**
    Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
 */
- (IBAction)saveAction:(id)sender {
    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }

    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (IBAction)silentChanged:(id)sender {
    if ([CheckSilent state] == 1)
        SilentOn = TRUE;
    else
        SilentOn = FALSE;
}

- (IBAction)visitWeibo:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://weibo.com/autopear"]];
}

- (IBAction)selectAll:(id)sender {
    [CheckBlackS setState:NSOnState];
    [CheckBlackM setState:NSOnState];
    [CheckBlackL setState:NSOnState];
    [CheckWhiteS setState:NSOnState];
    [CheckWhiteM setState:NSOnState];
    [CheckWhiteL setState:NSOnState];
}

- (IBAction)selectReverse:(id)sender {
    [CheckBlackS setState:![CheckBlackS state]];
    [CheckBlackM setState:![CheckBlackM state]];
    [CheckBlackL setState:![CheckBlackL state]];
    [CheckWhiteS setState:![CheckWhiteS state]];
    [CheckWhiteM setState:![CheckWhiteM state]];
    [CheckWhiteL setState:![CheckWhiteL state]];
}

- (IBAction)openURL:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[TextFieldURL stringValue]]];
}

- (IBAction)timeUnitChanged:(id)sender {
    if ([ComboTimeUnit indexOfSelectedItem] == 0)
        IntervalUnit = 3600; //in hour
    if ([ComboTimeUnit indexOfSelectedItem] == 0)
        IntervalUnit = 60; //in minute
    if ([ComboTimeUnit indexOfSelectedItem] == 0)
        IntervalUnit = 1; //in second
}

- (IBAction)areaChanged:(id)sender {
    
    //Hong Kong English
    if ([ComboArea indexOfSelectedItem] == 0) {
        AreaCode = @"hk";
        DeviceSuffix = @"ZP";
        DeviceB16 = @"235";
        DeviceB32 = @"242";
        DeviceB64 = @"258";
        DeviceW16 = @"239";
        DeviceW32 = @"254";
        DeviceW64 = @"261";
    }
    //Hong Kong Chinese
    if ([ComboArea indexOfSelectedItem] == 1) {
        AreaCode = @"hk-zh";
        DeviceSuffix = @"ZP";
        DeviceB16 = @"235";
        DeviceB32 = @"242";
        DeviceB64 = @"258";
        DeviceW16 = @"239";
        DeviceW32 = @"254";
        DeviceW64 = @"261";
    }
    //China
    if ([ComboArea indexOfSelectedItem] == 2) {
        AreaCode = @"cn";
        DeviceSuffix = @"CH";
        DeviceB16 = @"234";
        DeviceB32 = @"241";
        DeviceB64 = @"257";
        DeviceW16 = @"237";
        DeviceW32 = @"244";
        DeviceW64 = @"260";
    }
    //Taiwan
    if ([ComboArea indexOfSelectedItem] == 3) {
        AreaCode = @"tw";
        DeviceSuffix = @"TA";
        DeviceB16 = @"234";
        DeviceB32 = @"241";
        DeviceB64 = @"257";
        DeviceW16 = @"237";
        DeviceW32 = @"244";
        DeviceW64 = @"260";
    }
    //South Korea
    if ([ComboArea indexOfSelectedItem] == 4) {
        AreaCode = @"kr";
        DeviceSuffix = @"KH";
        DeviceB16 = @"234";
        DeviceB32 = @"241";
        DeviceB64 = @"257";
        DeviceW16 = @"237";
        DeviceW32 = @"244";
        DeviceW64 = @"260";
    }
    //New Zealand
    if ([ComboArea indexOfSelectedItem] == 5) {
        AreaCode = @"nz";
        DeviceSuffix = @"NZ";
        DeviceB16 = @"234";
        DeviceB32 = @"241";
        DeviceB64 = @"257";
        DeviceW16 = @"237";
        DeviceW32 = @"244";
        DeviceW64 = @"260";
    }

    [TextFieldURL setStringValue:[@"http://store.apple.com/AREACODE/browse/home/shop_iphone/family/iphone/iphone4s" stringByReplacingOccurrencesOfString:@"AREACODE" withString:AreaCode]];
}

- (void)awakeFromNib {
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    [statusItem setMenu:statusMenu];
    [statusItem setImage:[NSImage imageNamed:@"StatusBarIcon.png"]];
    [statusItem setAlternateImage:[NSImage imageNamed:@"StatusBarIconHilighted.png"]];
    [statusItem setHighlightMode:YES];
	[GrowlApplicationBridge setGrowlDelegate:self];
}

- (IBAction)appQuit:(id)sender {
    ThreadStop = false;
    [NSApp terminate: nil];
}

- (IBAction)showAbout:(id)sender {
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert addButtonWithTitle:NSLocalizedString(@"OK", @"OK")];
    [alert setMessageText:[NSLocalizedString(@"About", @"About") stringByAppendingString:NSLocalizedString(@"iPhone 4S Online Order Detector", @"iPhone 4S Online Order Detector")]];
    [alert setInformativeText:NSLocalizedString(@"In memory of Steve Jobs (1955 - 2011).\n\n\nCopyright © 2011 autopear.\nAll rights reserved.", @"In memory of Steve Jobs (1955 - 2011).\n\n\nCopyright © 2011 autopear.\nAll rights reserved.")];
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert runModal];
}

- (IBAction)resetWindow:(id)sender {
    ThreadStop = false;
    [window makeKeyAndOrderFront:self];
}

- (IBAction)startDetection:(id)sender {
    //Check interval
    NSScanner *NumericScanner = [NSScanner scannerWithString:[TextFieldInterval stringValue]];
    int val; 
    if (![NumericScanner scanInt:&val] || ![NumericScanner isAtEnd]) {
        NSAlert *alert = [[[NSAlert alloc] init] autorelease];
        [alert addButtonWithTitle:NSLocalizedString(@"OK", @"OK")];
        [alert setMessageText:NSLocalizedString(@"Error", @"Error")];
        [alert setInformativeText:NSLocalizedString(@"Detection interval must be an integer.", @"Detection interval must be an integer.")];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert runModal];
    } else {
        Interval = [TextFieldInterval intValue];
        if ([ListDevice count] > 0)
            [ListDevice removeAllObjects];
        else
            ListDevice = [[NSMutableArray alloc] init];

        if ([ListURL count] > 0)
            [ListURL removeAllObjects];
        else
            ListURL = [[NSMutableArray alloc] init];
        
        if ([CheckBlackS state] == 1) {
            [ListDevice addObject:[NSLocalizedString(@"Black", @"Black") stringByAppendingString:@" 16GB"]];
            [ListURL addObject:[[URLTemplate stringByReplacingOccurrencesOfString:@"AREACODE" withString:AreaCode] stringByReplacingOccurrencesOfString:@"DEVICECODE" withString:[NSString stringWithFormat:@"MD%@%@", DeviceB16, DeviceSuffix]]];
        }
        if ([CheckBlackM state] == 1) {
            [ListDevice addObject:[NSLocalizedString(@"Black", @"Black") stringByAppendingString:@" 32GB"]];
            [ListURL addObject:[[URLTemplate stringByReplacingOccurrencesOfString:@"AREACODE" withString:AreaCode] stringByReplacingOccurrencesOfString:@"DEVICECODE" withString:[NSString stringWithFormat:@"MD%@%@", DeviceB32, DeviceSuffix]]];
        }
        if ([CheckBlackL state] == 1) {
            [ListDevice addObject:[NSLocalizedString(@"Black", @"Black") stringByAppendingString:@" 64GB"]];
            [ListURL addObject:[[URLTemplate stringByReplacingOccurrencesOfString:@"AREACODE" withString:AreaCode] stringByReplacingOccurrencesOfString:@"DEVICECODE" withString:[NSString stringWithFormat:@"MD%@%@", DeviceB32, DeviceSuffix]]];
        }
        if ([CheckWhiteS state] == 1) {
            [ListDevice addObject:[NSLocalizedString(@"White", @"White") stringByAppendingString:@" 16GB"]];
            [ListURL addObject:[[URLTemplate stringByReplacingOccurrencesOfString:@"AREACODE" withString:AreaCode] stringByReplacingOccurrencesOfString:@"DEVICECODE" withString:[NSString stringWithFormat:@"MD%@%@", DeviceW16, DeviceSuffix]]];
        }
        if ([CheckWhiteM state] == 1) {
            [ListDevice addObject:[NSLocalizedString(@"White", @"White") stringByAppendingString:@" 32GB"]];
            [ListURL addObject:[[URLTemplate stringByReplacingOccurrencesOfString:@"AREACODE" withString:AreaCode] stringByReplacingOccurrencesOfString:@"DEVICECODE" withString:[NSString stringWithFormat:@"MD%@%@", DeviceW32, DeviceSuffix]]];
        }
        if ([CheckWhiteL state] == 1) {
            [ListDevice addObject:[NSLocalizedString(@"White", @"White") stringByAppendingString:@" 64GB"]];
            [ListURL addObject:[[URLTemplate stringByReplacingOccurrencesOfString:@"AREACODE" withString:AreaCode] stringByReplacingOccurrencesOfString:@"DEVICECODE" withString:[NSString stringWithFormat:@"MD%@%@", DeviceW64, DeviceSuffix]]];
        }
        
        if ([ListDevice count] == 0) {
            NSAlert *alert = [[[NSAlert alloc] init] autorelease];
            [alert addButtonWithTitle:NSLocalizedString(@"OK", @"OK")];
            [alert setMessageText:NSLocalizedString(@"Error", @"Error")];
            [alert setInformativeText:NSLocalizedString(@"You must select at least one device.", @"You must select at least one device.")];
            [alert setAlertStyle:NSCriticalAlertStyle];
            [alert runModal];
        } else {
            //Hide main window
            [window orderOut:self];
            ThreadStop = true;
            [NSThread detachNewThreadSelector:@selector(threadDetection) toTarget:self withObject:nil];
            [GrowlApplicationBridge notifyWithTitle:NSLocalizedString(@"iPhone 4S Online Order Detector", @"iPhone 4S Online Order Detector")
                description:NSLocalizedString(@"Detection started! Use the status bar icon to access the application.", @"Detection started! Use the status bar icon to access the application.")
                notificationName:@"StandardReminder"
                iconData:nil
                priority:1
                isSticky:NO
                clickContext:@"test"];
        }
    }
}

- (void) threadDetection {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];  //set up a pool
        [self performSelectorInBackground:@selector(checkPageStatus) withObject:nil];  
        [pool drain];
}

- (void) checkPageStatus {
    while (ThreadStop) {
        NSString *AlertContent = @"";
        for (int i=0; i<[ListDevice count]; i++) {
            NSMutableURLRequest *request = [[NSURLRequest requestWithURL:[NSURL URLWithString:[ListURL objectAtIndex:i]]] mutableCopy];
            [request setHTTPMethod:@"HEAD"];
            [request autorelease];
            NSURLResponse *response = nil;
            NSError **error=nil; 
            [[NSData alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error]];
            NSInteger statusCode;
            if ([[[response URL] absoluteString] hasSuffix:@"/cart"])
                statusCode = 404;
            else
                statusCode = [((NSHTTPURLResponse *)response) statusCode];
            if (statusCode == 200) {
                AlertContent = [AlertContent stringByAppendingString:@"  * iPhone 4S "];
                AlertContent = [AlertContent stringByAppendingString:[ListDevice objectAtIndex:i]];
                AlertContent = [AlertContent stringByAppendingString:@"\n"];
            }
        }
        if (AlertContent != @"") {
            NSAlert *alert = [[[NSAlert alloc] init] autorelease];
            [alert addButtonWithTitle:NSLocalizedString(@"OK", @"OK")];
            [alert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Cancel")];
            [alert setMessageText:NSLocalizedString(@"You can order iPhone 4S now!", @"You can order iPhone 4S now!")];
            [alert setInformativeText:[[NSLocalizedString(@"Devices below can be ordered now:\n\n", @"Devices below can be ordered now:\n\n") stringByAppendingString:AlertContent] stringByAppendingString:NSLocalizedString(@"\nPress OK to open the page to order iPhone 4S, or press Cancel to continue running.", @"\nPress OK to open the page to order iPhone 4S, or press Cancel to continue running.")]];
            [alert setIcon:[NSImage imageNamed:@"iPhone4S.png"]];
            
            Ringtone = [NSSound soundNamed:@"music.mp3"];
            if (![Ringtone isPlaying])
                [Ringtone play];
            
            if  ([alert runModal] == NSAlertFirstButtonReturn) {
                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[TextFieldURL stringValue]]];
            }
            
            if ([Ringtone isPlaying])
                [Ringtone stop];
            [window makeKeyAndOrderFront:self];
            return;
        } else {
            if (!SilentOn) {
                [GrowlApplicationBridge notifyWithTitle:NSLocalizedString(@"iPhone 4S Online Order Detector", @"iPhone 4S Online Order Detector")
                    description:NSLocalizedString(@"None of your selected device is available for order.", @"None of your selected device is available for order.")
                    notificationName:@"StandardReminder"
                    iconData:nil
                    priority:1
                    isSticky:NO
                    clickContext:@"test"];
            }
        }
        [NSThread sleepForTimeInterval:Interval*IntervalUnit];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    // Save changes in the application's managed object context before the application terminates.

    if (!__managedObjectContext) {
        return NSTerminateNow;
    }

    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }

    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }

    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit", @"Quit");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        [alert release];
        alert = nil;
        
        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

- (void)dealloc
{
    [__managedObjectContext release];
    [__persistentStoreCoordinator release];
    [__managedObjectModel release];
    [super dealloc];
}

#pragma mark ---   Growl Delegate Methods   ---

- (void) growlNotificationWasClicked:(id)clickContext
{
	[self activateIgnoringOtherApps:YES];
}

- (NSDictionary *) registrationDictionaryForGrowl
{
	NSArray *notifications = [NSArray arrayWithObject: @"StandardReminder"];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          notifications, GROWL_NOTIFICATIONS_ALL,
                          notifications, GROWL_NOTIFICATIONS_DEFAULT, nil];
	
	return dict;
}
@end
