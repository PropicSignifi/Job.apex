---
title: "Repeating Job Methods"
description: "Repeating Job Methods"
layout: "guide"
icon: "code-file"
weight: 3
---

###### {$page.description}

<article id="1">

## startAt

Start the repeating job at the datetime.

```javascript
new Job('test', R.debug).startAt(Datetime.now()).afterMinutes(30).repeatOnce().schedule();
// Schedule a run-once job that starts now, triggered after 30 mins
```

</article>

<article id="2">

## startNow

Start the repeating job now.

```javascript
new Job('test', R.debug).startNow().afterMinutes(30).repeatOnce().schedule();
// Schedule a run-once job that starts now, triggered after 30 mins
```

</article>

<article id="3">

## afterSeconds

Repeating after N seconds.

```javascript
new Job('test', R.debug).startNow().afterSeconds(30).repeatOnce().schedule();
// Schedule a run-once job that starts now, triggered after 30 seconds
```

</article>

<article id="4">

## afterMinutes

Repeating after N minutes.

```javascript
new Job('test', R.debug).startNow().afterMinutes(30).repeatOnce().schedule();
// Schedule a run-once job that starts now, triggered after 30 minutes
```

</article>

<article id="5">

## afterHours

Repeating after N hours.

```javascript
new Job('test', R.debug).startNow().afterHours(10).repeatOnce().schedule();
// Schedule a run-once job that starts now, triggered after 10 hours
```

</article>

<article id="6">

## afterDays

Repeating after N days.

```javascript
new Job('test', R.debug).startNow().afterDays(10).repeatOnce().schedule();
// Schedule a run-once job that starts now, triggered after 10 days
```

</article>

<article id="7">

## afterMonths

Repeating after N months.

```javascript
new Job('test', R.debug).startNow().afterMonths(10).repeatOnce().schedule();
// Schedule a run-once job that starts now, triggered after 10 months.
```

</article>

<article id="8">

## afterYears

Repeating after N years.

```javascript
new Job('test', R.debug).startNow().afterYears(10).repeatOnce().schedule();
// Schedule a run-once job that starts now, triggered after 10 years
```

</article>

<article id="9">

## afterTime

Repeating after N milliseconds.

```javascript
new Job('test', R.debug).startNow().afterTime(10000).repeatOnce().schedule();
// Schedule a run-once job that starts now, triggered after 10000 milliseconds
```

</article>

<article id="10">

## after

Repeating after the time returned by the afterFunc.

```javascript
new Job('test', R.debug).startNow().after(R.multiply.apply(1000)).repeatOnce().schedule();
// Schedule a run-once job that starts now, triggered after 0s, 1s, 2s ...
```

</article>

<article id="11">

## repeat

Repeat max count.

```javascript
new Job('test', R.debug).startNow().afterMinutes(30).repeat(3).schedule();
// Schedule a job that starts now, triggered after 30 minutes, for 3 times
```

</article>

<article id="12">

## repeatOnce

Repeat only once.

```javascript
new Job('test', R.debug).startNow().afterMinutes(30).repeatOnce().schedule();
// Schedule a job that starts now, triggered after 30 minutes, for only 1 time
```

</article>

<article id="13">

## repeatForever

Repeat forever.

```javascript
new Job('test', R.debug).startNow().afterMinutes(30).repeatForever().schedule();
// Schedule a job that starts now, triggered after 30 minutes, running forever
```

</article>

<article id="14">

## repeatUntil

Repeat until func is satisfied.
The func takes the current repeating number, and returns a Boolean.
Returning true indicates that the repeating is finished.

```javascript
new Job('test', R.debug).startNow().afterMinutes(30).repeatUntil(R.equals.apply(2)).schedule();
// Schedule a job that starts now, triggered after 30 minutes until repeating count reaches 2
```

</article>

<article id="15">

## repeatUntil

Repeat until the end datetime.

```javascript
new Job('test', R.debug).startNow().afterMinutes(30).repeatUntil(Datetime.newInstance(2018, 10, 1)).schedule();
// Schedule a job that starts now, triggered after 30 minutes, repeating until 2018/10/01
```

</article>

<article id="16">

## usingRepeat

Check if the job is using repeating pattern.

</article>

<article id="17">

## isRepeatSet

Check if the job has set repeating.

</article>

<article id="18">

## getNextDatetime

Get the next triggered datetime of the job.
Only available for repeating pattern job.

</article>
