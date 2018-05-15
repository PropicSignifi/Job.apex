---
title: "Cron Expression Job Methods"
description: "Cron Expression Job Methods"
layout: "guide"
icon: "code-file"
weight: 3
---

###### {$page.description}

<article id="1">

## cron

Specify the cron expression.

```javascript
new Job('test', R.debug).cron('0 0 0 1 3 ?').getCronExpression()
// 0 0 0 1 3 ?
```

</article>

<article id="2">

## atSecond

Specify the second component of the cron expression.

```javascript
new Job('test', R.debug).atSecond(10).getCronExpression()
// 10 0 0 * * ?
```

</article>

<article id="3">

## atMinute

Specify the minute component of the cron expression.

```javascript
new Job('test', R.debug).atMinute(30).getCronExpression()
// 0 30 0 * * ?
```

</article>

<article id="4">

## atHour

Specify the hour component of the cron expression.

```javascript
new Job('test', R.debug).atHour(12).getCronExpression()
// 0 0 12 * * ?
```

</article>

<article id="5">

## onDay

Specify on which day of month.

```javascript
new Job('test', R.debug).onDay(12).getCronExpression()
// 0 0 0 12 * ?
```

</article>

<article id="6">

## fromDay

Specify from which day, usually used with 'everyDays'.

```javascript
new Job('test', R.debug).fromDay(2).everyDays(3).getCronExpression()
// 0 0 0 2/3 * ?
```

</article>

<article id="7">

## onDays

Specify on which days.

```javascript
new Job('test', R.debug).onDays(new List<Integer>{ 3, 4, 5 }).getCronExpression()
// 0 0 0 3,4,5 * ?
```

</article>

<article id="8">

## betweenDays

Specify a day range.

```javascript
new Job('test', R.debug).betweenDays(2, 5).getCronExpression()
// 0 0 0 2-5 * ?
```

</article>

<article id="9">

## everyDay

Specify every day.

```javascript
new Job('test', R.debug).everyDay().getCronExpression()
// 0 0 0 * * ?
```

</article>

<article id="10">

## everyDays

Specify every N days.

```javascript
new Job('test', R.debug).betweenDays(1, 20).everyDays(2).getCronExpression()
// 0 0 0 1-20/2 * ?
```

</article>

<article id="11">

## inMonth

Specify in which month.

```javascript
new Job('test', R.debug).inMonth('Sep').getCronExpression()
// 0 0 0 * 9 ?
```

</article>

<article id="12">

## fromMonth

Specify from which month.

```javascript
new Job('test', R.debug).fromMonth(1).everyMonths(2).getCronExpression()
// 0 0 0 * 1/2 ?
```

</article>

<article id="13">

## inMonths

Specify in which months.

```javascript
new Job('test', R.debug).inMonths(new List<Object>{ 'March', 'Octo' }).getCronExpression()
// 0 0 0 * 3,10 ?
```

</article>

<article id="14">

## betweenMonths

Specify the month range.

```javascript
new Job('test', R.debug).betweenMonths(1, 'July').getCronExpression()
// 0 0 0 * 1-7 ?
```

</article>

<article id="15">

## everyMonth

Specify every month.

```javascript
new Job('test', R.debug).everyMonth().getCronExpression()
// 0 0 0 * * ?
```

</article>

<article id="16">

## everyMonths

Specify every N months.

```javascript
new Job('test', R.debug).betweenMonths(1, 12).everyMonths(2).getCronExpression()
// 0 0 0 * 1-12/2 ?
```

</article>

<article id="17">

## onDayOfWeek

Specify on which day of week.

```javascript
new Job('test', R.debug).onDayOfWeek(1).getCronExpression()
// 0 0 0 ? * 2
```

</article>

<article id="18">

## fromDayOfWeek

Specify from which day of week.

```javascript
new Job('test', R.debug).fromDayOfWeek(1).everyDaysOfWeek(2).getCronExpression()
// 0 0 0 ? * 2/2
```

</article>

<article id="19">

## onDaysOfWeek

Specify on which days of week.

```javascript
new Job('test', R.debug).onDaysOfWeek(new List<Object>{ 1, 'Tu' }).getCronExpression()
// 0 0 0 ? * 2,3
```

</article>

<article id="20">

## betweenDaysOfWeek

Specify the day of week range.

```javascript
new Job('test', R.debug).betweenDaysOfWeek(2, 'Sun').getCronExpression()
// 0 0 0 ? * 3-1
```

</article>

<article id="21">

## everyDayOfWeek

Specify every day of week.

```javascript
new Job('test', R.debug).everyDayOfWeek().getCronExpression()
// 0 0 0 ? * *
```

</article>

<article id="22">

## everyDaysOfWeek

Specify every N days of week.

```javascript
new Job('test', R.debug).betweenDaysOfWeek(1, 5).everyDaysOfWeek(2).getCronExpression()
// 0 0 0 ? * 2-6/2
```

</article>

<article id="23">

## inYear

Specify in which year.

```javascript
new Job('test', R.debug).inYear(2018).getCronExpression()
// 0 0 0 * * ? 2018
```

</article>

<article id="24">

## fromYear

Specify from which year.

```javascript
new Job('test', R.debug).fromYear(2018).everyYears(2).getCronExpression()
// 0 0 0 * * ? 2018/2
```

</article>

<article id="25">

## inYears

Specify in which years.

```javascript
new Job('test', R.debug).inYears(new List<Integer>{ 2018, 2019 }).getCronExpression()
// 0 0 0 * * ? 2018,2019
```

</article>

<article id="26">

## betweenYears

Specify year range.

```javascript
new Job('test', R.debug).betweenYears(2018, 2020).getCronExpression()
// 0 0 0 * * ? 2018-2020
```

</article>

<article id="27">

## everyYear

Specify every year.

```javascript
new Job('test', R.debug).everyYear().getCronExpression()
// 0 0 0 * * ? *
```

</article>

<article id="28">

## everyYears

Specify every N years.

```javascript
new Job('test', R.debug).betweenYears(2018, 2050).everyYears(2).getCronExpression()
// 0 0 0 * * ? 2018-2050/2
```

</article>

<article id="29">

## onLastDayOfMonth

Specify on the last day of month.

```javascript
new Job('test', R.debug).onLastDayOfMonth().getCronExpression()
// 0 0 0 L * ?
```

</article>

<article id="30">

## onLastWeekdayOfMonth

Specify on the last week day of month.

```javascript
new Job('test', R.debug).onLastWeekdayOfMonth().getCronExpression()
// 0 0 0 LW * ?
```

</article>

<article id="31">

## onNearestWeekday

Specify on nearest weekday of this day.

```javascript
new Job('test', R.debug).onNearestWeekday(20).getCronExpression()
// 0 0 0 20W * ?
```

</article>

<article id="32">

## onLastDayOfWeek

Specify on the last day of week.

```javascript
new Job('test', R.debug).onLastDayOfWeek().getCronExpression()
// 0 0 0 ? * L
```

</article>

<article id="33">

## onLast

Specify on the last 'Monday'.

```javascript
new Job('test', R.debug).onLast('Mon').getCronExpression()
// 0 0 0 ? * 2L
```

</article>

<article id="34">

## on1st

Specify on the first 'Monday'.

```javascript
new Job('test', R.debug).on1st('Mon').getCronExpression()
// 0 0 0 ? * 1#2
```

</article>

<article id="35">

## on2nd

Specify on the second 'Monday'.

```javascript
new Job('test', R.debug).on2nd('Mon').getCronExpression()
// 0 0 0 ? * 2#2
```

</article>

<article id="36">

## on3rd

Specify on the third 'Monday'.

```javascript
new Job('test', R.debug).on3rd('Mon').getCronExpression()
// 0 0 0 ? * 3#2
```

</article>

<article id="37">

## on4th

Specify on the fourth 'Monday'.

```javascript
new Job('test', R.debug).on4th('Mon').getCronExpression()
// 0 0 0 ? * 4#2
```

</article>

<article id="38">

## on5th

Specify on the fifth 'Monday'.

```javascript
new Job('test', R.debug).on5th('Mon').getCronExpression()
// 0 0 0 ? * 5#2
```

</article>
