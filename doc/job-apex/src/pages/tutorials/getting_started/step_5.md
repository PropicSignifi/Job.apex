---
title: "Repeating Jobs"
description: "Repeating Jobs"
buttonTitle: "Done"
parentId: "getting_started"
layout: "tutorial"
time: 90
weight: 5
---

## {$page.title}

Job.apex provides another type of jobs that can repeat themselves at given interval.

```javascript
new Job('test', new CustomJob())
    .startNow()
    .everyMinutes(30)
    .repeatForever()
    .schedule();
// Schedule a job that first runs 30 minutes after now, and then repeats itself forever
```
