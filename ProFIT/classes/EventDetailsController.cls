public with sharing class EventDetailsController {
    @AuraEnabled(cacheable = true)
    public static List<Event_Speaker__c> getSpeakers(String eventId){
        try {
            List<Event_Speaker__c> speakerLst = [Select Id, Name, Speaker__r.Name, Speaker__r.Email__c, Speaker__r.Phone__c, Speaker__r.Company__c from Event_Speaker__c where Event__c =: eventId];

            return speakerLst;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable = true) 
    public static Event__c getLocationDetails(String eventId){
        try {
            Event__c eventRec = [Select Id, Name__c, Location__r.Name, Location__c, Location__r.City__c, Location__r.Country__c, Location__r.Landmark__c, Location__r.Postal_Code__c, Location__r.State__c, Location__r.Street__c from Event__c where Id =: eventId];
            
            return eventRec;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled(cacheable = true) 
    public static List<Event_Attendee__c> getAttendees(String eventId){
        try {
            List<Event_Attendee__c> evtAttLst = [Select Id, Name, Attendee__r.Name, Attendee__r.Email__c, Attendee__r.Address__c, Attendee__r.Address__r.Name, Attendee__r.Company_Name__c, Attendee__r.Phone__c, Event__r.Start_Date_Time__c, Event__r.End_Date_Time__c, Event__r.Max_Seats__c, Event__r.Remaining_Seats__c from Event_Attendee__c where Event__c =: eventId];

            return evtAttLst;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }  
}