import { LightningElement, api} from 'lwc';

export default class ChildComp extends LightningElement {
    @api headerLabel = 'This Label is from ChildComp.js';
}