@IsTest
private class EventAttendeeClass_Test {
    @IsTest
    static void updateValues() {
        Test.startTest();
        
        Event_Organizer__c evtOrgTest = new Event_Organizer__c();
        evtOrgTest.Name = 'Sample Event Organizer';
        evtOrgTest.Phone__c = '112233445566';
        evtOrgTest.Email__c = 'sampleeventorganizer@mail.com';
        evtOrgTest.Alternative_Phone__c = '112233445566';
        evtOrgTest.Alternative_Email__c = 'sampleeventorganizer@mail.com';
        Database.insert(evtOrgTest);

        Event__c eventTest = new Event__c();
        eventTest.Name__c = 'Sample Event';
        eventTest.Organizer__c = evtOrgTest.Id;
        eventTest.Max_Seats__c = 100;
        eventTest.Live__c = true;
        eventTest.Start_Date_Time__c = System.now();
        eventTest.End_Date_Time__c = System.now().addDays(1);
        Database.insert(eventTest);

        Attendee__c attendeeTest = new Attendee__c();
        attendeeTest.Name = 'Sample Attendee';
        attendeeTest.Email__c = 'charlesjustin1998@gmail.com';
        attendeeTest.Phone__c = '65544332211';
        Database.insert(attendeeTest);

        Event_Attendee__c evtAttTest = new Event_Attendee__c();
        evtAttTest.Event__c = eventTest.Id;
        evtAttTest.Attendee__c = attendeeTest.Id;
        Database.insert(evtAttTest);

        try{
            integer i = 10/0;
        }
        catch(Exception ex){
            
        }
        Test.stopTest();
        

    }
}