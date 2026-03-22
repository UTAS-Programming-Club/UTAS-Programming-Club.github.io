// Uses Typst 0.14.2

// TODO: Set these
#let last_meeting_date = datetime(year: 0, month: 1, day: 1)
#let meeting_date = datetime(year: 0, month: 1, day: 1, hour: 0, minute: 0, second: 0)
#let wrap_meeting_date = true // Change to false if meeting is before 9 am
#let meeting_type = "Committee" // "Annual/Special General"
#let general_meeting = false
#let location = "on Discord (Online)" // "in Centenary 140"

// Only used for committee meetings
#let second_last_cm_officer_count = 0
#let last_cm_officer_count = 0
#let second_last_cm_date = datetime(year: 0, month: 1, day: 1)

// Only used for general meetings
#let voting_member_count = 0


// Import minutes layout
#import "/2025-2026/Templates/Structure-20260322.typ": *
#show: it => minutes(meeting_date, wrap_meeting_date, meeting_type, location, it)


= Introductory Items

== Present
// TODO: Set these to match attendance
#let current_officer_count = 0 // Only used for committee meetings
#let current_exec_count = 0 // Only used for committee meetings
#let current_voting_member_count = 0 // Only used for general meetings

// TODO: Move as required, remove optional_attendance variable(s) if attending
#cameron_full\
#joshua_full\
#lachlan_full\
#luke_full\
#amari_full\
#rifat_full\
#taylor_full #optional_attendance

== Apologies
Nil.

== Absent
Nil.

== Observers
// TODO: Add as required, non-committee members are allowed at all GMs and with permission at CMs, club member status preferred but not required
Nil.

== Quorum
#let waive_quorum = false // Only set if Subrule 19.4 is satisified
#let acknowledge_failing_quorum = false // Cannot conduct business if false
#quorem_check(general_meeting, voting_member_count, current_voting_member_count, waive_quorum, acknowledge_failing_quorum, second_last_cm_officer_count, last_cm_officer_count, second_last_cm_date, last_meeting_date, current_officer_count, current_exec_count)


= Minutes and Matters Arising

== Amendments for Last #simple_meeting_type(meeting_type) Meeting
/* TODO: Use this motion if any amendments in minutes
#motion[that the listed amendments were made in discussion with other committee members and in fact reflect the decisions made during the #get_formatted_date(last_meeting_date) #meeting_type Meeting]*/
Nil.

== Minutes

// TODO Add mover and seconder once meeting has concluded
// motion(mover: ?_full, seconder: ?_full)
#motion[that the following minutes are accepted as a true and accurate record of the #get_formatted_date(meeting_date) #meeting_type Meeting]


= Matters for Discussion
