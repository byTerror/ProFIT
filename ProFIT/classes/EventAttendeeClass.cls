public with sharing class EventAttendeeClass {
    //Sends an email notification to the Attendee when a new Event_Attendee record is created.
    public static void EventAttendeeSendEmail(List<Event_Attendee__c> newAttendeeList) {
        try {            
            for(Event_Attendee__c esRecord : newAttendeeList){
                //Obtains, and assigns the ID of each object from the Event_Attendee object
                Id attendeeId = (Id)esRecord.get('Attendee__c');
                Id eventId = (Id)esRecord.get('Event__c');
                
                //Obtains the following fields from each object, and stores it into a Map.
                Map<Id, Attendee__c> attendeeMap = new Map<Id, Attendee__c>([SELECT ID, Name, Email__c FROM Attendee__c WHERE Id =: attendeeId]);
                Map<Id, Event__c > eventMap = new Map<Id, Event__c> ([Select Id, Name__c, Start_Date_Time__c, Organizer__c , Organizer__r.Name, Location__c , Location__r.Name, Location__r.City__c, Location__r.State__c, Location__r.Country__c, Location__r.Postal_Code__c, Location__r.Street__c FROM Event__c  where ID =: eventId]);

                //Obtains the Id from the Map, and stores it into each custom object.
                Attendee__c attendeeRec = attendeeMap.get(esRecord.Attendee__c);
                Event__c eventRec = eventMap.get(esRecord.Event__c);
                // System.debug(attendeeRec);
                
                //Initializes a single email message
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                
                //Sets the subject line for the email
                message.setSubject('Pass for the ' + eventRec.Name__c);
                System.debug('Pass for the ' + eventRec.Name__c);
                
                //Initalizes a list of string, and adds the email account of the attendee to list. Once there is an email in the list, the recipient of the email will be the attendee.
                List<String> emailAdd = new List<String>();
                emailAdd.add(attendeeRec.Email__c);
                System.debug(attendeeRec.Email__c);
                message.setToAddresses(emailAdd);

                //Sets the name of the sender to the Event Organizer.
                message.setSenderDisplayName(eventRec.Organizer__r.Name);
                
                //Sets the message of the email itself.
                String linkForLocation = '<a href="https://www.google.com/maps/place'+eventRec.Location__r.Street__c+' '+eventRec.Location__r.City__c+' '+eventRec.Location__r.State__c+' '+eventRec.Location__r.Country__c+' '+eventRec.Location__r.Postal_Code__c+'"'+'target="_blank">Here</a>';
                
                String body = 'Dear '+attendeeRec.Name+',<br/>Thank you for registering for <strong>'+eventRec.Name__c+'</strong> which will be Organized on <strong>'+eventRec.Start_Date_Time__c+'</strong> & will be held in <strong>'+eventRec.Location__r.Name+'</strong>. We are excited to have you, see you in the event.<br/><br/>Find the Google Map Location for the Event Here.<br/>'+linkForLocation+'<br/>Thanks,<br/><strong>'+eventRec.Organizer__r.Name+'</strong>';
                
                message.setHtmlBody(body);
                
                //Stores the List of SingleEmailMessage message into an array, then it sends an email to the attendee.
                Messaging.SingleEmailMessage[] messages = 
                new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

                //Checks if the first index of results array is a success.
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: '
                    + results[0].errors[0].message);
                }            
                
            }
        } catch (Exception ex) {
            System.debug('The following exception has occurred: ' + ex.getMessage());
        }
    }
}