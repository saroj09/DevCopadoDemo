import { LightningElement, track } from 'lwc';

export default class TrackChildComp extends LightningElement {
    @track greeting;
    changeHandler(event) {
        this.greeting = event.target.value;
    }
}