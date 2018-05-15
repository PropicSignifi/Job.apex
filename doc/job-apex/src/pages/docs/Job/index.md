---
title: "Job"
description: "Job"
layout: "guide"
icon: "flash"
weight: 1
---

###### {$page.description}

<article id="1">

## Jobs

We have two types of Jobs here.

The first type is cron expression jobs, which builds cron expressions internally and delegate everything to cron expression scheduling.

The other type is repeating jobs, which repeat themselves at a given interval, and are more flexible in use.

Repeating jobs are defined by using methods like 'startAt(Xxx)' or 'startNow()', followed by 'afterXxx' and 'repeatXxx'.

</article>

<article id="2">

## Dependencies

Job.apex has a dependency over [R.apex](https://github.com/Click-to-Cloud/R.apex). We utilize R.apex to grant the power of functions to Job.apex.

</article>

<article id="3">

## Job Executor

We separate the job execution from job scheduling. So users only need to pass in job executors, and Job.apex will take care of the job scheduling.

```javascript
public class CustomJob extends Func {
    public CustomJob() {
        super(1);
    }

    public override Object exec(Object context) {
        System.debug('Custom job executed');
        return null;
    }
}
```

Here we defined a CustomJob executor with our custom logic inside it. Then we can schedule our job like this:

```javascript
new Job('test', new CustomJob()).everyDay().atHour(8).schedule();
```

</article>
