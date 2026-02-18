
= Matters for Noting

== President's Report
// TODO: Add report as required
Nil.

== Treasurer's Report
// TODO: Add report as required
Nil.

== Subcommittee and Other Reports (if applicable)
// TODO: Add report(s) as required
Nil.


= Other Business

/* TODO: Add any other business as required
== Other Business Item
*/
Nil.

// TODO: Set meeting close time and date of next meeting 
#let meeting_close_time = datetime(hour: 0, minute: 0, second: 0)
#let next_meeting_time = datetime(year: 0, month: 1, day: 1, hour: 0, minute: 0, second: 0)
// Change to false if matching time is before 9 am
#let wrap_meeting_close_time = true
#let wrap_next_meeting_time = true

#linebreak()
*Meeting closed*: #get_formatted_safe_time(meeting_close_time, wrap_meeting_date)
*Date of next meeting*: #get_formatted_full_safe_datetime(next_meeting_time, wrap_next_meeting_time)