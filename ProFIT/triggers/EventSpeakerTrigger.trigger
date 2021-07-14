trigger EventSpeakerTrigger on Event_Speaker__c (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        EventSpeakerValidation.checkDuplicate(Trigger.new);
    }
}