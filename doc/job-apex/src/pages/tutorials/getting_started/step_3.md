---
title: "Hello World Job"
description: "Hello World Job"
buttonTitle: "Done"
parentId: "getting_started"
layout: "tutorial"
time: 90
weight: 3
---

## {$page.title}

Below is how we create a simple HelloWorldJob.

```javascript
public class HelloWorldJob extends Func {
    public HelloWorldJob() {
        super(1);
    }

    public override Object exec(Object context) {
        System.debug('Hello World');
        return null;
    }
}
```

We can directly use any Func as a Job executor.

Here is how we create a job.

```javascript
Job j = new Job('helloworld', new HelloWorldJob());
```

And then we set when the job will execute.

```javascript
j.everyDay().atHour(8);
```

Finally we schedule the job.

```javascript
j.schedule();
```

We can combine all of these into:

```javascript
new Job('helloworld', new HelloWorldJob())
    .everyDay()
    .atHour(8)
    .schedule();
```
