sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"ns/studentportal/test/integration/pages/StudentsList",
	"ns/studentportal/test/integration/pages/StudentsObjectPage",
	"ns/studentportal/test/integration/pages/FeesObjectPage"
], function (JourneyRunner, StudentsList, StudentsObjectPage, FeesObjectPage) {
    'use strict';

    var runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('ns/studentportal') + '/test/flp.html#app-preview',
        pages: {
			onTheStudentsList: StudentsList,
			onTheStudentsObjectPage: StudentsObjectPage,
			onTheFeesObjectPage: FeesObjectPage
        },
        async: true
    });

    return runner;
});

