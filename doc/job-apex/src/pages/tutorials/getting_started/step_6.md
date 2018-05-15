---
title: "Job Management"
description: "Job Management"
buttonTitle: "Done"
parentId: "getting_started"
layout: "tutorial"
time: 90
weight: 6
---

## {$page.title}

We can create a job like this:

```javascript
Job j = new Job('test', new CustomJob()).everyDay().atHour(8);
Jobs.getInstance().schedule(j);
```

Or we can unschedule it:

```javascript
Jobs.getInstance().unschedule('test');
```

Or reschedule it.

```javascript
j.atHour(10);
Jobs.getInstance().reschedule(j);
```
