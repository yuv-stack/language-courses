
@IsTest
private class TestLanguageCourseTrigger {

    // Creates a parent instructor record.
    private static Language_Course_Instructor__c createInstructor() {
        Language_Course_Instructor__c instructor =
            new Language_Course_Instructor__c(
                Name = 'Rahul Sharma',
                Email__c = 'rahul@example.com',
                Phone__c = '9876543210',
                Experience_Years__c = 5,
                Specialization__c = 'English'
            );

        insert instructor;
        return instructor;
    }

    // Creates a child course linked to an instructor.
    private static Language_Course__c createCourse(Id instructorId) {
        Language_Course__c course =
            new Language_Course__c(
                Name = 'English',
                Language_Course_Instructor__c = instructorId
            );

        insert course;
        return course;
    }

    @IsTest
    static void testAfterInsert() {
        Language_Course_Instructor__c instructor = createInstructor();

        Test.startTest();

        Language_Course__c course = new Language_Course__c(
            Name = 'French',
            Language_Course_Instructor__c = instructor.Id
        );

        insert course;

        System.assertEquals(
            1,
            Limits.getEmailInvocations(),
            'Insert should invoke the email operation once.'
        );

        Test.stopTest();
    }
@IsTest
static void testAfterUpdate() {
    Language_Course_Instructor__c instructor = createInstructor();
    Language_Course__c course = createCourse(instructor.Id);

    Test.startTest();

    // Update only the Name field.
    // Do not include the Master-Detail field.
    Language_Course__c courseToUpdate =
        new Language_Course__c(
            Id = course.Id,
            Name = 'Advanced English'
        );

    update courseToUpdate;

    System.assertEquals(
        1,
        Limits.getEmailInvocations(),
        'Update should invoke the email operation once.'
    );

    Test.stopTest();
}

    @IsTest
    static void testAfterDelete() {
        Language_Course_Instructor__c instructor = createInstructor();
        Language_Course__c course = createCourse(instructor.Id);

        Test.startTest();

        delete course;

        System.assertEquals(
            1,
            Limits.getEmailInvocations(),
            'Delete should invoke the email operation once.'
        );

        Test.stopTest();
    }
}
