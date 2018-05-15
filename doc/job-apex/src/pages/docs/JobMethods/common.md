---
title: "Common Methods"
description: "Common Methods"
layout: "guide"
icon: "code-file"
weight: 2
---

###### {$page.description}

<article id="1">

## getName

Get the name of the Job

```javascript
new Job('test', R.debug).getName();
// test
```

</article>

<article id="2">

## schedule

Schedule the job.

```javascript
new Job('test', R.debug).everyDay().atHour(8).schedule();
// schedule the job that runs at 8:00 every day
```

</article>

<article id="3">

## getCronExpression

Get the generated cron expression.

</article>
