import EventKit
import Foundation

// Prints "<minutes-until>|<title>" for the next upcoming, non-all-day event
// within the next 24h, or nothing. Calendar access is requested on first run
// (which is why this lives in a .app bundle with a usage description).

let store = EKEventStore()
let sem = DispatchSemaphore(value: 0)
var granted = false

if #available(macOS 14.0, *) {
    store.requestFullAccessToEvents { ok, _ in granted = ok; sem.signal() }
} else {
    store.requestAccess(to: .event) { ok, _ in granted = ok; sem.signal() }
}
_ = sem.wait(timeout: .now() + 10)
guard granted else { exit(1) }

let now = Date()
let end = now.addingTimeInterval(24 * 3600)
let pred = store.predicateForEvents(withStart: now, end: end, calendars: nil)
let events = store.events(matching: pred)
    .filter { !$0.isAllDay && $0.startDate >= now && $0.status != .canceled }
    .sorted { $0.startDate < $1.startDate }

if let e = events.first {
    let mins = Int(e.startDate.timeIntervalSince(now) / 60)
    let title = (e.title ?? "Meeting").replacingOccurrences(of: "|", with: "/")
    print("\(mins)|\(title)")
}
