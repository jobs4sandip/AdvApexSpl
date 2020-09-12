import { LightningElement , api} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent' ;

import CONTACT_OBJECT from '@salesforce/schema/Contact';
import FIRSTNAME_FIELD  from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';

export default class ContactCreator extends LightningElement {
    @api recordId;
    fieldApis =[FIRSTNAME_FIELD , LASTNAME_FIELD , EMAIL_FIELD ];
    handleSuccess(event){

        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Contact Create',
                message: 'Record created successfully : '+ event.detail.id,
                variant: 'Success'

            })
        );
    }
}