using university as u from '../db/schema';

service StudentPortalService {
  @odata.draft.enabled
  entity Students   as projection on u.Student
  actions{
    action sendFeeReminder() returns Students;
    action promote() returns Students;
  };
  entity Fees       as projection on u.Fee;
  entity Results    as projection on u.Result;
  entity Documents  as projection on u.Document;

  // action sendFeeReminder() returns Students;
  // action promote(studentId: String) returns String;
}