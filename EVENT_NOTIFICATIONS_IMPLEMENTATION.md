# Event Notifications Implementation

## Summary
This document describes the event notification system that has been added to notify members about new events and when they are selected as representatives.

## Features Added

### 1. Notification for New Events
- When an event is created by the federation/president, all members receive a notification
- Notification contains event title and date
- Type: `EVENT_ADDED`

### 2. Notification for Member Selection
- When a president selects members as representatives for an event, those members receive a notification
- Notification contains the event name
- Type: `MEMBRE_EVENT_ADDED`

## Files Modified

### Backend

1. **UtilisateurDAO.java**
   - Added `getAllMembers()` method to retrieve all members with role 'MEMBRE'

2. **EvenementServlet.java**
   - Added imports for `NotificationDAO` and `UtilisateurDAO`
   - Added notification creation logic when a new event is created
   - Notifies all members about the new event

3. **SelectRepresentativesServlet.java**
   - Added imports for `NotificationDAO` and `UtilisateurDAO`
   - Added notification creation logic when members are selected as representatives
   - Notifies each selected member individually

### Frontend

1. **membre-dashboard.jsp**
   - Added `MEMBRE_EVENT_ADDED` to the notification type labels
   - Displays "Sélection Représentant" for this type

## Notification Types

| Type | Description | Trigger |
|------|-------------|---------|
| `CLUB_ACCEPTED` | Club integration accepted | When president accepts member's club request |
| `EVENT_ADDED` | New event created | When any event is created by federation/president |
| `MEMBRE_EVENT_ADDED` | Selected as representative | When president selects member for event |

## How It Works

### New Event Notification Flow
1. Federation/President creates an event
2. `EvenementServlet.doPost()` creates the event in the database
3. System retrieves all members using `utilisateurDAO.getAllMembers()`
4. For each member, a notification is created with:
   - Message: "Un nouvel événement a été ajouté : [Event Title] - [Date]"
   - Type: "EVENT_ADDED"

### Member Selection Notification Flow
1. President selects members as representatives for an event
2. `SelectRepresentativesServlet.doPost()` validates and adds participants
3. For each selected member, a notification is created with:
   - Message: "Vous avez été sélectionné comme représentant pour l'événement [Event Title]"
   - Type: "MEMBRE_EVENT_ADDED"

## User Experience

### For Members
- Members see a notification badge on their dashboard when they have unread notifications
- Clicking the notification button opens a modal showing all notifications
- New events show as "Nouvel Événement"
- Being selected as representative shows as "Sélection Représentant"
- Unread notifications are highlighted in blue

### For Presidents
- Presidents can select up to 2 representatives for events
- Selected members automatically receive notifications
- Presidents see success message after selection

## Technical Details

### Database Operations
- Notifications are stored in the `Notification` table
- Each notification links to a member via `membre_id`
- Notifications have a `lu` (read) status for tracking
- Notifications include a `type` field for categorization

### Error Handling
- Notification creation failures are logged but don't affect the main operation
- Exceptions are caught and logged to prevent disruption

## Testing

To test the notifications:

1. **Test New Event Notification:**
   - Log in as federation or president
   - Create a new event
   - Log in as a member
   - Check if notification appears in dashboard

2. **Test Member Selection Notification:**
   - Log in as a president with a club
   - Go to an event and select representatives
   - Log in as the selected member
   - Check if notification appears

## Future Enhancements

- Add notification for event updates
- Add email notifications option
- Add push notifications for real-time updates
- Add notification preferences in user settings
- Add ability to delete individual notifications

