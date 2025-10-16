using StudentPortalService as service from '../../srv/service';
annotate service.Students with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'studentId',
                Value : studentId,
            },
            {
                $Type : 'UI.DataField',
                Label : 'name',
                Value : name,
            },
            {
                $Type : 'UI.DataField',
                Label : 'email',
                Value : email,
            },
            {
                $Type : 'UI.DataField',
                Label : 'department',
                Value : department,
            },
            {
                $Type : 'UI.DataField',
                Label : 'year',
                Value : year,
            },
            {
                $Type : 'UI.DataField',
                Label : 'promotion',
                Value : promotion,
            },
            {
                $Type : 'UI.DataField',
                Value : results.student_studentId,
                Label : 'student_studentId',
            },
            {
                $Type : 'UI.DataField',
                Value : results.semester,
                Label : 'semester',
            },
            {
                $Type : 'UI.DataField',
                Value : results.subject,
                Label : 'subject',
            },
            {
                $Type : 'UI.DataField',
                Value : results.grade,
                Label : 'grade',
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Fee Details',
            ID : 'FeeDetails',
            Target : 'fees/@UI.LineItem#FeeDetails',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Result',
            ID : 'Result',
            Target : 'results/@UI.LineItem#Result',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'studentId',
            Value : studentId,
        },
        {
            $Type : 'UI.DataField',
            Label : 'name',
            Value : name,
        },
        {
            $Type : 'UI.DataField',
            Label : 'email',
            Value : email,
        },
        {
            $Type : 'UI.DataField',
            Label : 'department',
            Value : department,
        },
        {
            $Type : 'UI.DataField',
            Label : 'year',
            Value : year,
        },
        {
            $Type : 'UI.DataField',
            Value : promotion,
            Label : 'promotion',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'StudentPortalService.sendFeeReminder',
            Label : 'sendFeeReminder',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'StudentPortalService.promote',
            Label : 'promote',
        },
    ],
);

annotate service.Fees with @(
    UI.LineItem #FeeDetails : [
        {
            $Type : 'UI.DataField',
            Value : student_studentId,
            Label : 'student_studentId',
        },
        {
            $Type : 'UI.DataField',
            Value : amount,
            Label : 'amount',
        },
        {
            $Type : 'UI.DataField',
            Value : dueDate,
            Label : 'dueDate',
        },
        {
            $Type : 'UI.DataField',
            Value : status,
            Label : 'status',
            Criticality : criticality,
            CriticalityRepresentation : #WithIcon,
        },
    ]
);

annotate service.Results with @(
    UI.LineItem #Result : [
        {
            $Type : 'UI.DataField',
            Value : ID,
            Label : 'ID',
        },
        {
            $Type : 'UI.DataField',
            Value : grade,
            Label : 'grade',
        },
        {
            $Type : 'UI.DataField',
            Value : semester,
            Label : 'semester',
        },
        {
            $Type : 'UI.DataField',
            Value : student_studentId,
            Label : 'student_studentId',
        },
        {
            $Type : 'UI.DataField',
            Value : subject,
            Label : 'subject',
        },
    ]
);

