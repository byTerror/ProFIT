@IsTest
public with sharing class AttendeeEventsService_Test {
    //Create a new test Event__c with event date in the upcoming future, and live is checked. Returns the Id
    static Id createTestNewEvent(){
        Event__c evt = new Event__c();
        evt.Name__c = 'Test Event';
        evt.Start_Date_Time__c = datetime.newInstance(2021, 7, 21, 19, 30, 0);
        evt.End_Date_Time__c = datetime.newInstance(2021, 7, 22, 19, 30, 0);
        evt.Max_Seats__c = 100;
        evt.Live__c = true;
        Database.insert(evt);
        return evt.Id;
    }
    //Create a new test Event__c with the event already in the past. Returns the Id
    static Id createTestOldEvent(){
        Event__c evt = new Event__c();
        evt.Name__c = 'Test Event';
        evt.Start_Date_Time__c = datetime.newInstance(2021, 3, 21, 19, 30, 0);
        evt.End_Date_Time__c = datetime.newInstance(2021, 3, 22, 19, 30, 0);
        evt.Max_Seats__c = 100;
        evt.Live__c = false;
        Database.insert(evt);
        return evt.Id;
    }
    //Creates a new test Attendee__c. Returns the
    static Id createTestAttendee(){
        Attendee__c att = new Attendee__c();
        att.Name = 'Test Attendee';
        Database.insert(att);
        return att.Id;
    }
    @isTest
    //Test if there is 'Test Event' value in the Event_Attendee__c in the upcomingEvents()
    static void testUpcomingEvents(){
        Test.startTest();
        Event_Attendee__c eA = new Event_Attendee__c();
        eA.Event__c = createTestNewEvent();
        eA.Attendee__c = createTestAttendee();
        Database.insert(eA);
        Event_Attendee__c name;
        List<Event_Attendee__c> retrievedAttendee = AttendeeEventsService.upcomingEvents(eA.Attendee__c);
        name = retrievedAttendee.get(0);
        
        Test.stopTest();
        System.assertEquals('Test Event',name.Event__r.Name__c);
    }
    @isTest
    //Test if there is 'Test Event' value in the Event_Attendee__c in the pastEvents()
    static void testPastEvents(){
        Test.startTest();
        Event_Attendee__c eA = new Event_Attendee__c();
        eA.Event__c = createTestOldEvent();
        eA.Attendee__c = createTestAttendee();
        
        Database.insert(eA);
        Event_Attendee__c name;
        List<Event_Attendee__c> retrievedAttendee = AttendeeEventsService.pastEvents(eA.Attendee__c);
        name = retrievedAttendee.get(0);
        
        Test.stopTest();
        System.assertEquals('Test Event',name.Event__r.Name__c);
    }
}