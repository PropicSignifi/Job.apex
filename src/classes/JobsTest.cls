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
private class JobsTest {
    @isTest
    private static void instanceTest() {
        System.assert(Jobs.getInstance() != null);
    }

    @isTest
    private static void scheduleTest() {
        Test.startTest();

        Id id = new Job('test', R.debug)
            .startNow()
            .afterSeconds(1)
            .repeatOnce()
            .schedule();
        CronTrigger ct = Jobs.getInstance().getCronTriggerByName('test');
        System.assert(ct != null);

        ct = Jobs.getInstance().getCronTriggerById(id);
        System.assert(ct != null);

        System.assert(!Jobs.getInstance().getCronTriggers().isEmpty());

        Jobs.getInstance().unscheduleById(id);

        ct = Jobs.getInstance().getCronTriggerById(id);
        System.assert(ct == null);

        Job newJob = new Job('newJob', R.debug)
            .startNow()
            .afterMinutes(30)
            .repeatOnce();
        Jobs.getInstance().reschedule(newJob);

        Jobs.getInstance().unscheduleByName('newJob');

        Test.stopTest();
    }
}
