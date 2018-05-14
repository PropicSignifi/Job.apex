# Job.apex
Job.apex is a library that aims to easily create and manage Apex scheduled jobs.

## Why Job.apex?
Job.apex is created to offer a readable and fluent API to create Apex scheduled jobs as an alternative to the normal cron expression way. Besides, Job.apex supports a repeating job to work around the limitation in Apex that scheduled jobs cannot run in an interval less than 1 hour. Also Job.apex has API to manage all the scheduled jobs.

## Dependencies
Job.apex has a dependency on [R.apex](https://github.com/Click-to-Cloud/R.apex). Please include R.apex before getting started with Job.apex.

## Examples
### Create a Custom Job
```java
public class CustomJob extends Func {
    public CustomJob() {
        super(1);
    }

    public override Object exec(Object context) {
        System.debug('Custom job executed');
        return null;
    }
}

Job j = new Job('test', new CustomJob());
```

### Every Day Job
```java
new Job('test', new CustomJob())
    .everyDay()
    .atHour(8)
    .schedule();
// Schedule a job that runs at 8:00 everyday
```

### Every Week Day Job
```java
new Job('test', new CustomJob())
    .betweenDaysOfWeek('Mon', 'Fri')
    .atHour(8)
    .schedule();
// Schedule a job that runs at 8:00 every week day
```

### Every Other Day Job
```java
new Job('test', new CustomJob())
    .fromDay(1)
    .everyDays(2)
    .atHour(8)
    .schedule();
// Schedule a job that runs at 8:00 every other day from day 1
```

### Second Sun in May Job
```java
new Job('test', new CustomJob())
    .inMonth('May')
    .on2nd('Sun')
    .atHour(8)
    .schedule();
// Schedule a job that runs at 8:00 on the second Sunday of May
```

### Last Week Day of Every Month Job
```java
new Job('test', new CustomJob())
    .onLastWeekdayOfMonth()
    .atHour(8)
    .schedule();
// Schedule a job that runs at 8:00 on the last week day of every month
```

### Nearest Week Day Job
```java
new Job('test', new CustomJob())
    .inMonth('Sept')
    .onNearestWeekday(20)
    .atHour(8)
    .schedule();
// Schedule a job that runs at 8:00 on the nearest week day of 9/20
```

### Every 30 Minutes Job
```java
new Job('test', new CustomJob())
    .startNow()
    .everyMinutes(30)
    .repeatForever()
    .schedule();
// Schedule a job that first runs 30 minutes after now, and then repeats itself forever
```
