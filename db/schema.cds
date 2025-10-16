namespace university;

entity Student {
  key studentId : String(10);
  name          : String(100);
  email         : String(100);
  department    : String(50);
  year          : Integer;
  promotion     : String(20);
  fees          : Composition of many Fee on fees.student = $self;
  results       : Composition of many Result on results.student = $self;
  documents     : Composition of many Document on documents.student = $self;
}

entity Fee {
  key ID              : UUID;
  student             : Association to Student;
  type                : String(50);
  amount              : Decimal(10,2);
  status              : String(20);
  dueDate             : Date;
  criticality         : Integer;
}

entity Result {
  key ID              : UUID;
  student             : Association to Student;
  subject             : String(50);
  grade               : String(2);
  semester            : Integer;
}

entity Document {
  key ID              : UUID;
  student             : Association to Student;
  docType             : String(50);
  fileUrl             : String(200);
}