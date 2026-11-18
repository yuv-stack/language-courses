
trigger LanguageCourseTrigger on Language_Course__c (
    after insert,
    after update,
    after delete
) {
    // Identify the operation
    String operation;

    if (Trigger.isInsert) {
        operation = 'created';
    } else if (Trigger.isUpdate) {
        operation = 'updated';
    } else {
        operation = 'deleted';
    }

    // Get affected records
    List<Language_Course__c> affectedCourses =
        Trigger.isDelete ? Trigger.old : Trigger.new;

    // Prepare course names
    List<String> courseNames = new List<String>();

    for (Language_Course__c course : affectedCourses) {
        courseNames.add(course.Name);
    }

    // Prepare email
    Messaging.SingleEmailMessage email =
        new Messaging.SingleEmailMessage();

    email.setToAddresses(
        new List<String>{'yamech.engg@gmail.com'}
    );

    email.setSubject(
        'Language Course Records ' + operation
    );

    email.setPlainTextBody(
        'The following language courses were ' +
        operation + ':\n\n' +
        String.join(courseNames, '\n')
    );

    // Send one email per trigger execution
    Messaging.sendEmail(
        new List<Messaging.SingleEmailMessage>{email},
        false
    );
}
