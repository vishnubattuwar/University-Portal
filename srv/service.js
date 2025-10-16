require('dotenv').config();
const cds = require('@sap/cds');
const nodemailer = require('nodemailer');

module.exports = (srv) => {
  const { Students, Fees, Results } = srv.entities;

  // 🟡 Auto-calc criticality for Fees
  srv.after('READ', Fees, each => {
    if (!each.status) return;
    const today = new Date();
    const due = each.dueDate ? new Date(each.dueDate) : null;

    if (each.status === 'Paid') {
      each.criticality = 3; // Green
    } else if (each.status === 'Pending' && due && due >= today) {
      each.criticality = 2; // Yellow
    } else if (each.status === 'Pending' && due && due < today) {
      each.criticality = 1; // Red
    } else {
      each.criticality = 2;
    }
  });

  // 🟢 Helper: Send Email Reminder
  async function sendReminderEmail(student, fee) {
    if (!process.env.EMAIL_USER || !process.env.EMAIL_PASS) {
      cds.log('warn', 'EMAIL_USER/EMAIL_PASS not set — skipping actual email send (dev mode)');
      return;
    }

    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS
      }
    });

    const mailOptions = {
      from: process.env.EMAIL_USER,
      to: student.email,
      subject: 'Fee Payment Reminder',
      text: `Dear ${student.name},

You have a pending fee of ₹${fee.amount} for ${fee.type}.
Please pay before ${fee.dueDate}.

Regards,
University`
    };

    await transporter.sendMail(mailOptions);
  }

  // 🟩 BOUND Action: sendFeeReminder (Reads studentId automatically)
  srv.on('sendFeeReminder', 'Students', async (req) => {
    try {
      const { studentId } = req.params[0]; // Auto-fetch selected studentId
      if (!studentId) return 'Student ID missing in selected record.';

      const student = await SELECT.one.from(Students).where({ studentId });
      if (!student) return `No student found for ID: ${studentId}`;

      const fee = await SELECT.one.from(Fees).where({ student_studentId: studentId, status: 'Pending' });
      if (!fee) return `No pending fee found for ${student.name}`;

      await sendReminderEmail(student, fee);

      return `📧 Reminder email sent to ${student.name} (${student.email})`;
    } catch (error) {
      console.error(error);
      return `Error: ${error.message}`;
    }
  });

  // 🟩 BOUND Action: promote (auto-reads selected student and updates instantly)
  srv.on('promote', 'Students', async (req) => {
    try {
      const { studentId } = req.params[0]; // Auto-read selected student's ID
      if (!studentId) return req.error(400, 'Student ID missing.');

      const student = await SELECT.one.from(Students).where({ studentId });
      if (!student) return req.error(404, `Student ${studentId} not found.`);

      // Check Fee
      const fee = await SELECT.one.from(Fees).where({ student_studentId: studentId });
      if (!fee || fee.status !== 'Paid') {
        await UPDATE(Students).set({ promotion: 'Not Promoted' }).where({ studentId });
        req.data.promotion = 'Not Promoted'; // Update UI instantly
        return `Student ${studentId} not promoted (Fee not paid).`;
      }

      // Check Results
      const failedSubject = await SELECT.one.from(Results).where({
        student_studentId: studentId,
        grade: 'F'
      });
      if (failedSubject) {
        await UPDATE(Students).set({ promotion: 'Not Promoted' }).where({ studentId });
        req.data.promotion = 'Not Promoted'; // Update UI instantly
        return `Student ${studentId} not promoted (Failed in subjects).`;
      }

      // All conditions satisfied
      await UPDATE(Students).set({ promotion: 'Promoted' }).where({ studentId });
      req.data.promotion = 'Promoted'; // ✅ update visible on UI instantly

      return `🎓 Student ${studentId} promoted successfully.`;
    } catch (error) {
      console.error(error);
      return `Error: ${error.message}`;
    }
  });
};