import { LightningElement , wire, track} from 'lwc';
import { getRecord , getFieldValue } from 'lightning/uiRecordApi';

import USER_ID from '@salesforce/user/Id';
import USER_NAME from '@salesforce/schema/User.Name';
const fields =[USER_NAME];

export default class Selector extends LightningElement {
    selectedProductId;
    
    @track userid = USER_ID;

    //I tried below but this does not work with any of those options line 16/17.
    @wire(getRecord , {recordId: '$userid' , fields: fields})
    userrecord;
    
    get name() {
        return getFieldValue(this.userrecord.data, USER_NAME);
    }
    
    
    //name = getFieldValue(this.userrecord.data, USER_NAME);
    
    /*
    @wire( getRecord , {recordId: USER_ID , fields: fields}) 
    userrecord ({data,error}){
        if(data){
            this.name = data.fields.Name.value;
        }
        if(error){

        }
    }
    */
    handleProductSelected(evt) {
        this.selectedProductId = evt.detail;
    }

    

}