# Maintaining a weekly planner using the weekly_planner gem

Here's the ResultX document which helps define what I want the gem to do:

<pre>
feature: The weekly-planner.txt file will be kept up-to-date by the system
  To help remind me of important events
  As the project maintainer
  The weekly planner gem will help maintain and update the weekly-planner.txt file

scenario: Creating a new weekly planner
result: The weekly-planner.txt file is created
conditions: the weekly-planner.txt file doesn't exist

scenario: The weekly planner is archived
result: The archive directory including the archive file is created
conditions: The user adds an appointment to the weekly-planner.txt file

scenario: Refreshing the weekly planner to the current date
result: The 1st entry in the weekly planner is today
conditions: The system is accessed the following day

scenario: Updating the weekly planner from the archive
result: The new appointment appears in the weekly-planner.txt file
conditions: An appointment is added to the archived file directly
</pre>

## Creating a new weekly-planner.txt file

    require 'weekly_planner'

    wp = WeeklyPlanner.new 'weekly-planner.txt', path: '/tmp'
    wp.save

Output:

There are 2 files output from the above example, those are weekly-planner.txt and weekly-planner.xml as shown below:

<pre>
weekly-planner.txt
==================

Thursday, 10th Dec
------------------

Fri
---

Sat
---

Sun
---

Mon
---

Tue
---

Wed
---

</pre>

<pre>
&lt;?xml version='1.0' encoding='UTF-8'?&gt;
&lt;sections&gt;
  &lt;summary&gt;
    &lt;title&gt;Weekly Planner (10-Dec-2015)&lt;/title&gt;
    &lt;recordx_type&gt;dynarex&lt;/recordx_type&gt;
    &lt;format_mask&gt;[!x]&lt;/format_mask&gt;
    &lt;schema&gt;sections[title]/section(x)&lt;/schema&gt;
    &lt;default_key&gt;x&lt;/default_key&gt;
  &lt;/summary&gt;
  &lt;records&gt;
    &lt;section id='20151210' created='2015-12-10 19:59:53 +0000' last_modified=''&gt;
      &lt;x&gt;# 10-Dec-2015
&lt;/x&gt;
    &lt;/section&gt;
    &lt;section id='20151211' created='2015-12-10 19:59:53 +0000' last_modified=''&gt;
      &lt;x&gt;# 11-Dec-2015
&lt;/x&gt;
    &lt;/section&gt;
    &lt;section id='20151212' created='2015-12-10 19:59:53 +0000' last_modified=''&gt;
      &lt;x&gt;# 12-Dec-2015
&lt;/x&gt;
    &lt;/section&gt;
    &lt;section id='20151213' created='2015-12-10 19:59:53 +0000' last_modified=''&gt;
      &lt;x&gt;# 13-Dec-2015
&lt;/x&gt;
    &lt;/section&gt;
    &lt;section id='20151214' created='2015-12-10 19:59:53 +0000' last_modified=''&gt;
      &lt;x&gt;# 14-Dec-2015
&lt;/x&gt;
    &lt;/section&gt;
    &lt;section id='20151215' created='2015-12-10 19:59:53 +0000' last_modified=''&gt;
      &lt;x&gt;# 15-Dec-2015
&lt;/x&gt;
    &lt;/section&gt;
    &lt;section id='20151216' created='2015-12-10 19:59:53 +0000' last_modified=''&gt;
      &lt;x&gt;# 16-Dec-2015
&lt;/x&gt;
    &lt;/section&gt;
  &lt;/records&gt;
&lt;/sections&gt;
</pre>

In addition to that there's an archive directory created for the current year, and it contains the weekly planner files by week.

## Updating the weekly planner

To update the weekly planner, using a text editor open the weekly-planner.txt file and add 1 or more entries under a day heading. Then run the code from above again and it will update the archive for you. Also, the weekly-planner.xml file will be updated including the timestamp of when the record for each day was last updated.

A script could be run from a task scheduler or cronjob to run the weekly_planner gem daily to update the weekly-planner.txt to the current day including the week ahead.

weeklyplanner
