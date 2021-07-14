@isTest
public with sharing class EventDetailsController_Test {
    //Creates a Test Event. Returns the Event ID
    static Id createTestEvent(){
        Event__c evt = new Event__c();
        evt.Name__c = 'Test Event';
        evt.Max_Seats__c = 100;
        evt.Live__c = true;
        evt.Start_Date_Time__c = datetime.newInstance(2021, 7, 21, 19, 30, 0);
        evt.End_Date_Time__c = datetime.newInstance(2021, 7, 22, 19, 30, 0);
        Database.insert(evt);
        return evt.Id;
    }
    //Creates a Test Speaker. Returns the Speaker ID
    static Id createTestSpeaker(){
        Speaker__c spk = new Speaker__c();
        spk.Name = 'Test Speaker';
        Database.insert(spk);
        return spk.Id;
    }
    //Creates a Test Attendee. Returns the Attendee ID
    static Id createTestAttendee(){
        Attendee__c att = new Attendee__c();
        att.Name = 'Test Attendee';
        Database.insert(att);
        return att.Id;
    }
    @IsTest
    //Test if there is a speaker in the Event_Speaker object
    static void testSpeaker(){
        
        Test.startTest();
        String recId;
        Event_Speaker__c eS = new Event_Speaker__c();
        eS.Event__c = createTestEvent();
        eS.Speaker__c = createTestSpeaker();
        Event_Speaker__c name;
        String str = '';
        Database.insert(eS);
        List<Event_Speaker__c> retrievedSpeaker = EventDetailsController.getSpeakers(eS.Event__c);
        name = retrievedSpeaker.get(0);
        Test.stopTest();
        System.assertEquals('Test Speaker',name.Speaker__r.Name);
    }
    @IsTest
    //Test if there is a location in the Event object
    static void testLocation(){
        Test.startTest();
        String recId = createTestEvent();
        Event__c evts = EventDetailsController.getLocationDetails(recId);
        Test.stopTest();
        System.assertEquals('Test Event',evts.Name__c);
    }
    @isTest
    //Test if there is a attendee in the Event_Attendee object
    static void testAttendee(){
        Test.startTest();
        Event_Attendee__c eA = new Event_Attendee__c();
        eA.Attendee__c = createTestAttendee();
        eA.Event__c = createTestEvent();
        Database.insert(eA);
        Event_Attendee__c name;
        List<Event_Attendee__c> retrievedAttendee = EventDetailsController.getAttendees(eA.Event__c);
        name = retrievedAttendee.get(0);
        
        Test.stopTest();
        System.assertEquals('Test Attendee', name.Attendee__r.Name);
    }
}