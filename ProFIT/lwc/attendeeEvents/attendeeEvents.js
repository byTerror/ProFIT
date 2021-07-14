import { LightningElement, api, track, wire } from 'lwc';
import upcomingEvents from '@salesforce/apex/AttendeeEventsService.upcomingEvents';
import pastEvents from '@salesforce/apex/AttendeeEventsService.pastEvents';

export default class AttendeeEvents extends LightningElement {
    
    @api recordId;
    @track eventCol = [
        {
            label: 'Event ID',
            fieldName: 'eventId',
            type: 'text',
            sortable: true
        },
        {
            label: 'Event Name',
            fieldName: 'eventName',
            type: 'text',
            sortable: true
        },
        {
            label: 'Event Organizer name',
            fieldName: 'eventOrganizer',
            type: 'text',
            sortable: true
        },
        {
            label: 'Event Start Date',
            fieldName: 'eventStartDate',
            type: 'date',
            typeAttributes: {
                weekday: 'long',
                day: 'numeric',
                month: 'short',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
              },
            sortable: true
        },
        {
            label: 'Event End Date',
            fieldName: 'eventEndDate',
            type: 'date',
            typeAttributes: {
                weekday: 'long',
                day: 'numeric',
                month: 'short',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                hour12: true
              },
            sortable: true
        },
        {
            label: 'Event Type',
            fieldName: 'eventType',
            type: 'text',
            sortable: true
        },
        {
            label: 'Event Location',
            fieldName: 'eventLocation',
            type: 'text',
            sortable: true
        }
    ];

    @track error;
    @track upcomingEventsList;
    @wire(upcomingEvents, {attendeeId : '$recordId'})
    wiredUpcomingEvents({error,data}){
        if(data){
            this.upcomingEventsList = data.map(row=>{
                var location;
                var evtType;
                if(row.Event__r.Location__c == null){
                    location = '---------------';
                    evtType = 'Virtual';
                }
                else
                {
                    location = row.Event__r.Location__r.Name;
                    evtType = row.Event__r.Event_Type__c;
                }
                let tmpObj = {
                    eventId : row.Event__r.Name, 
                    eventName : row.Event__r.Name__c, 
                    eventOrganizer : row.Event__r.Organizer__r.Name, 
                    eventStartDate : row.Event__r.Start_Date_Time__c, 
                    eventEndDate : row.Event__r.End_Date_Time__c, 
                    eventLocation : location, 
                    eventType : evtType
                };
                return {...tmpObj, tmpObj};
            })
        }
    }

    @track pastEventsList;
    @wire(pastEvents, {attendeeId : '$recordId'})
    wiredPastEvents({error,data}){
        if(data){
            this.pastEventsList = data.map(row=>{
                var location;
                var evtType;
                if(row.Event__r.Location__c == null){
                    location = '---------------';
                    evtType = 'Virtual';
                }
                else
                {
                    location = row.Event__r.Location__r.Name;
                    evtType = row.Event__r.Event_Type__c;
                }
                let tmpObj = {
                    eventId : row.Event__r.Name, 
                    eventName : row.Event__r.Name__c, 
                    eventOrganizer : row.Event__r.Organizer__r.Name, 
                    eventStartDate : row.Event__r.Start_Date_Time__c, 
                    eventEndDate : row.Event__r.End_Date_Time__c, 
                    eventLocation : location, 
                    eventType : row.Event__r.Event_Type__c
                };
                return {...tmpObj, tmpObj};
            })
        }
    }

}