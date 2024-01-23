trigger CaseTrigger on Case (before insert) {

    switch on Trigger.OperationType{
        when BEFORE_INSERT, BEFORE_UPDATE{

        }
        when AFTER_INSERT{

        }
    }

}