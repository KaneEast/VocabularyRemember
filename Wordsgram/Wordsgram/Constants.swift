//
//  Constants.swift
//  Wordsgram
//
//  Created by Kane on 2023/11/21.
//

import typealias Foundation.TimeInterval
import struct CoreGraphics.CGFloat

extension CGFloat {
  // MARK: Appearance
  static let blurRadius: CGFloat = 5
  static let minDragTranslationForSwipe: CGFloat = 50
}

extension Int {
  // MARK: Video playback
  static let videoPlaybackProgressTrackingInterval = 5
}

extension String {
  static let downloads = "Downloads"
  static let filters = "Filters"
  static let library = "Library"
  static let loading = "Loading..."
  static let myTutorials = "My Tutorials"
  static let newest = "Newest"
  static let popularity = "Popularity"
  static let resetFilters = "Clear all"
  static let search = "Search…"
  static let books = "Books"
  static let genres = "Genres"
  static let settings = "Settings"
  static let tutorials = "Tutorials"

  // MARK: Detail View
  static let detailContentLockedCosPro = "Upgrade your account to watch this and other locked courses"

  // MARK: Messaging
  static let bookmarkCreated = "Content bookmarked successfully."
  static let bookmarkDeleted = "Bookmark removed successfully."
  static let bookmarkCreatedError = "There was a problem creating the bookmark"
  static let bookmarkDeletedError = "There was a problem deleting the bookmark"
  
  static let progressRemoved = "Progress removed successfully."
  static let progressMarkedAsComplete = "Content marked as complete."
  static let progressRemovedError = "There was a problem removing progress."
  static let progressMarkedAsCompleteError = "There was a problem marking content as complete."
  
  static let downloadRequestedButQueueInactive = "Download will begin when WiFi available."
  static let downloadNotPermitted = "Download not permitted."
  static let downloadContentNotFound = "Invalid download request."
  static let downloadRequestProblem = "Problem requesting download."
  static let downloadCancelled = "Download cancelled."
  static let downloadDeleted = "Download deleted."
  static let downloadReset = "Download reset."
  static let downloadUnspecifiedProblem = "Problem with download action."
  static let downloadUnableToCancel = "Unable to cancel download."
  static let downloadUnableToDelete = "Unable to delete download."
  
  static let simultaneousStreamsError = "You can only stream on one device at a time."
  
  static let downloadedContentNotFound = "Unable to find download."
  
  static let videoPlaybackCannotStreamWhenOffline = "Cannot stream video when offline."
  static let videoPlaybackInvalidPermissions = "You don't have the required permissions to view this video."
  static let videoPlaybackExpiredPermissions = "Download expired. Please reconnect to the internet to re-verify."
  
  static let appIconUpdatedSuccessfully = "You app icon has been updated!"
  static let appIconUpdateProblem = "There was a problem updating the app icon."

  // MARK: On-boarding
  static let login = "Login"

  // MARK: Other
  static let today = "Today"
  static let by = "By"
  static let yes = "Yes"
  static let no = "No" // swiftlint:disable:this identifier_name

  // MARK: Settings screens
  static let settings1 = "settings 1"
  static let settings2 = "settings 2"
  static let settings3 = "settings 3"
  static let libraries = "Libraries"
}

extension TimeInterval {
  // MARK: Message Banner
  static let autoDismissTime: Self = 3

  // MARK: Video playback
  static let videoPlaybackOfflinePermissionsCheckPeriod: Self = 7 * 24 * 60 * 60
}

enum LookupKey {
  static let requestReview = "request"
}
