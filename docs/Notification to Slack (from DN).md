# Notification to Slack (from DN)

*This document describes the rules for the notification of incidents to Slack.*

Link to prod alerting (HOT slack): [here](https://hotosm.slack.com/archives/CL610HD9T "https://hotosm.slack.com/archives/CL610HD9T").

Link to test alerting (internal Kontur): [here](https://konturio.slack.com/archives/CPV08QKU7 "https://konturio.slack.com/archives/CPV08QKU7").

### **Business requirements:**
* slack notifications are needed only for [HOT](https://www.hotosm.org/ "https://www.hotosm.org/");
* we sometimes need to remind HOT about ourselves so that they go to [Disaster ninja](https://disaster.ninja/ "https://disaster.ninja/") when something new happens;
* we need to be faster than all other notification systems in terms of delivery speed;
* we don't need to send too many notifications, so as not to be annoying for users, if possible, sending only those that are interesting to look at in [Disaster ninja](https://disaster.ninja/ "https://disaster.ninja/"). The **number of notifications** per day that we strive for is about **2**.

### **Rules for notifications:**

|     |     |
| --- | --- |
| **Sources of notifications** | all stages (dev, test, prod): gdacs, firms (feed 'disaster-ninja-02') |
| **Severity level\*** | EXTREME, SEVERE, MODERATE |
| **Population** | Events with population only (>=500ppl) for the latest episode |
| **Event types** | FLOOD, WILDFIRE, EARTHQUAKE, CYCLONE, VOLCANO |
| **Name\*\*** | feed_data.name |
| **Description** | feed_data.description |

\* **Severity level** should refer to the **current** state of the event; it is Kontur severities, see doc[[Tasks/document: Severities - Kontur Event API#^b2d59af0-3b70-11e9-be77-04d77e8d50cb/923d2200-f1c6-11ea-b41c-f70bccf9516d]])

\*\* **Name** is a link to disaster.ninja map. The link leads to the last state of the event.

### **Schedule:**

1. the DN backend sends a request Event API for the last updated events ***once per minute*** (limit 1);
2. **as is:** 
   * check last updated event → if it has not the same "updated_at" that was last notified 
     * check population: if event exposes > 500ppl → send notification
     * else try to find the earlier event (for the last minute) (repeat 100 times)
   * *if there are several updated events, we alert just about one last updated (if it is not an event with the same "updated_at" that was last notified)*
3. **to be:** if there are several updated events, we alert about each of them ([[Tasks/Task: Process all updated events for notifications#^7b708802-3c0b-11e9-9428-04d77e8d50cb/f5d94290-f8fe-11eb-9cb2-a7b1a010fff4]]);

### **Analytic in notifications:**

|     |     |
| --- | --- |
| **Name** | **Description** |
| Urban core, population | analytic from the current episode, from population api |
| Urban core, area |
| Total population | analytic from the current episode,  from event api (episodeDetails) |
| Area of the total population |
| Industrial area | for the current episode and for the event.  from event api (episodeDetails, event_details) rules: show only rows with non-zero values; if value for 'currently' = 'from beginning' ('episode'='event' for hotspotDaysPerYearMax) → show only one value without text in brackets; show hotspotDaysPerYearMax only for events with only 'WILDFIRE' type    |
| Forest area |
| Max "fires" days (for wildfires only) |

All parameters:

|     |     |
| --- | --- |
| **Text** | **Source of variable** |
| :cityscape: Urban core: <> people on | episode.episodeDetails.urbanCorePopulation |
| <> km². | episode.episodeDetails.urbanCoreAreaKm2 |
| :man-woman-girl-boy: Total population: <> people | episode.episodeDetails.population |
| on <> km². | episode.episodeDetails.totalPopulatedAreaKm2 |
| :factory: Industrial area: <> km² (currently),  | episode.episodeDetails.industrialAreaKm2 |
| <> km² (from beginning). | eventDetails.industrialAreaKm2 |
| :deciduous_tree: Forest area: <> km² (currently),  | episode.episodeDetails.forestAreaKm2 |
| <> km² (event). | eventDetails.forestAreaKm2 |
| :sparkles: Wildfire days in last year: <> (episode),  | episode.episodeDetails.hotspotDaysPerYearMax |
| <> (event). | eventDetails.hotspotDaysPerYearMax |

### **Notes**

It may happen that the old (ended) event has been updated and the notification has come by the past event - check if the end date of the event is earlier than a week or so of the current date

we do not send notification about gdacs event if event finished more than 7 days before today (?)

Notifications are sent about previously important, but now with a lower severity level, events.

We do not send several notification about one event during one day. If one event updates several times - we send just one. 
* Disaster digest:**

If we do not have any notification for 1 day, at the end of the day we send digest with not severe events as a Slack notification:
* **header**: Disaster digest for {date} (no severe events happened during this time);
* **content**: disaster names (=links) without description, separate row for each event;
* **events order**: from old to new, by updated date;
* The following events go to the digest:**
* events with current moderate severity level;
* events that was updated no earlier than 1 day ago (last 24 hours).
* max 7 events in digest <TBD>

*Date format mm/dd/yyyy.*

If we do not have appropriate disasters for digest we send notification with header: Good news! No extreme or severe events happened for {date}. or do not sent nothing
