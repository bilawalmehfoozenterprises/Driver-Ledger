# Driver Ledger Glossary

Project-specific terminology for the driver ledger app.

## Terminology

**Student**:
A child transported by the driver on a recurring monthly basis. Each student has a parent who pays a monthly fee.
_Avoid_: passenger, customer, rider (use for one-time bookings only)

**Monthly Record**:
A per-student, per-month record tracking expected fee, vacation deductions, and payments received.
_Avoid_: monthly_entry, payment_record

**Shift**:
The transport service the driver provides for a student: morning pickup only, afternoon drop only, or both.
_Avoid_: trip, ride, route

**Monthly Fee**:
The fixed amount a parent pays per month for their student's transport. Applies from the second month onward; first month may be pro-rated.
_Aavoid_: price, rate, charge

**Pro-rated Fee**:
The reduced fee for a student's first month when they join mid-month. Calculated as (monthly fee / days in month) × remaining days.
_Avoid_: partial_fee, adjusted_fee

**Vacation Days**:
Days a student is absent in a given month. Used to calculate a deduction from the monthly fee.
_Avoid_: leave, absence, off_days

**Deduction Amount**:
The amount subtracted from the monthly fee due to vacation days. Calculated as (monthly fee / 26) × vacation days.
_Avoid_: discount, reduction

**Amount Due**:
The final amount a parent must pay for a month. Equals expected fee minus deduction amount.
_Avoid_: balance, total_due

**Payment Status**:
The current state of payment for a month: Unpaid (nothing paid), Partial (some paid), or Paid (fully paid).
_Avoid_: payment_state, paid_status

**Active Student**:
A student currently being transported. Inactive students are preserved in history but no new monthly records are created.
_Aavoid_: enabled, current

**Backfill**:
Creating Monthly Records for past months that don't yet exist for a student, covering the gap between their join date and the current month. Triggered when adding a student with a past join date, editing a join date to an earlier date, or manually from the student detail screen for a student with missing months. Presented via a review screen where each missing month's expected fee and amount paid can be set before saving.
_Avoid_: migration, historical import, catch-up
