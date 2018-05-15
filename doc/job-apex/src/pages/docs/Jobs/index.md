---
title: "Jobs Methods"
description: "Jobs Methods"
layout: "guide"
icon: "cloud"
weight: 4
---

###### {$page.description}

<article id="1">

## Jobs Methods Reference

Here is the reference of the methods from Jobs.

| Method | Description |
| ------ | ----------- |
| static getInstance() | Get the singleton instance |
| CronTrigger getCronTriggerById(Id) | Get the cron trigger by id |
| CronTrigger getCronTriggerByName(String) | Get the cron trigger by name |
| List&lt;CronTrigger&gt; getCronTriggers() | Get all the cron triggers |
| List&lt;CronTrigger&gt; getCronTriggers(String) | Get all the cron triggers that match the name |
| clean(String) | Delete the job specified by the job name |
| schedule(Job) | Schedule the job |
| unschedule(CronTrigger) | Unschedule the job |
| unscheduleById(Id) | Unschedule the job |
| unscheduleByName(String) | Unschedule the job |
| String reschedule(Job) | Reschedule the job |

</article>
