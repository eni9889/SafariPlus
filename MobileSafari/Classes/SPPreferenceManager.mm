// SPPreferenceManager.mm
// (c) 2019 opa334

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

#import "SPPreferenceManager.h"

#import "../Defines.h"
#import "../Shared.h"

#ifndef NO_CEPHEI
#import <Cephei/HBPreferences.h>
#endif

void reloadOtherPlist()
{
	[preferenceManager reloadOtherPlist];
}

#ifdef NO_CEPHEI

void reloadPrefs()
{
	[preferenceManager reloadPrefs];
}

#endif

@implementation SPPreferenceManager

+ (instancetype)sharedInstance
{
	static SPPreferenceManager *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^
	{
		sharedInstance = [[SPPreferenceManager alloc] init];
	});
	return sharedInstance;
}

- (id)init
{
	self = [super init];

  #if defined(NO_CEPHEI)

	[self reloadPrefs];

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPrefs, CFSTR("com.opa334.safariplusprefs/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);

	#else

	preferences = [[HBPreferences alloc] initWithIdentifier:SarafiPlusPrefsDomain];

	[preferences registerBool:&_forceHTTPSEnabled default:NO forKey:@"forceHTTPSEnabled"];
	[preferences registerBool:&_openInOppositeModeOptionEnabled default:NO forKey:@"openInOppositeModeOptionEnabled"];
	[preferences registerBool:&_openInNewTabOptionEnabled default:NO forKey:@"openInNewTabOptionEnabled"];
	[preferences registerBool:&_uploadAnyFileOptionEnabled default:NO forKey:@"uploadAnyFileOptionEnabled"];
	[preferences registerBool:&_desktopButtonEnabled default:NO forKey:@"desktopButtonEnabled"];
	[preferences registerBool:&_longPressSuggestionsEnabled default:NO forKey:@"longPressSuggestionsEnabled"];
	[preferences registerFloat:&_longPressSuggestionsDuration default:1 forKey:@"longPressSuggestionsDuration"];
	[preferences registerBool:&_longPressSuggestionsFocusEnabled default:YES forKey:@"longPressSuggestionsFocusEnabled"];

	[preferences registerBool:&_enhancedDownloadsEnabled default:NO forKey:@"enhancedDownloadsEnabled"];
	[preferences registerBool:&_videoDownloadingEnabled default:NO forKey:@"videoDownloadingEnabled"];
	[preferences registerInteger:&_defaultDownloadSection default:0 forKey:@"defaultDownloadSection"];
	[preferences registerBool:&_defaultDownloadSectionAutoSwitchEnabled default:NO forKey:@"defaultDownloadSectionAutoSwitchEnabled"];
	[preferences registerBool:&_downloadSiteToActionEnabled default:YES forKey:@"downloadSiteToActionEnabled"];
	[preferences registerBool:&_downloadImageToActionEnabled default:YES forKey:@"downloadImageToActionEnabled"];
	[preferences registerBool:&_instantDownloadsEnabled default:NO forKey:@"instantDownloadsEnabled"];
	[preferences registerInteger:&_instantDownloadsOption default:NO forKey:@"instantDownloadsOption"];
	[preferences registerBool:&_customDefaultPathEnabled default:NO forKey:@"customDefaultPathEnabled"];
	[preferences registerObject:&_customDefaultPath default:defaultDownloadPath forKey:@"customDefaultPath"];
	[preferences registerBool:&_pinnedLocationsEnabled default:NO forKey:@"pinnedLocationsEnabled"];
	[preferences registerBool:&_onlyDownloadOnWifiEnabled default:NO forKey:@"onlyDownloadOnWifiEnabled"];
	[preferences registerBool:&_disablePushNotificationsEnabled default:NO forKey:@"disablePushNotificationsEnabled"];
	[preferences registerBool:&_disableBarNotificationsEnabled default:NO forKey:@"disableBarNotificationsEnabled"];

	[preferences registerBool:&_forceModeOnStartEnabled default:NO forKey:@"forceModeOnStartEnabled"];
	[preferences registerInteger:&_forceModeOnStartFor default:0 forKey:@"forceModeOnStartFor"];
	[preferences registerBool:&_forceModeOnResumeEnabled default:NO forKey:@"forceModeOnResumeEnabled"];
	[preferences registerInteger:&_forceModeOnResumeFor default:0 forKey:@"forceModeOnResumeFor"];
	[preferences registerBool:&_forceModeOnExternalLinkEnabled default:NO forKey:@"forceModeOnExternalLinkEnabled"];
	[preferences registerInteger:&_forceModeOnExternalLinkFor default:0 forKey:@"forceModeOnExternalLinkFor"];
	[preferences registerBool:&_autoCloseTabsEnabled default:NO forKey:@"autoCloseTabsEnabled"];
	[preferences registerInteger:&_autoCloseTabsOn default:0 forKey:@"autoCloseTabsOn"];
	[preferences registerInteger:&_autoCloseTabsFor default:0 forKey:@"autoCloseTabsFor"];
	[preferences registerBool:&_autoDeleteDataEnabled default:NO forKey:@"autoDeleteDataEnabled"];
	[preferences registerInteger:&_autoDeleteDataOn default:0 forKey:@"autoDeleteDataOn"];

	[preferences registerBool:&_URLLeftSwipeGestureEnabled default:NO forKey:@"URLLeftSwipeGestureEnabled"];
	[preferences registerInteger:&_URLLeftSwipeAction default:0 forKey:@"URLLeftSwipeAction"];
	[preferences registerBool:&_URLRightSwipeGestureEnabled default:NO forKey:@"URLRightSwipeGestureEnabled"];
	[preferences registerInteger:&_URLRightSwipeAction default:0 forKey:@"URLRightSwipeAction"];
	[preferences registerBool:&_URLDownSwipeGestureEnabled default:NO forKey:@"URLDownSwipeGestureEnabled"];
	[preferences registerInteger:&_URLDownSwipeAction default:0 forKey:@"URLDownSwipeAction"];
	[preferences registerBool:&_gestureBackground default:NO forKey:@"gestureBackground"];

	[preferences registerBool:&_fullscreenScrollingEnabled default:NO forKey:@"fullscreenScrollingEnabled"];
	[preferences registerBool:&_removeTabLimit default:NO forKey:@"removeTabLimit"];
	[preferences registerBool:&_lockBars default:NO forKey:@"lockBars"];
	[preferences registerBool:&_disablePrivateMode default:NO forKey:@"disablePrivateMode"];
	[preferences registerBool:&_alwaysOpenNewTabEnabled default:NO forKey:@"alwaysOpenNewTabEnabled"];
	[preferences registerBool:&_alwaysOpenNewTabInBackgroundEnabled default:NO forKey:@"alwaysOpenNewTabInBackgroundEnabled"];
	[preferences registerBool:&_suppressMailToDialog default:NO forKey:@"suppressMailToDialog"];
	[preferences registerBool:&_communicationErrorDisabled default:NO forKey:@"communicationErrorDisabled"];

	#if !defined(NO_LIBCOLORPICKER)

	[preferences registerBool:&_topBarNormalTintColorEnabled default:NO forKey:@"topBarNormalTintColorEnabled"];
	[preferences registerObject:&_topBarNormalTintColor default:nil forKey:@"topBarNormalTintColor"];
	[preferences registerBool:&_topBarNormalBackgroundColorEnabled default:NO forKey:@"topBarNormalBackgroundColorEnabled"];
	[preferences registerObject:&_topBarNormalBackgroundColor default:nil forKey:@"topBarNormalBackgroundColor"];
	[preferences registerBool:&_topBarNormalStatusBarStyleEnabled default:UIStatusBarStyleDefault forKey:@"topBarNormalStatusBarStyleEnabled"];
	[preferences registerInteger:&_topBarNormalStatusBarStyle default:NO forKey:@"topBarNormalStatusBarStyle"];
	[preferences registerBool:&_topBarNormalTabBarTitleColorEnabled default:NO forKey:@"topBarNormalTabBarTitleColorEnabled"];
	[preferences registerObject:&_topBarNormalTabBarTitleColor default:nil forKey:@"topBarNormalTabBarTitleColor"];
	[preferences registerFloat:&_topBarNormalTabBarInactiveTitleOpacity default:0.4 forKey:@"topBarNormalTabBarInactiveTitleOpacity"];
	[preferences registerBool:&_topBarNormalURLFontColorEnabled default:NO forKey:@"topBarNormalURLFontColorEnabled"];
	[preferences registerObject:&_topBarNormalURLFontColor default:nil forKey:@"topBarNormalURLFontColor"];
	[preferences registerBool:&_topBarNormalProgressBarColorEnabled default:NO forKey:@"topBarNormalProgressBarColorEnabled"];
	[preferences registerObject:&_topBarNormalProgressBarColor default:nil forKey:@"topBarNormalProgressBarColor"];
	[preferences registerBool:&_topBarNormalLockIconColorEnabled default:NO forKey:@"topBarNormalLockIconColorEnabled"];
	[preferences registerObject:&_topBarNormalLockIconColor default:nil forKey:@"topBarNormalLockIconColor"];
	[preferences registerBool:&_topBarNormalReloadButtonColorEnabled default:NO forKey:@"topBarNormalReloadButtonColorEnabled"];
	[preferences registerObject:&_topBarNormalReloadButtonColor default:nil forKey:@"topBarNormalReloadButtonColor"];
	[preferences registerBool:&_bottomBarNormalTintColorEnabled default:NO forKey:@"bottomBarNormalTintColorEnabled"];
	[preferences registerObject:&_bottomBarNormalTintColor default:nil forKey:@"bottomBarNormalTintColor"];
	[preferences registerBool:&_bottomBarNormalBackgroundColorEnabled default:NO forKey:@"bottomBarNormalBackgroundColorEnabled"];
	[preferences registerObject:&_bottomBarNormalBackgroundColor default:nil forKey:@"bottomBarNormalBackgroundColor"];
	[preferences registerBool:&_tabTitleBarNormalTextColorEnabled default:NO forKey:@"tabTitleBarNormalTextColorEnabled"];
	[preferences registerObject:&_tabTitleBarNormalTextColor default:nil forKey:@"tabTitleBarNormalTextColor"];
	[preferences registerBool:&_tabTitleBarNormalBackgroundColorEnabled default:NO forKey:@"tabTitleBarNormalBackgroundColorEnabled"];
	[preferences registerObject:&_tabTitleBarNormalBackgroundColor default:nil forKey:@"tabTitleBarNormalBackgroundColor"];

	[preferences registerBool:&_topBarPrivateTintColorEnabled default:NO forKey:@"topBarPrivateTintColorEnabled"];
	[preferences registerObject:&_topBarPrivateTintColor default:nil forKey:@"topBarPrivateTintColor"];
	[preferences registerBool:&_topBarPrivateBackgroundColorEnabled default:NO forKey:@"topBarPrivateBackgroundColorEnabled"];
	[preferences registerObject:&_topBarPrivateBackgroundColor default:nil forKey:@"topBarPrivateBackgroundColor"];
	[preferences registerBool:&_topBarPrivateStatusBarStyleEnabled default:UIStatusBarStyleDefault forKey:@"topBarPrivateStatusBarStyleEnabled"];
	[preferences registerInteger:&_topBarPrivateStatusBarStyle default:NO forKey:@"topBarPrivateStatusBarStyle"];
	[preferences registerBool:&_topBarPrivateTabBarTitleColorEnabled default:NO forKey:@"topBarPrivateTabBarTitleColorEnabled"];
	[preferences registerObject:&_topBarPrivateTabBarTitleColor default:nil forKey:@"topBarPrivateTabBarTitleColor"];
	[preferences registerFloat:&_topBarPrivateTabBarInactiveTitleOpacity default:0.2 forKey:@"topBarPrivateTabBarInactiveTitleOpacity"];
	[preferences registerBool:&_topBarPrivateURLFontColorEnabled default:NO forKey:@"topBarPrivateURLFontColorEnabled"];
	[preferences registerObject:&_topBarPrivateURLFontColor default:nil forKey:@"topBarPrivateURLFontColor"];
	[preferences registerBool:&_topBarPrivateProgressBarColorEnabled default:NO forKey:@"topBarPrivateProgressBarColorEnabled"];
	[preferences registerObject:&_topBarPrivateProgressBarColor default:nil forKey:@"topBarPrivateProgressBarColor"];
	[preferences registerBool:&_topBarPrivateLockIconColorEnabled default:NO forKey:@"topBarPrivateLockIconColorEnabled"];
	[preferences registerObject:&_topBarPrivateLockIconColor default:nil forKey:@"topBarPrivateLockIconColor"];
	[preferences registerBool:&_topBarPrivateReloadButtonColorEnabled default:NO forKey:@"topBarPrivateReloadButtonColorEnabled"];
	[preferences registerObject:&_topBarPrivateReloadButtonColor default:nil forKey:@"topBarPrivateReloadButtonColor"];
	[preferences registerBool:&_bottomBarPrivateTintColorEnabled default:NO forKey:@"bottomBarPrivateTintColorEnabled"];
	[preferences registerObject:&_bottomBarPrivateTintColor default:nil forKey:@"bottomBarPrivateTintColor"];
	[preferences registerBool:&_bottomBarPrivateBackgroundColorEnabled default:NO forKey:@"bottomBarPrivateBackgroundColorEnabled"];
	[preferences registerObject:&_bottomBarPrivateBackgroundColor default:nil forKey:@"bottomBarPrivateBackgroundColor"];
	[preferences registerBool:&_tabTitleBarPrivateTextColorEnabled default:NO forKey:@"tabTitleBarPrivateTextColorEnabled"];
	[preferences registerObject:&_tabTitleBarPrivateTextColor default:nil forKey:@"tabTitleBarPrivateTextColor"];
	[preferences registerBool:&_tabTitleBarPrivateBackgroundColorEnabled default:NO forKey:@"tabTitleBarPrivateBackgroundColorEnabled"];
	[preferences registerObject:&_tabTitleBarPrivateBackgroundColor default:nil forKey:@"tabTitleBarPrivateBackgroundColor"];

	#endif
  #endif

	[self reloadOtherPlist];

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadOtherPlist, CFSTR("com.opa334.safariplusprefs/ReloadOtherPlist"), NULL, CFNotificationSuspensionBehaviorCoalesce);

	return self;
}

#if defined NO_CEPHEI

- (void)reloadPrefs
{
	userDefaults = [[NSDictionary alloc] initWithContentsOfFile:path(prefPlistPath)];
}

- (BOOL)forceHTTPSEnabled { return [[userDefaults objectForKey:@"forceHTTPSEnabled"] boolValue]; }
- (BOOL)openInOppositeModeOptionEnabled { return [[userDefaults objectForKey:@"openInOppositeModeOptionEnabled"] boolValue]; }
- (BOOL)openInNewTabOptionEnabled { return [[userDefaults objectForKey:@"openInNewTabOptionEnabled"] boolValue]; }
- (BOOL)uploadAnyFileOptionEnabled { return [[userDefaults objectForKey:@"uploadAnyFileOptionEnabled"] boolValue]; }
- (BOOL)desktopButtonEnabled { return [[userDefaults objectForKey:@"desktopButtonEnabled"] boolValue]; }
- (BOOL)longPressSuggestionsEnabled { return [[userDefaults objectForKey:@"longPressSuggestionsEnabled"] boolValue]; }
- (CGFloat)longPressSuggestionsDuration { return [userDefaults objectForKey:@"longPressSuggestionsDuration"] ?[[userDefaults objectForKey:@"longPressSuggestionsDuration"] floatValue] : 0.5; }
- (BOOL)longPressSuggestionsFocusEnabled { return [[userDefaults objectForKey:@"longPressSuggestionsFocusEnabled"] boolValue]; }

- (BOOL)enhancedDownloadsEnabled { return [[userDefaults objectForKey:@"enhancedDownloadsEnabled"] boolValue]; }
- (BOOL)videoDownloadingEnabled { return [[userDefaults objectForKey:@"videoDownloadingEnabled"] boolValue]; }
- (NSInteger)defaultDownloadSection { return [userDefaults objectForKey:@"defaultDownloadSection"] ?[[userDefaults objectForKey:@"defaultDownloadSection"] integerValue] : 1; }
- (BOOL)defaultDownloadSectionAutoSwitchEnabled { return [[userDefaults objectForKey:@"defaultDownloadSectionAutoSwitchEnabled"] boolValue]; }
- (BOOL)downloadSiteToActionEnabled { return [userDefaults objectForKey:@"downloadSiteToActionEnabled"] ?[[userDefaults objectForKey:@"downloadSiteToActionEnabled"] boolValue] : YES; }
- (BOOL)downloadImageToActionEnabled { return [userDefaults objectForKey:@"downloadImageToActionEnabled"] ?[[userDefaults objectForKey:@"downloadImageToActionEnabled"] boolValue] : YES; }
- (BOOL)instantDownloadsEnabled { return [[userDefaults objectForKey:@"instantDownloadsEnabled"] boolValue]; }
- (NSInteger)instantDownloadsOption { return [[userDefaults objectForKey:@"instantDownloadsOption"] integerValue]; }
- (BOOL)customDefaultPathEnabled { return [[userDefaults objectForKey:@"customDefaultPathEnabled"] boolValue]; }
- (NSString*)customDefaultPath { return [userDefaults objectForKey:@"customDefaultPath"]; }
- (BOOL)pinnedLocationsEnabled { return [[userDefaults objectForKey:@"pinnedLocationsEnabled"] boolValue]; }
- (BOOL)onlyDownloadOnWifiEnabled { return [[userDefaults objectForKey:@"onlyDownloadOnWifiEnabled"] boolValue]; }
- (BOOL)disablePushNotificationsEnabled { return [[userDefaults objectForKey:@"disablePushNotificationsEnabled"] boolValue]; }
- (BOOL)disableBarNotificationsEnabled { return [[userDefaults objectForKey:@"disableBarNotificationsEnabled"] boolValue]; }

- (BOOL)forceModeOnStartEnabled { return [[userDefaults objectForKey:@"forceModeOnStartEnabled"] boolValue]; }
- (NSInteger)forceModeOnStartFor { return [[userDefaults objectForKey:@"forceModeOnStartFor"] integerValue]; }
- (BOOL)forceModeOnResumeEnabled { return [[userDefaults objectForKey:@"forceModeOnResumeEnabled"] boolValue]; }
- (NSInteger)forceModeOnResumeFor { return [[userDefaults objectForKey:@"forceModeOnResumeFor"] integerValue]; }
- (BOOL)forceModeOnExternalLinkEnabled { return [[userDefaults objectForKey:@"forceModeOnExternalLinkEnabled"] boolValue]; }
- (NSInteger)forceModeOnExternalLinkFor { return [[userDefaults objectForKey:@"forceModeOnExternalLinkFor"] integerValue]; }
- (BOOL)autoCloseTabsEnabled { return [[userDefaults objectForKey:@"autoCloseTabsEnabled"] boolValue]; }
- (NSInteger)autoCloseTabsOn { return [[userDefaults objectForKey:@"autoCloseTabsOn"] integerValue]; }
- (NSInteger)autoCloseTabsFor { return [[userDefaults objectForKey:@"autoCloseTabsFor"] integerValue]; }
- (BOOL)autoDeleteDataEnabled { return [[userDefaults objectForKey:@"autoDeleteDataEnabled"] boolValue]; }
- (NSInteger)autoDeleteDataOn { return [[userDefaults objectForKey:@"autoDeleteDataOn"] integerValue]; }

- (BOOL)URLLeftSwipeGestureEnabled { return [[userDefaults objectForKey:@"URLLeftSwipeGestureEnabled"] boolValue]; }
- (NSInteger)URLLeftSwipeAction { return [[userDefaults objectForKey:@"URLLeftSwipeAction"] integerValue]; }
- (BOOL)URLRightSwipeGestureEnabled { return [[userDefaults objectForKey:@"URLRightSwipeGestureEnabled"] boolValue]; }
- (NSInteger)URLRightSwipeAction { return [[userDefaults objectForKey:@"URLRightSwipeAction"] integerValue]; }
- (BOOL)URLDownSwipeGestureEnabled { return [[userDefaults objectForKey:@"URLDownSwipeGestureEnabled"] boolValue]; }
- (NSInteger)URLDownSwipeAction { return [[userDefaults objectForKey:@"URLDownSwipeAction"] integerValue]; }
- (BOOL)gestureBackground { return [[userDefaults objectForKey:@"gestureBackground"] boolValue]; }

- (BOOL)fullscreenScrollingEnabled { return [[userDefaults objectForKey:@"fullscreenScrollingEnabled"] boolValue]; }
- (BOOL)removeTabLimit { return [[userDefaults objectForKey:@"removeTabLimit"] boolValue]; }
- (BOOL)lockBars { return [[userDefaults objectForKey:@"lockBars"] boolValue]; }
- (BOOL)disablePrivateMode { return [[userDefaults objectForKey:@"disablePrivateMode"] boolValue]; }
- (BOOL)alwaysOpenNewTabEnabled { return [[userDefaults objectForKey:@"alwaysOpenNewTabEnabled"] boolValue]; }
- (BOOL)alwaysOpenNewTabInBackgroundEnabled { return [[userDefaults objectForKey:@"alwaysOpenNewTabInBackgroundEnabled"] boolValue]; }
- (BOOL)suppressMailToDialog { return [[userDefaults objectForKey:@"suppressMailToDialog"] boolValue]; }

#if !defined(NO_LIBCOLORPICKER)

- (BOOL)topBarNormalTintColorEnabled { return [[userDefaults objectForKey:@"topBarNormalTintColorEnabled"] boolValue]; }
- (BOOL)topBarNormalBackgroundColorEnabled { return [[userDefaults objectForKey:@"topBarNormalBackgroundColorEnabled"] boolValue]; }
- (BOOL)topBarNormalStatusBarStyleEnabled { return [[userDefaults objectForKey:@"topBarNormalStatusBarStyleEnabled"] boolValue]; }
- (UIStatusBarStyle)topBarNormalStatusBarStyle { return [[userDefaults objectForKey:@"topBarNormalStatusBarStyle"] intValue]; }
- (BOOL)topBarNormalTabBarTitleColorEnabled { return [[userDefaults objectForKey:@"topBarNormalTabBarTitleColorEnabled"] boolValue]; }
- (CGFloat)topBarNormalTabBarInactiveTitleOpacity { return [[userDefaults objectForKey:@"topBarNormalTabBarInactiveTitleOpacity"] floatValue]; }
- (BOOL)topBarNormalURLFontColorEnabled { return [[userDefaults objectForKey:@"topBarNormalURLFontColorEnabled"] boolValue]; }
- (BOOL)topBarNormalProgressBarColorEnabled { return [[userDefaults objectForKey:@"topBarNormalProgressBarColorEnabled"] boolValue]; }
- (BOOL)topBarNormalLockIconColorEnabled { return [[userDefaults objectForKey:@"topBarNormalLockIconColorEnabled"] boolValue]; }
- (BOOL)topBarNormalReloadButtonColorEnabled { return [[userDefaults objectForKey:@"topBarNormalReloadButtonColorEnabled"] boolValue]; }
- (BOOL)bottomBarNormalTintColorEnabled { return [[userDefaults objectForKey:@"bottomBarNormalTintColorEnabled"] boolValue]; }
- (BOOL)bottomBarNormalBackgroundColorEnabled { return [[userDefaults objectForKey:@"bottomBarNormalBackgroundColorEnabled"] boolValue]; }
- (BOOL)tabTitleBarNormalTextColorEnabled { return [[userDefaults objectForKey:@"tabTitleBarNormalTextColorEnabled"] boolValue]; }
- (BOOL)tabTitleBarNormalBackgroundColorEnabled { return [[userDefaults objectForKey:@"tabTitleBarNormalBackgroundColorEnabled"] boolValue]; }

- (BOOL)topBarPrivateTintColorEnabled { return [[userDefaults objectForKey:@"topBarPrivateTintColorEnabled"] boolValue]; }
- (BOOL)topBarPrivateBackgroundColorEnabled { return [[userDefaults objectForKey:@"topBarPrivateBackgroundColorEnabled"] boolValue]; }
- (BOOL)topBarPrivateStatusBarStyleEnabled { return [[userDefaults objectForKey:@"topBarPrivateStatusBarStyleEnabled"] boolValue]; }
- (UIStatusBarStyle)topBarPrivateStatusBarStyle { return [[userDefaults objectForKey:@"topBarPrivateStatusBarStyle"] intValue]; }
- (BOOL)topBarPrivateTabBarTitleColorEnabled { return [[userDefaults objectForKey:@"topBarPrivateTabBarTitleColorEnabled"] boolValue]; }
- (CGFloat)topBarPrivateTabBarInactiveTitleOpacity { return [[userDefaults objectForKey:@"topBarPrivateTabBarInactiveTitleOpacity"] floatValue]; }
- (BOOL)topBarPrivateURLFontColorEnabled { return [[userDefaults objectForKey:@"topBarPrivateURLFontColorEnabled"] boolValue]; }
- (BOOL)topBarPrivateProgressBarColorEnabled { return [[userDefaults objectForKey:@"topBarPrivateProgressBarColorEnabled"] boolValue]; }
- (BOOL)topBarPrivateLockIconColorEnabled { return [[userDefaults objectForKey:@"topBarPrivateLockIconColorEnabled"] boolValue]; }
- (BOOL)topBarPrivateReloadButtonColorEnabled { return [[userDefaults objectForKey:@"topBarPrivateReloadButtonColorEnabled"] boolValue]; }
- (BOOL)bottomBarPrivateTintColorEnabled { return [[userDefaults objectForKey:@"bottomBarPrivateTintColorEnabled"] boolValue]; }
- (BOOL)bottomBarPrivateBackgroundColorEnabled { return [[userDefaults objectForKey:@"bottomBarPrivateBackgroundColorEnabled"] boolValue]; }
- (BOOL)tabTitleBarPrivateTextColorEnabled { return [[userDefaults objectForKey:@"tabTitleBarPrivateTextColorEnabled"] boolValue]; }
- (BOOL)tabTitleBarPrivateBackgroundColorEnabled { return [[userDefaults objectForKey:@"tabTitleBarPrivateBackgroundColorEnabled"] boolValue]; }

#endif

#endif

- (void)reloadOtherPlist
{
	otherPlist = [[NSDictionary alloc] initWithContentsOfFile:path(otherPlistPath)];
}

- (NSArray*)forceHTTPSExceptions
{
	return [otherPlist objectForKey:@"ForceHTTPSExceptions"];
}

- (BOOL)isURLOnHTTPSExceptionsList:(NSURL*)URL
{
	if(!URL)
	{
		return NO;
	}

	for(NSString* exception in [self forceHTTPSExceptions])
	{
		if([[URL host] rangeOfString:exception].location != NSNotFound)
		{
			//Exception list contains host -> return false
			return YES;
		}
	}

	return NO;
}

- (NSArray*)pinnedLocationNames
{
	return [otherPlist objectForKey:@"PinnedLocationNames"];
}

- (NSArray*)pinnedLocationPaths
{
	return [otherPlist objectForKey:@"PinnedLocationPaths"];
}

#if defined(NO_LIBCOLORPICKER)

- (BOOL)topBarNormalTintColorEnabled { return NO; }
- (UIColor*)topBarNormalTintColor { return nil; }
- (BOOL)topBarNormalBackgroundColorEnabled { return NO; }
- (UIColor*)topBarNormalBackgroundColor { return nil; }
- (BOOL)topBarNormalURLFontColorEnabled { return NO; }
- (UIColor*)topBarNormalURLFontColor { return nil; }
- (BOOL)topBarNormalProgressBarColorEnabled { return NO; }
- (UIColor*)topBarNormalProgressBarColor { return nil; }
- (BOOL)topBarNormalLockIconColorEnabled { return NO; }
- (UIColor*)topBarNormalLockIconColor { return nil; }
- (BOOL)topBarNormalReloadButtonColorEnabled { return NO; }
- (UIColor*)topBarNormalReloadButtonColor { return nil; }
- (BOOL)topBarNormalTabBarTitleColorEnabled { return NO; }
- (UIColor*)topBarNormalTabBarTitleColor { return nil; }
- (BOOL)bottomBarNormalTintColorEnabled { return NO; }
- (UIColor*)bottomBarNormalTintColor {  return nil;}
- (BOOL)bottomBarNormalBackgroundColorEnabled { return NO; }
- (UIColor*)bottomBarNormalBackgroundColor { return nil; }
- (BOOL)tabTitleBarNormalTextColorEnabled { return NO; }
- (UIColor*)tabTitleBarNormalTextColor { return nil; }
- (BOOL)tabTitleBarNormalBackgroundColorEnabled { return NO; }
- (UIColor*)tabTitleBarNormalBackgroundColor { return nil; }

- (BOOL)topBarPrivateTintColorEnabled { return NO; }
- (UIColor*)topBarPrivateTintColor { return nil; }
- (BOOL)topBarPrivateBackgroundColorEnabled { return NO; }
- (UIColor*)topBarPrivateBackgroundColor { return nil; }
- (BOOL)topBarPrivateURLFontColorEnabled { return NO; }
- (UIColor*)topBarPrivateURLFontColor { return nil; }
- (BOOL)topBarPrivateProgressBarColorEnabled { return NO; }
- (UIColor*)topBarPrivateProgressBarColor { return nil; }
- (BOOL)topBarPrivateLockIconColorEnabled { return NO; }
- (UIColor*)topBarPrivateLockIconColor { return nil; }
- (BOOL)topBarPrivateReloadButtonColorEnabled { return NO; }
- (UIColor*)topBarPrivateReloadButtonColor { return nil; }
- (BOOL)topBarPrivateTabBarTitleColorEnabled { return NO; }
- (UIColor*)topBarPrivateTabBarTitleColor { return nil; }
- (BOOL)bottomBarPrivateTintColorEnabled { return NO; }
- (UIColor*)bottomBarPrivateTintColor {  return nil;}
- (BOOL)bottomBarPrivateBackgroundColorEnabled { return NO; }
- (UIColor*)bottomBarPrivateBackgroundColor { return nil; }
- (BOOL)tabTitleBarPrivateTextColorEnabled { return NO; }
- (UIColor*)tabTitleBarPrivateTextColor { return nil; }
- (BOOL)tabTitleBarPrivateBackgroundColorEnabled { return NO; }
- (UIColor*)tabTitleBarPrivateBackgroundColor { return nil; }

#endif

@end
