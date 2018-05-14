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
 * A helper class to manage jobs
 * */
public class Jobs {
    private static Jobs INSTANCE = new Jobs();

    private static final String QUERY_CRON_TRIGGER = 'Select Id, CronJobDetail.Name, State, NextFireTime From CronTrigger';

    private Jobs() {
    }

    public static Jobs getInstance() {
        return INSTANCE;
    }

    /**
     * Get cron trigger by id
     *
     * @param id The cron trigger id
     * @return CronTrigger
     * */
    public CronTrigger getCronTriggerById(Id id) {
        String queryString = QUERY_CRON_TRIGGER + ' where Id=: id';

        List<CronTrigger> triggers = database.query(queryString);

        return triggers.isEmpty() ? null : triggers.get(0);
    }

    /**
     * Get the cron trigger by name
     *
     * @param name The name
     * @return CronTrigger
     * */
    public CronTrigger getCronTriggerByName(String name) {
        String queryString = QUERY_CRON_TRIGGER + ' where CronJobDetail.Name=: name';

        List<CronTrigger> triggers = database.query(queryString);

        return triggers.isEmpty() ? null : triggers.get(0);
    }

    /**
     * Get all the cron triggers
     *
     * @return List<CronTrigger>
     * */
    public List<CronTrigger> getCronTriggers() {
        String queryString = QUERY_CRON_TRIGGER;

        return database.query(queryString);
    }

    /**
     * Get all cron triggers with matched name
     *
     * @param name The name
     * @return List<CronTrigger>
     * */
    public List<CronTrigger> getCronTriggers(String name) {
        String queryString = QUERY_CRON_TRIGGER + ' where CronJobDetail.Name Like: name';

        return database.query(queryString);
    }

    /**
     * Clean the job by deleting any exising jobs
     *
     * @param jobName The job name
     * */
    public void clean(String jobName) {
        CronTrigger cronTrigger = this.getCronTriggerByName(jobName);

        if(cronTrigger != null) {
            this.unschedule(cronTrigger);
        }
    }

    /**
     * Schedule the job
     *
     * For repeating pattern jobs, if the next datetime is before current datetime, an extra 60 seconds will be applied
     *
     * @param j The job
     * @return job id
     * */
    public String schedule(Job j) {
        if(j != null) {
            if(j.usingRepeat() && !j.isRepeatSet()) {
                j.repeatOnce();
            }

            String jobName = j.getName();

            this.clean(jobName);

            if(j.usingRepeat()) {
                Datetime now = Datetime.now();

                if(j.getNextDatetime() < now) {
                    return System.schedule(jobName, getCronExpression(now.addSeconds(60)), j);
                }
                else {
                    return System.schedule(jobName, j.getCronExpression(), j);
                }
            }
            else {
                return System.schedule(jobName, j.getCronExpression(), j);
            }
        }

        return null;
    }

    /**
     * Unschedule the cron trigger
     *
     * @param cronTrigger The cron trigger
     * */
    public void unschedule(CronTrigger cronTrigger) {
        System.abortJob(cronTrigger.Id);
    }

    /**
     * Unschedule the job by id
     *
     * @param id The job id
     * */
    public void unscheduleById(Id id) {
        CronTrigger cronTrigger = this.getCronTriggerById(id);

        if(cronTrigger != null) {
            this.unschedule(cronTrigger);
        }
    }

    /**
     * Unschedule the job by name
     *
     * @param jobName The job name
     * */
    public void unscheduleByName(String jobName) {
        CronTrigger cronTrigger = this.getCronTriggerByName(jobName);

        if(cronTrigger != null) {
            this.unschedule(cronTrigger);
        }
    }

    /**
     * Reschedule the job
     *
     * @param j The job
     * @return job id
     * */
    public String reschedule(Job j) {
        if(j != null) {
            String jobName = j.getName();

            this.unscheduleByName(jobName);

            return this.schedule(j);
        }

        return null;
    }

    private String getCronExpression(Datetime dt) {
        return '' + dt.second() + ' ' + dt.minute() + ' ' + dt.hour() + ' ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
    }
}
