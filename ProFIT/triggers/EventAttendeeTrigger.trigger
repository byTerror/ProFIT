trigger EventAttendeeTrigger on Event_Attendee__c (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        EventAttendeeClass.EventAttendeeSendEmail(Trigger.new);
    }
}