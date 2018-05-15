---
title: "Cron Expression Jobs"
description: "Cron Expression Jobs"
buttonTitle: "Done"
parentId: "getting_started"
layout: "tutorial"
time: 90
weight: 4
---

## {$page.title}

Job.apex provides full support to Salesforce Apex scheduled job cron expressions.

```javascript
new Job('test', new CustomJob())
    .everyDay()
    .atHour(8)
    .schedule();
// Schedule a job that runs at 8:00 everyday
```

```javascript
new Job('test', new CustomJob())
    .betweenDaysOfWeek('Mon', 'Fri')
    .atHour(8)
    .schedule();
// Schedule a job that runs at 8:00 every week day
```

```javascript
new Job('test', new CustomJob())
    .fromDay(1)
    .everyDays(2)
    .atHour(8)
    .schedule();
// Schedule a job that runs at 8:00 every other day from day 1
```

```javascript
new Job('test', new CustomJob())
    .inMonth('May')
    .on2nd('Sun')
    .atHour(8)
    .schedule();
// Schedule a job that runs at 8:00 on the second Sunday of May
```

```javascript
new Job('test', new CustomJob())
    .onLastWeekdayOfMonth()
    .atHour(8)
    .schedule();
// Schedule a job that runs at 8:00 on the last week day of every month
```

```javascript
new Job('test', new CustomJob())
    .inMonth('Sept')
    .onNearestWeekday(20)
    .atHour(8)
    .schedule();
// Schedule a job that runs at 8:00 on the nearest week day of 9/20
```
