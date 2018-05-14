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
@isTest
private class JobTest {
    @isTest
    private static void instanceTest() {
        Job j = new Job('test', R.debug);
        System.assertEquals('0 0 0 * * ?', j.getCronExpression());
    }

    @isTest
    private static void secondTest() {
        Job j = new Job('test', R.debug).atSecond(30);
        System.assertEquals('30 0 0 * * ?', j.getCronExpression());
    }

    @isTest
    private static void minuteTest() {
        Job j = new Job('test', R.debug).atMinute(30);
        System.assertEquals('0 30 0 * * ?', j.getCronExpression());
    }

    @isTest
    private static void hourTest() {
        Job j = new Job('test', R.debug).atHour(10);
        System.assertEquals('0 0 10 * * ?', j.getCronExpression());
    }

    @isTest
    private static void onDayTest() {
        Job j = new Job('test', R.debug).onDay(10);
        System.assertEquals('0 0 0 10 * ?', j.getCronExpression());
    }

    @isTest
    private static void onDaysTest() {
        Job j = new Job('test', R.debug).onDays(new List<Integer>{ 10, 20 });
        System.assertEquals('0 0 0 10,20 * ?', j.getCronExpression());
    }

    @isTest
    private static void betweenDaysTest() {
        Job j = new Job('test', R.debug).betweenDays(5, 10);
        System.assertEquals('0 0 0 5-10 * ?', j.getCronExpression());
    }

    @isTest
    private static void everyDayTest() {
        Job j = new Job('test', R.debug).everyDay();
        System.assertEquals('0 0 0 * * ?', j.getCronExpression());
    }

    @isTest
    private static void everyDaysTest() {
        Job j = new Job('test', R.debug).fromDay(1).everyDays(2);
        System.assertEquals('0 0 0 1/2 * ?', j.getCronExpression());

        j = new Job('test', R.debug).betweenDays(1, 15).everyDays(2);
        System.assertEquals('0 0 0 1-15/2 * ?', j.getCronExpression());
    }

    @isTest
    private static void inMonthTest() {
        Job j = new Job('test', R.debug).inMonth('Janu');
        System.assertEquals('0 0 0 * 1 ?', j.getCronExpression());
    }

    @isTest
    private static void inMonthsTest() {
        Job j = new Job('test', R.debug).inMonths(new List<Object>{ 1, 'Feb' });
        System.assertEquals('0 0 0 * 1,2 ?', j.getCronExpression());
    }

    @isTest
    private static void betweenMonthsTest() {
        Job j = new Job('test', R.debug).betweenMonths(1, 3);
        System.assertEquals('0 0 0 * 1-3 ?', j.getCronExpression());
    }

    @isTest
    private static void everyMonthTest() {
        Job j = new Job('test', R.debug).everyMonth();
        System.assertEquals('0 0 0 * * ?', j.getCronExpression());
    }

    @isTest
    private static void everyMonthsTest() {
        Job j = new Job('test', R.debug).fromMonth('March').everyMonths(2);
        System.assertEquals('0 0 0 * 3/2 ?', j.getCronExpression());

        j = new Job('test', R.debug).betweenMonths('Apr', 12).everyMonths(2);
        System.assertEquals('0 0 0 * 4-12/2 ?', j.getCronExpression());
    }

    @isTest
    private static void onDayOfWeekTest() {
        Job j = new Job('test', R.debug).onDayOfWeek('Sun');
        System.assertEquals('0 0 0 ? * 1', j.getCronExpression());
    }

    @isTest
    private static void onDaysOfWeekTest() {
        Job j = new Job('test', R.debug).onDaysOfWeek(new List<Object>{ 2, 3 });
        System.assertEquals('0 0 0 ? * 3,4', j.getCronExpression());
    }

    @isTest
    private static void betweenDaysOfWeekTest() {
        Job j = new Job('test', R.debug).betweenDaysOfWeek('Tue', 'Thur');
        System.assertEquals('0 0 0 ? * 3-5', j.getCronExpression());
    }

    @isTest
    private static void everyDayOfWeekTest() {
        Job j = new Job('test', R.debug).everyDayOfWeek();
        System.assertEquals('0 0 0 ? * *', j.getCronExpression());
    }

    @isTest
    private static void everyDaysOfWeekTest() {
        Job j = new Job('test', R.debug).fromDayOfWeek('Mon').everyDaysOfWeek(2);
        System.assertEquals('0 0 0 ? * 2/2', j.getCronExpression());

        j = new Job('test', R.debug).betweenDaysOfWeek(1, 5).everyDaysOfWeek(2);
        System.assertEquals('0 0 0 ? * 2-6/2', j.getCronExpression());
    }

    @isTest
    private static void inYearTest() {
        Job j = new Job('test', R.debug).inYear(2018);
        System.assertEquals('0 0 0 * * ? 2018', j.getCronExpression());
    }

    @isTest
    private static void inYearsTest() {
        Job j = new Job('test', R.debug).inYears(new List<Integer>{ 2018, 2019 });
        System.assertEquals('0 0 0 * * ? 2018,2019', j.getCronExpression());
    }

    @isTest
    private static void betweenYearsTest() {
        Job j = new Job('test', R.debug).betweenYears(2018, 2020);
        System.assertEquals('0 0 0 * * ? 2018-2020', j.getCronExpression());
    }

    @isTest
    private static void everyYearTest() {
        Job j = new Job('test', R.debug).everyYear();
        System.assertEquals('0 0 0 * * ? *', j.getCronExpression());
    }

    @isTest
    private static void everyYearsTest() {
        Job j = new Job('test', R.debug).fromYear(2018).everyYears(2);
        System.assertEquals('0 0 0 * * ? 2018/2', j.getCronExpression());

        j = new Job('test', R.debug).betweenYears(2018, 2050).everyYears(2);
        System.assertEquals('0 0 0 * * ? 2018-2050/2', j.getCronExpression());
    }

    @isTest
    private static void afterSecondsTest() {
        Job j = new Job('test', R.debug).startAt(Datetime.newInstance(2018, 3, 1, 0, 0, 0)).afterSeconds(10).repeatOnce();
        System.assertEquals('10 0 0 1 3 ? 2018', j.getCronExpression());
    }

    @isTest
    private static void afterMinutesTest() {
        Job j = new Job('test', R.debug).startAt(Datetime.newInstance(2018, 3, 1, 0, 0, 0)).afterMinutes(10).repeatOnce();
        System.assertEquals('0 10 0 1 3 ? 2018', j.getCronExpression());
    }

    @isTest
    private static void afterHoursTest() {
        Job j = new Job('test', R.debug).startAt(Datetime.newInstance(2018, 3, 1, 0, 0, 0)).afterHours(10).repeatOnce();
        System.assertEquals('0 0 10 1 3 ? 2018', j.getCronExpression());
    }

    @isTest
    private static void afterDaysTest() {
        Job j = new Job('test', R.debug).startAt(Datetime.newInstance(2018, 3, 1, 0, 0, 0)).afterDays(10).repeatOnce();
        System.assertEquals('0 0 0 11 3 ? 2018', j.getCronExpression());
    }

    @isTest
    private static void afterMonthsTest() {
        Job j = new Job('test', R.debug).startAt(Datetime.newInstance(2018, 3, 1, 0, 0, 0)).afterMonths(4).repeatOnce();
        System.assertEquals('0 0 0 1 7 ? 2018', j.getCronExpression());
    }

    @isTest
    private static void afterYearsTest() {
        Job j = new Job('test', R.debug).startAt(Datetime.newInstance(2018, 3, 1, 0, 0, 0)).afterYears(5).repeatOnce();
        System.assertEquals('0 0 0 1 3 ? 2023', j.getCronExpression());
    }

    @isTest
    private static void afterTimeTest() {
        Job j = new Job('test', R.debug).startAt(Datetime.newInstance(2018, 3, 1, 0, 0, 0)).afterTime(1000).repeatOnce();
        System.assertEquals('1 0 0 1 3 ? 2018', j.getCronExpression());
    }

    @isTest
    private static void onLastDayOfMonthTest() {
        Job j = new Job('test', R.debug).inMonth('Jan').onLastDayOfMonth();
        System.assertEquals('0 0 0 L 1 ?', j.getCronExpression());
    }

    @isTest
    private static void onLastWeekdayOfMonthTest() {
        Job j = new Job('test', R.debug).inMonth('Jan').onLastWeekdayOfMonth();
        System.assertEquals('0 0 0 LW 1 ?', j.getCronExpression());
    }

    @isTest
    private static void onNearestWeekdayTest() {
        Job j = new Job('test', R.debug).inMonth('Jan').onNearestWeekday(1);
        System.assertEquals('0 0 0 1W 1 ?', j.getCronExpression());
    }

    @isTest
    private static void onFirstTest() {
        Job j = new Job('test', R.debug).inMonth('Jan').on1st('Sun');
        System.assertEquals('0 0 0 ? 1 1#1', j.getCronExpression());
    }

    @isTest
    private static void onLastTest() {
        Job j = new Job('test', R.debug).inMonth('Jan').onLast('Sun');
        System.assertEquals('0 0 0 ? 1 1L', j.getCronExpression());
    }

    @isTest
    private static void cronTest() {
        Job j = new Job('test', R.debug).cron('0 0 0 1 1 ?');
        System.assertEquals('0 0 0 1 1 ?', j.getCronExpression());
    }
}
