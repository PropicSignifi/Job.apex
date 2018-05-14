/**
 * MIT License
 *
 * Copyright (c) 2018 Click to Cloud Pty Ltd
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 **/
/**
 * A Job is an object that represents a scheduled job
 *
 * Job supports two major types:
 *
 * 1) Cron Expression
 * This type of job internally builds the cron expression and totally delegates scheduling to cron expressions
 * The limit in Apex scheduled jobs is that you cannot schedule interval less than one hour
 *
 * 2) Repeat Pattern
 * This type of job holds a repeat pattern and a start datetime, and dynamically calculates the next datetime to
 * achieve the occurring behavior
 * Using this type of job, you can schedule jobs with intervals less than one hour
 *
 * Invoking 'startNow' or 'startAt', followed by 'afterXxx' and 'repeatXxx', is a typical example of this type of job
 * */
public class Job implements Schedulable {
    // Job name required
    private String name;

    // Job executor required
    private Func executor;

    // Cron info used to build the cron expression
    private CronInfo cronInfo = new CronInfo();

    // When used in repeat, the start datetime of the repeat
    private Datetime startDatetime;

    // The calculated datetime of the next repeat
    private Datetime nextDatetime;

    // The interval info for the repeat
    private IntervalInfo intervalInfo;

    // The max number of repeat allowed
    private Integer repeatMax = 1;

    // The current repeat number
    private Integer repeatNum = 0;

    // The end datetime for the repeat
    private Datetime endDatetime;

    // The end func that takes the current repeat number and returns a Boolean. It stops the repeat when it evaluates to true
    private Func endFunc = null;

    // The flag that marks the job is a repeating job(not a normal cron expression job)
    private Boolean repeatSet = false;

    /**
     * Construct an instance of job
     *
     * @param name The job name
     * @param executor The job executor that performs the job logic
     * */
    public Job(String name, Func executor) {
        this.name = name;
        this.executor = executor;
    }

    /**
     * Construct an instance of job
     *
     * @param name The job name
     * @param mSchedulable The schedulable object
     * */
    public Job(String name, Schedulable mSchedulable) {
        this(name, new SchedulableFunc(mSchedulable));
    }

    // Implement Schedulable interface
    public void execute(SchedulableContext context) {
        this.executor.run(context);
        this.repeatNum += 1;

        if(this.doRepeat()) {
            this.schedule();
        }
    }

    /**
     * Get the name of the job
     *
     * @return Job name
     * */
    public String getName() {
        return this.name;
    }

    /**
     * Schedule the job
     *
     * @return Job id
     * */
    public String schedule() {
        return Jobs.getInstance().schedule(this);
    }

    /**
     * Specify the second component of the cron expression
     *
     * Example:
     * new Job('test', R.debug).atSecond(10).getCronExpression()
     * // 10 0 0 * * ?
     *
     * @param val The second
     * @return Job
     * */
    public Job atSecond(Integer val) {
        validateSecond(val);

        cronInfo.second = new List<String>{ String.valueOf(val) };

        return this;
    }

    /**
     * Specify the cron expression
     *
     * Example:
     * new Job('test', R.debug).cron('0 0 0 1 3 ?').getCronExpression()
     * // 0 0 0 1 3 ?
     *
     * @param cronExpression The cron expression
     * @return Job
     * */
    public Job cron(String cronExpression) {
        if(cronExpression != null) {
            List<String> items = cronExpression.split(' ');

            if(items.size() >= 6) {
                cronInfo.second = new List<String>{ items.get(0) };
                cronInfo.minute = new List<String>{ items.get(1) };
                cronInfo.hour = new List<String>{ items.get(2) };
                cronInfo.day = new List<String>{ items.get(3) };
                cronInfo.month = new List<String>{ items.get(4) };
                cronInfo.dayOfWeek = new List<String>{ items.get(5) };

                if(items.size() >= 7) {
                    cronInfo.year = new List<String>{ items.get(6) };
                }
            }
        }

        return this;
    }

    /**
     * Specify the minute component of the cron expression
     *
     * Example:
     * new Job('test', R.debug).atMinute(30).getCronExpression()
     * // 0 30 0 * * ?
     *
     * @param val The minute
     * @return Job
     * */
    public Job atMinute(Integer val) {
        validateMinute(val);

        cronInfo.minute = new List<String>{ String.valueOf(val) };

        return this;
    }

    /**
     * Specify the hour component of the cron expression
     *
     * Example:
     * new Job('test', R.debug).atHour(12).getCronExpression()
     * // 0 0 12 * * ?
     *
     * @param val The hour
     * @return Job
     * */
    public Job atHour(Integer val) {
        validateHour(val);

        cronInfo.hour = new List<String>{ String.valueOf(val) };

        return this;
    }

    /**
     * Specify on which day of month
     *
     * Example:
     * new Job('test', R.debug).onDay(12).getCronExpression()
     * // 0 0 0 12 * ?
     *
     * @param val The day
     * @return Job
     * */
    public Job onDay(Integer val) {
        validateDay(val);

        cronInfo.day.add(String.valueOf(val));

        return this;
    }

    /**
     * Specify from which day, usually used with 'everyDays'
     *
     * Example:
     * new Job('test', R.debug).fromDay(2).everyDays(3).getCronExpression()
     * // 0 0 0 2/3 * ?
     *
     * @param first The first day
     * @return Job
     * */
    public Job fromDay(Integer first) {
        return this.onDay(first);
    }

    /**
     * Specify on which days
     *
     * Example:
     * new Job('test', R.debug).onDays(new List<Integer>{ 3, 4, 5 }).getCronExpression()
     * // 0 0 0 3,4,5 * ?
     *
     * @param vals The days
     * @return Job
     * */
    public Job onDays(List<Integer> vals) {
        for(Integer val : vals) {
            onDay(val);
        }

        return this;
    }

    /**
     * Specify a day range
     *
     * Example:
     * new Job('test', R.debug).betweenDays(2, 5).getCronExpression()
     * // 0 0 0 2-5 * ?
     *
     * @param first The first day
     * @param last The last day
     * @return Job
     * */
    public Job betweenDays(Integer first, Integer last) {
        validateDay(first);
        validateDay(last);

        cronInfo.day.add(String.valueOf(first) + '-' + String.valueOf(last));

        return this;
    }

    /**
     * Specify every day
     *
     * Example:
     * new Job('test', R.debug).everyDay().getCronExpression()
     * // 0 0 0 * * ?
     *
     * @return Job
     * */
    public Job everyDay() {
        cronInfo.day = new List<String>{ '*' };

        return this;
    }

    /**
     * Specify every N days
     *
     * Example:
     * new Job('test', R.debug).betweenDays(1, 20).everyDays(2).getCronExpression()
     * // 0 0 0 1-20/2 * ?
     *
     * @param interval The interval days
     * @return Job
     * */
    public Job everyDays(Integer interval) {
        if(cronInfo.day.isEmpty()) {
            throw new JobException('Invalid usage of everyDays');
        }

        String day = cronInfo.day.get(cronInfo.day.size() - 1);
        day += '/' + String.valueOf(interval);
        cronInfo.day.set(cronInfo.day.size() - 1, day);

        return this;
    }

    /**
     * Specify in which month
     *
     * Example:
     * new Job('test', R.debug).inMonth('Sep').getCronExpression()
     * // 0 0 0 * 9 ?
     *
     * @param val The month, which can be Integer from 1 to 12, or String that represents the month
     * @return Job
     * */
    public Job inMonth(Object val) {
        Integer month = getMonth(val);
        validateMonth(month);

        cronInfo.month.add(String.valueOf(month));

        return this;
    }

    /**
     * Specify from which month
     *
     * Example:
     * new Job('test', R.debug).fromMonth(1).everyMonths(2).getCronExpression()
     * // 0 0 0 * 1/2 ?
     *
     * @param first The first month
     * @return Job
     * */
    public Job fromMonth(Object first) {
        return this.inMonth(first);
    }

    /**
     * Specify in which months
     *
     * Example:
     * new Job('test', R.debug).inMonths(new List<Object>{ 'March', 'Octo' }).getCronExpression()
     * // 0 0 0 * 3,10 ?
     *
     * @param vals The months
     * @return Job
     * */
    public Job inMonths(List<Object> vals) {
        for(Object val : vals) {
            inMonth(val);
        }

        return this;
    }

    /**
     * Specify the month range
     *
     * Example:
     * new Job('test', R.debug).betweenMonths(1, 'July').getCronExpression()
     * // 0 0 0 * 1-7 ?
     *
     * @param firstVal The first month
     * @param lastVal The last month
     * @return Job
     * */
    public Job betweenMonths(Object firstVal, Object lastVal) {
        Integer first = getMonth(firstVal);
        Integer last = getMonth(lastVal);

        validateMonth(first);
        validateMonth(last);

        cronInfo.month.add(String.valueOf(first) + '-' + String.valueOf(last));

        return this;
    }

    /**
     * Specify every month
     *
     * Example:
     * new Job('test', R.debug).everyMonth().getCronExpression()
     * // 0 0 0 * * ?
     *
     * @return Job
     * */
    public Job everyMonth() {
        cronInfo.month = new List<String>{ '*' };

        return this;
    }

    /**
     * Specify every N months
     *
     * Example:
     * new Job('test', R.debug).betweenMonths(1, 12).everyMonths(2).getCronExpression()
     * // 0 0 0 * 1-12/2 ?
     *
     * @param interval The month interval
     * @return Job
     * */
    public Job everyMonths(Integer interval) {
        if(cronInfo.month.isEmpty()) {
            throw new JobException('Invalid usage of everyMonths');
        }

        String month = cronInfo.month.get(cronInfo.month.size() - 1);
        month += '/' + String.valueOf(interval);
        cronInfo.month.set(cronInfo.month.size() - 1, month);

        return this;
    }

    /**
     * Specify on which day of week
     *
     * Example:
     * new Job('test', R.debug).onDayOfWeek(1).getCronExpression()
     * // 0 0 0 ? * 2
     *
     * @param val The day of week, Integer from 1-7(Mon-Sun), or String
     * @return Job
     * */
    public Job onDayOfWeek(Object val) {
        Integer dayOfWeek = getDayOfWeek(val);

        validateDayOfWeek(dayOfWeek);

        cronInfo.dayOfWeek.add(String.valueOf(dayOfWeek));

        return this;
    }

    /**
     * Specify from which day of week
     *
     * Example:
     * new Job('test', R.debug).fromDayOfWeek(1).everyDaysOfWeek(2).getCronExpression()
     * // 0 0 0 ? * 2/2
     *
     * @param val The day of week
     * @return Job
     * */
    public Job fromDayOfWeek(Object val) {
        return onDayOfWeek(val);
    }

    /**
     * Specify on which days of week
     *
     * Example:
     * new Job('test', R.debug).onDaysOfWeek(new List<Object>{ 1, 'Tu' }).getCronExpression()
     * // 0 0 0 ? * 2,3
     *
     * @param vals The days of week
     * @return Job
     * */
    public Job onDaysOfWeek(List<Object> vals) {
        for(Object val : vals) {
            onDayOfWeek(val);
        }

        return this;
    }

    /**
     * Specify the day of week range
     *
     * Example:
     * new Job('test', R.debug).betweenDaysOfWeek(2, 'Sun').getCronExpression()
     * // 0 0 0 ? * 3-1
     *
     * @param firstVal The first day of week
     * @param lastVal The last day of week
     * @return Job
     * */
    public Job betweenDaysOfWeek(Object firstVal, Object lastVal) {
        Integer first = getDayOfWeek(firstVal);
        Integer last = getDayOfWeek(lastVal);

        validateDayOfWeek(first);
        validateDayOfWeek(last);

        cronInfo.dayOfWeek.add(String.valueOf(first) + '-' + String.valueOf(last));

        return this;
    }

    /**
     * Specify every day of week
     *
     * Example:
     * new Job('test', R.debug).everyDayOfWeek().getCronExpression()
     * // 0 0 0 ? * *
     *
     * @return Job
     * */
    public Job everyDayOfWeek() {
        cronInfo.dayOfWeek = new List<String>{ '*' };

        return this;
    }

    /**
     * Specify every N days of week
     *
     * Example:
     * new Job('test', R.debug).betweenDaysOfWeek(1, 5).everyDaysOfWeek(2).getCronExpression()
     * // 0 0 0 ? * 2-6/2
     *
     * @param interval The day of week interval
     * @return Job
     * */
    public Job everyDaysOfWeek(Integer interval) {
        if(cronInfo.dayOfWeek.isEmpty()) {
            throw new JobException('Invalid usage of everyDaysOfWeek');
        }

        String dayOfWeek = cronInfo.dayOfWeek.get(cronInfo.dayOfWeek.size() - 1);
        dayOfWeek += '/' + String.valueOf(interval);
        cronInfo.dayOfWeek.set(cronInfo.dayOfWeek.size() - 1, dayOfWeek);

        return this;
    }

    /**
     * Specify in which year
     *
     * Example:
     * new Job('test', R.debug).inYear(2018).getCronExpression()
     * // 0 0 0 * * ? 2018
     *
     * @param val The year
     * @return Job
     * */
    public Job inYear(Integer val) {
        validateYear(val);

        cronInfo.year.add(String.valueOf(val));

        return this;
    }

    /**
     * Specify from which year
     *
     * Example:
     * new Job('test', R.debug).fromYear(2018).everyYears(2).getCronExpression()
     * // 0 0 0 * * ? 2018/2
     *
     * @param val The year
     * @return Job
     * */
    public Job fromYear(Integer val) {
        return inYear(val);
    }

    /**
     * Specify in which years
     *
     * Example:
     * new Job('test', R.debug).inYears(new List<Integer>{ 2018, 2019 }).getCronExpression()
     * // 0 0 0 * * ? 2018,2019
     *
     * @param vals The years
     * @return Job
     * */
    public Job inYears(List<Integer> vals) {
        for(Integer val : vals) {
            inYear(val);
        }

        return this;
    }

    /**
     * Specify year range
     *
     * Example:
     * new Job('test', R.debug).betweenYears(2018, 2020).getCronExpression()
     * // 0 0 0 * * ? 2018-2020
     *
     * @param first The first year
     * @param last The last year
     * @return Job
     * */
    public Job betweenYears(Integer first, Integer last) {
        validateYear(first);
        validateYear(last);

        cronInfo.year.add(String.valueOf(first) + '-' + String.valueOf(last));

        return this;
    }

    /**
     * Specify every year
     *
     * Example:
     * new Job('test', R.debug).everyYear().getCronExpression()
     * // 0 0 0 * * ? *
     *
     * @return Job
     * */
    public Job everyYear() {
        cronInfo.year = new List<String>{ '*' };

        return this;
    }

    /**
     * Specify every N years
     *
     * Example:
     * new Job('test', R.debug).betweenYears(2018, 2050).everyYears(2).getCronExpression()
     * // 0 0 0 * * ? 2018-2050/2
     *
     * @param interval The interval
     * @return Job
     * */
    public Job everyYears(Integer interval) {
        if(cronInfo.year.isEmpty()) {
            throw new JobException('Invalid usage of everyYears');
        }

        String year = cronInfo.year.get(cronInfo.year.size() - 1);
        year += '/' + String.valueOf(interval);
        cronInfo.year.set(cronInfo.year.size() - 1, year);

        return this;
    }

    /**
     * Specify on the last day of month
     *
     * Example:
     * new Job('test', R.debug).onLastDayOfMonth().getCronExpression()
     * // 0 0 0 L * ?
     *
     * @return Job
     * */
    public Job onLastDayOfMonth() {
        cronInfo.day = new List<String>{ 'L' };

        return this;
    }

    /**
     * Specify on the last week day of month
     *
     * Example:
     * new Job('test', R.debug).onLastWeekdayOfMonth().getCronExpression()
     * // 0 0 0 LW * ?
     *
     * @return Job
     * */
    public Job onLastWeekdayOfMonth() {
        cronInfo.day = new List<String>{ 'LW' };

        return this;
    }

    /**
     * Specify on nearest weekday of this day
     *
     * Example:
     * new Job('test', R.debug).onNearestWeekday(20).getCronExpression()
     * // 0 0 0 20W * ?
     *
     * @param day The day
     * @return Job
     * */
    public Job onNearestWeekday(Integer day) {
        cronInfo.day = new List<String>{ String.valueOf(day) + 'W' };

        return this;
    }

    /**
     * Specify on the last day of week
     *
     * Example:
     * new Job('test', R.debug).onLastDayOfWeek().getCronExpression()
     * // 0 0 0 ? * L
     *
     * @return Job
     * */
    public Job onLastDayOfWeek() {
        cronInfo.dayOfWeek = new List<String>{ 'L' };

        return this;
    }

    /**
     * Specify on the last 'Monday'
     *
     * Example:
     * new Job('test', R.debug).onLast('Mon').getCronExpression()
     * // 0 0 0 ? * 2L
     *
     * @param val The day of week
     * @return Job
     * */
    public Job onLast(Object val) {
        Integer dayOfWeek = getDayOfWeek(val);

        validateDayOfWeek(dayOfWeek);

        cronInfo.dayOfWeek = new List<String>{ String.valueOf(dayOfWeek) + 'L' };

        return this;
    }

    // specify on the Nth day of week
    private Job onNth(Integer n, Object val) {
        Integer dayOfWeek = getDayOfWeek(val);

        validateDayOfWeek(dayOfWeek);

        cronInfo.dayOfWeek = new List<String>{ String.valueOf(n) + '#' + String.valueOf(dayOfWeek) };

        return this;
    }

    /**
     * Specify on the first 'Monday'
     *
     * Example:
     * new Job('test', R.debug).on1st('Mon').getCronExpression()
     * // 0 0 0 ? * 1#2
     *
     * @param val The day of week
     * @return Job
     * */
    public Job on1st(Object val) {
        return onNth(1, val);
    }

    /**
     * Specify on the second 'Monday'
     *
     * Example:
     * new Job('test', R.debug).on2nd('Mon').getCronExpression()
     * // 0 0 0 ? * 2#2
     *
     * @param val The day of week
     * @return Job
     * */
    public Job on2nd(Object val) {
        return onNth(2, val);
    }

    /**
     * Specify on the third 'Monday'
     *
     * Example:
     * new Job('test', R.debug).on3rd('Mon').getCronExpression()
     * // 0 0 0 ? * 3#2
     *
     * @param val The day of week
     * @return Job
     * */
    public Job on3rd(Object val) {
        return onNth(3, val);
    }

    /**
     * Specify on the fourth 'Monday'
     *
     * Example:
     * new Job('test', R.debug).on4th('Mon').getCronExpression()
     * // 0 0 0 ? * 4#2
     *
     * @param val The day of week
     * @return Job
     * */
    public Job on4th(Object val) {
        return onNth(4, val);
    }

    /**
     * Specify on the fifth 'Monday'
     *
     * Example:
     * new Job('test', R.debug).on5th('Mon').getCronExpression()
     * // 0 0 0 ? * 5#2
     *
     * @param val The day of week
     * @return Job
     * */
    public Job on5th(Object val) {
        return onNth(5, val);
    }

    /**
     * Start the repeating job at the datetime
     *
     * Example:
     * new Job('test', R.debug).startAt(Datetime.now()).afterMinutes(30).repeatOnce().schedule();
     * // Schedule a run-once job that starts now, triggered after 30 mins
     *
     * @param start The start datetime
     * @return Job
     * */
    public Job startAt(Datetime start) {
        this.startDatetime = start;
        this.intervalInfo = new IntervalInfo();

        this.applyDatetime(this.startDatetime);

        return this;
    }

    /**
     * Start the repeating job now
     *
     * Example:
     * new Job('test', R.debug).startNow().afterMinutes(30).repeatOnce().schedule();
     * // Schedule a run-once job that starts now, triggered after 30 mins
     *
     * @return Job
     * */
    public Job startNow() {
        return this.startAt(Datetime.now());
    }

    /**
     * Repeating after N seconds
     *
     * Example:
     * new Job('test', R.debug).startNow().afterSeconds(30).repeatOnce().schedule();
     * // Schedule a run-once job that starts now, triggered after 30 seconds
     *
     * @param seconds The repeating seconds
     * @return Job
     * */
    public Job afterSeconds(Integer seconds) {
        validateStartDatetime();

        this.intervalInfo.seconds = seconds;

        return this;
    }

    /**
     * Repeating after N minutes
     *
     * Example:
     * new Job('test', R.debug).startNow().afterMinutes(30).repeatOnce().schedule();
     * // Schedule a run-once job that starts now, triggered after 30 minutes
     *
     * @param minutes The repeating minutes
     * @return Job
     * */
    public Job afterMinutes(Integer minutes) {
        validateStartDatetime();

        this.intervalInfo.minutes += minutes;

        return this;
    }

    /**
     * Repeating after N hours
     *
     * Example:
     * new Job('test', R.debug).startNow().afterHours(10).repeatOnce().schedule();
     * // Schedule a run-once job that starts now, triggered after 10 hours
     *
     * @param hours The repeating hours
     * @return Job
     * */
    public Job afterHours(Integer hours) {
        validateStartDatetime();

        this.intervalInfo.hours += hours;

        return this;
    }

    /**
     * Repeating after N days
     *
     * Example:
     * new Job('test', R.debug).startNow().afterDays(10).repeatOnce().schedule();
     * // Schedule a run-once job that starts now, triggered after 10 days
     *
     * @param days The repeating days
     * @return Job
     * */
    public Job afterDays(Integer days) {
        validateStartDatetime();

        this.intervalInfo.days += days;

        return this;
    }

    /**
     * Repeating after N months
     *
     * Example:
     * new Job('test', R.debug).startNow().afterMonths(10).repeatOnce().schedule();
     * // Schedule a run-once job that starts now, triggered after 10 months.
     *
     * @param months The repeating months
     * @return Job
     * */
    public Job afterMonths(Integer months) {
        validateStartDatetime();

        this.intervalInfo.months += months;

        return this;
    }

    /**
     * Repeating after N years
     *
     * Example:
     * new Job('test', R.debug).startNow().afterYears(10).repeatOnce().schedule();
     * // Schedule a run-once job that starts now, triggered after 10 years
     *
     * @param years The repeating years
     * @return Job
     * */
    public Job afterYears(Integer years) {
        validateStartDatetime();

        this.intervalInfo.years += years;

        return this;
    }

    /**
     * Repeating after N milliseconds
     *
     * Example:
     * new Job('test', R.debug).startNow().afterTime(10000).repeatOnce().schedule();
     * // Schedule a run-once job that starts now, triggered after 10000 milliseconds
     *
     * @param milliseconds The repeating milliseconds
     * @return Job
     * */
    public Job afterTime(Long milliseconds) {
        validateStartDatetime();

        this.intervalInfo.intervalTime += milliseconds;

        return this;
    }

    /**
     * Repeating after the time returned by the afterFunc
     * The afterFunc takes the current repeating number(starting from 0) and returns the time in milliseconds
     *
     * Example:
     * new Job('test', R.debug).startNow().after(R.multiply.apply(1000)).repeatOnce().schedule();
     * // Schedule a run-once job that starts now, triggered after 0s, 1s, 2s ...
     *
     * @param afterFunc The func to return the repeating time
     * @return Job
     * */
    public Job after(Func afterFunc) {
        validateStartDatetime();

        this.intervalInfo.afterFunc = afterFunc;

        return this;
    }

    /**
     * Repeat max count
     *
     * Example:
     * new Job('test', R.debug).startNow().afterMinutes(30).repeat(3).schedule();
     * // Schedule a job that starts now, triggered after 30 minutes, for 3 times
     *
     * @param count The repeating count
     * @return Job
     * */
    public Job repeat(Integer count) {
        return this.repeatUntil(null, count);
    }

    /**
     * Repeat only once
     *
     * Example:
     * new Job('test', R.debug).startNow().afterMinutes(30).repeatOnce().schedule();
     * // Schedule a job that starts now, triggered after 30 minutes, for only 1 time
     *
     * @return Job
     * */
    public Job repeatOnce() {
        return this.repeat(1);
    }

    /**
     * Repeat forever
     *
     * Example:
     * new Job('test', R.debug).startNow().afterMinutes(30).repeatForever().schedule();
     * // Schedule a job that starts now, triggered after 30 minutes, running forever
     *
     * @return Job
     * */
    public Job repeatForever() {
        return this.repeat(-1);
    }

    /**
     * Repeat until func is satisfied
     * The func takes the current repeating number, and returns a Boolean
     * Returning true indicates that the repeating is finished
     *
     * Example:
     * new Job('test', R.debug).startNow().afterMinutes(30).repeatUntil(R.equals.apply(2)).schedule();
     * // Schedule a job that starts now, triggered after 30 minutes until repeating count reaches 2
     *
     * @param endFunc The func to stop the repeating
     * @return Job
     * */
    public Job repeatUntil(Func endFunc) {
        return this.repeatUntil(null, -1, endFunc);
    }

    /**
     * Repeat until the end datetime
     *
     * Example:
     * new Job('test', R.debug).startNow().afterMinutes(30).repeatUntil(Datetime.newInstance(2018, 10, 1)).schedule();
     * // Schedule a job that starts now, triggered after 30 minutes, repeating until 2018/10/01
     *
     * @param endDatetime The end datetime
     * @return Job
     * */
    public Job repeatUntil(Datetime endDatetime) {
        return this.repeatUntil(endDatetime, -1);
    }

    /**
     * Repeat until the end datetime or the max count is reached
     *
     * @param endDatetime The end datetime
     * @param count The max count
     * @return Job
     * */
    public Job repeatUntil(Datetime endDatetime, Integer count) {
        return this.repeatUntil(endDatetime, count, null);
    }

    /**
     * Repeat until the end datetime, or the max count is reached, or the end func is satisfied
     *
     * @param endDatetime The end datetime
     * @param count The max count
     * @param endFunc The end func
     * @return Job
     * */
    public Job repeatUntil(Datetime endDatetime, Integer count, Func endFunc) {
        this.endDatetime = endDatetime;
        this.repeatMax = count;
        this.endFunc = endFunc;
        this.repeatSet = true;

        this.doRepeat();

        return this;
    }

    /**
     * Check if the job is using repeating pattern
     *
     * @return Boolean
     * */
    public Boolean usingRepeat() {
        return this.startDatetime != null;
    }

    /**
     * Check if the job has set repeating
     *
     * @return Boolean
     * */
    public Boolean isRepeatSet() {
        return this.repeatSet;
    }

    /**
     * Get the next triggered datetime of the job
     * Only available for repeating pattern job
     *
     * @return Datetime
     * */
    public Datetime getNextDatetime() {
        if(!this.usingRepeat()) {
            throw new JobException('Only available when using repeat');
        }

        return this.nextDatetime;
    }

    /**
     * Get the generated cron expression
     *
     * @return String
     * */
    public String getCronExpression() {
        String cron = '';

        if(!cronInfo.second.isEmpty()) {
            cron += String.join(cronInfo.second, ',');
        }
        else {
            cron += '0';
        }

        cron += ' ';

        if(!cronInfo.minute.isEmpty()) {
            cron += String.join(cronInfo.minute, ',');
        }
        else {
            cron += '0';
        }

        cron += ' ';

        if(!cronInfo.hour.isEmpty()) {
            cron += String.join(cronInfo.hour, ',');
        }
        else {
            cron += '0';
        }

        cron += ' ';

        if(!cronInfo.day.isEmpty()) {
            cron += String.join(cronInfo.day, ',');
        }
        else {
            if(!cronInfo.dayOfWeek.isEmpty()) {
                cron += '?';
            }
            else {
                cron += '*';
            }
        }

        cron += ' ';

        if(!cronInfo.month.isEmpty()) {
            cron += String.join(cronInfo.month, ',');
        }
        else {
            cron += '*';
        }

        cron += ' ';

        if(!cronInfo.dayOfWeek.isEmpty()) {
            cron += String.join(cronInfo.dayOfWeek, ',');
        }
        else {
            cron += '?';
        }

        if(!cronInfo.year.isEmpty()) {
            cron += ' ';
            cron += String.join(cronInfo.year, ',');
        }

        return cron;
    }

    private void calculateNextDatetime(Datetime dt) {
        this.nextDatetime = dt;
        if(this.nextDatetime == null) {
            this.nextDatetime = this.startDatetime;
        }

        if(this.intervalInfo.seconds != 0) {
            this.nextDatetime = this.nextDatetime.addSeconds(this.intervalInfo.seconds);
        }

        if(this.intervalInfo.minutes != 0) {
            this.nextDatetime = this.nextDatetime.addMinutes(this.intervalInfo.minutes);
        }

        if(this.intervalInfo.hours != 0) {
            this.nextDatetime = this.nextDatetime.addHours(this.intervalInfo.hours);
        }

        if(this.intervalInfo.days != 0) {
            this.nextDatetime = Datetime.newInstance(this.nextDatetime.date().addDays(this.intervalInfo.days), this.nextDatetime.time());
        }

        if(this.intervalInfo.months != 0) {
            this.nextDatetime = Datetime.newInstance(this.nextDatetime.date().addMonths(this.intervalInfo.months), this.nextDatetime.time());
        }

        if(this.intervalInfo.years != 0) {
            this.nextDatetime = Datetime.newInstance(this.nextDatetime.date().addYears(this.intervalInfo.years), this.nextDatetime.time());
        }

        if(this.intervalInfo.intervalTime != 0) {
            this.nextDatetime = Datetime.newInstance(this.nextDatetime.getTime() + this.intervalInfo.intervalTime);
        }

        if(this.intervalInfo.afterFunc != null) {
            this.nextDatetime = Datetime.newInstance(this.nextDatetime.getTime() + (Long)R.toLong.run(this.intervalInfo.afterFunc.run(this.repeatNum)));
        }
    }

    private Boolean doRepeat() {
        this.calculateNextDatetime(this.nextDatetime);

        if(this.endDatetime == null || this.nextDatetime <= this.endDatetime) {
            if(this.repeatMax < 0 || this.repeatNum < this.repeatMax) {
                if(this.endFunc == null || !(Boolean)this.endFunc.run(this.repeatNum)) {
                    this.applyDatetime(this.nextDatetime);

                    return true;
                }
            }
        }

        return false;
    }

    private void validateStartDatetime() {
        if(startDatetime == null) {
            throw new JobException('Start date time is not set');
        }
    }

    private void validateSecond(Integer val) {
        if(val == null || val < 0 || val > 59) {
            throw new JobException('Invalid second field');
        }
    }

    private void validateMinute(Integer val) {
        if(val == null || val < 0 || val > 59) {
            throw new JobException('Invalid minute field');
        }
    }

    private void validateHour(Integer val) {
        if(val == null || val < 0 || val > 23) {
            throw new JobException('Invalid hour field');
        }
    }

    private void validateDay(Integer val) {
        if(val == null || val < 1 || val > 31) {
            throw new JobException('Invalid day field');
        }
    }

    private void validateMonth(Integer val) {
        if(val == null || val < 1 || val > 12) {
            throw new JobException('Invalid month field');
        }
    }

    private void validateDayOfWeek(Integer val) {
        if(val == null || val < 1 || val > 7) {
            throw new JobException('Invalid day of week field');
        }
    }

    private void validateYear(Integer val) {
        if(val == null || val < 1970 || val > 2099) {
            throw new JobException('Invalid year field');
        }
    }

    private Integer getMonth(Object val) {
        Integer month = null;

        if(val instanceof Integer) {
            month = (Integer)val;
        }
        else if(val instanceof String) {
            String str = (String)val;

            List<String> matched = new List<String>();
            for(String monthName : MONTH_NAMES) {
                if(monthName.toUpperCase().startsWith(str.toUpperCase()) ||
                        str.toUpperCase().startsWith(monthName.toUpperCase())) {
                    matched.add(monthName);
                }
            }

            if(matched.size() == 1) {
                String monthName = matched.get(0);
                month = MONTH_NAMES.indexOf(monthName) + 1;
            }
        }

        return month;
    }

    // 1..7 for Mon..Sun
    private Integer getDayOfWeek(Object val) {
        Integer dayOfWeek = null;

        if(val instanceof Integer) {
            dayOfWeek = (Integer)val;
            dayOfWeek += 1;
            if(dayOfWeek == 8) {
                dayOfWeek = 1;
            }
        }
        else if(val instanceof String) {
            String str = (String)val;

            List<String> matched = new List<String>();
            for(String dayOfWeekName : DAY_OF_WEEK_NAMES) {
                if(dayOfWeekName.toUpperCase().startsWith(str.toUpperCase()) ||
                        str.toUpperCase().startsWith(dayOfWeekName.toUpperCase())) {
                    matched.add(dayOfWeekName);
                }
            }

            if(matched.size() == 1) {
                String dayOfWeekName = matched.get(0);
                dayOfWeek = DAY_OF_WEEK_NAMES.indexOf(dayOfWeekName) + 1;
            }
        }

        return dayOfWeek;
    }

    private void applyDatetime(Datetime dt) {
        cronInfo.second = new List<String>{ String.valueOf(dt.second()) };
        cronInfo.minute = new List<String>{ String.valueOf(dt.minute()) };
        cronInfo.hour = new List<String>{ String.valueOf(dt.hour()) };
        cronInfo.day = new List<String>{ String.valueOf(dt.day()) };
        cronInfo.month = new List<String>{ String.valueOf(dt.month()) };
        cronInfo.year = new List<String>{ String.valueOf(dt.year()) };
    }

    private static final List<String> MONTH_NAMES = new List<String>{
        'JAN',
        'FEB',
        'MAR',
        'APR',
        'MAY',
        'JUN',
        'JUL',
        'AUG',
        'SEP',
        'OCT',
        'NOV',
        'DEC'
    };

    private static final List<String> DAY_OF_WEEK_NAMES = new List<String>{
        'SUN',
        'MON',
        'TUE',
        'WED',
        'THU',
        'FRI',
        'SAT'
    };

    private class CronInfo {
        public List<String> second = new List<String>();
        public List<String> minute = new List<String>();
        public List<String> hour = new List<String>();
        public List<String> day = new List<String>();
        public List<String> month = new List<String>();
        public List<String> dayOfWeek = new List<String>();
        public List<String> year = new List<String>();
    }

    private class IntervalInfo {
        public Integer seconds = 0;
        public Integer minutes = 0;
        public Integer hours = 0;
        public Integer days = 0;
        public Integer months = 0;
        public Integer years = 0;
        public Long intervalTime = 0;
        public Func afterFunc = null;
    }

    private class SchedulableFunc extends Func {
        private Schedulable mSchedulable;

        public SchedulableFunc(Schedulable mSchedulable) {
            this.mSchedulable = mSchedulable;
        }

        public override Object exec(Object arg) {
            this.mSchedulable.execute((SchedulableContext)arg);

            return null;
        }
    }

    public class JobException extends Exception {
    }
}
