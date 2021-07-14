import { LightningElement, api, track, wire } from 'lwc';
import getSpeakers from '@salesforce/apex/EventDetailsController.getSpeakers';
import getLocationDetails from '@salesforce/apex/EventDetailsController.getLocationDetails';
import getAttendees from '@salesforce/apex/EventDetailsController.getAttendees';
import userId from "@salesforce/user/Id";
import { getRecord } from "lightning/uiRecordApi";
import profile from "@salesforce/schema/User.Profile.Name";

export default class EventDetails extends LightningElement {
    @api speaker;
    @api eventId;
    @api recordId;
    @track speakerList;
    @track eventRec;
    @track attendeesList;
    @track columnAtt = [
      {
        label: "Name",
        fieldName: "attName",
        cellAttributes: {
          iconName: "standard:user",
          iconPosition: "left"
        }
      },
      { label: "Email", 
        fieldName: "attEmail", 
        type: "email" 
      },
      { label: "Company Name", 
        fieldName: "attCompany" 
      },
      {
        label: "Location",
        fieldName: "attLocation",
        cellAttributes: {
          iconName: "utility:location",
          iconPosition: "left"
        }
      }
    ];
    errors;
    user_id = userId;

    @wire(getRecord, { recordId: "$user_id", fields: [profile] })
    wiredMethod({ error, data }) {
      if (data) {
        window.console.log(" userRecord ", data);
      }
      if (error) {
        console.log("Error Occurred ", JSON.stringify(error));
      }
    }

    errors;

    @wire(getSpeakers, {eventId : '$recordId'})
    wireGetSpeakers({error, data}){
      if(data){
        this.speakerList = data;
      }
      else{
        this.errors = error;
        console.log(this.errors);
      }
    }

    @wire(getLocationDetails, {eventId : '$recordId'})
    wireGetLocation({error, data}){
      if(data){
        this.eventRec = data;
      }
      else{
        this.errors = error;
        console.log(this.errors);
      }
    }

    @wire(getAttendees, {eventId : '$recordId'})
    wireGetAttendees({error, data}){
      if(data){
        this.attendeesList = data.map(row=>{
          let tmpObj = {
            attName : row.Attendee__r.Name,
            attEmail : row.Attendee__r.Email__c,
            attCompany : row.Attendee__r.Company_Name__c,
            attLocation : row.Attendee__r.Address__r.Name
          };
          return {...tmpObj, tmpObj};
        })
      }
    }
}