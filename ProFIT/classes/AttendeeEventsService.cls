public with sharing class AttendeeEventsService {
    @AuraEnabled(cacheable = true)
    //Returns a list of Event_Attendee where Attendee is equal to record ID, Start Date is in the future, and Live is checked.
    public static List<Event_Attendee__c> upcomingEvents(String attendeeId) {
      List<Event_Attendee__c> eventLists = [
        SELECT
          Id,
          Name,
          Event__c,
          Event__r.Name,
          Event__r.Event_Type__c,
          Event__r.Location__c,
          Event__r.Location__r.Name,
          Event__r.Organizer__c,
          Event__r.Organizer__r.Name,
          Event__r.Name__c,
          Event__r.Start_Date_Time__c,
          Event__r.End_Date_Time__c,
          Event__r.Max_Seats__c,
          Event__r.Remaining_Seats__c
        FROM Event_Attendee__c
        WHERE
          Attendee__c = :attendeeId
          AND Event__r.Start_Date_Time__c >= today
          AND Event__r.Live__c = true
      ];
      return eventLists;
    }
  
    @AuraEnabled(cacheable = true)
    //Returns a list of Event_Attendee where Attendee is equal to record ID, and Start Date is in the past.
    public static List<Event_Attendee__c> pastEvents(String attendeeId) {
      List<Event_Attendee__c> eventLists = [
        SELECT
          Id,
          Name,
          Event__c,
          Event__r.Name,
          Event__r.Event_Type__c,
          Event__r.Location__c,
          Event__r.Location__r.Name,
          Event__r.Organizer__c,
          Event__r.Organizer__r.Name,
          Event__r.Name__c,
          Event__r.Start_Date_Time__c,
          Event__r.End_Date_Time__c,
          Event__r.Max_Seats__c,
          Event__r.Remaining_Seats__c
        FROM Event_Attendee__c
        WHERE Attendee__c = :attendeeId AND Event__r.Start_Date_Time__c < today
      ];
      return eventLists;
    }
  }