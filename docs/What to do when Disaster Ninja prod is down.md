# What to do when Disaster Ninja prod is down

Field: Content

This document covers steps to be taken when Disaster Ninja prod is down.

There is a general document [[Tasks/document: What to do if prod is down#^b2d59af0-3b70-11e9-be77-04d77e8d50cb/a1894850-6958-11ec-8185-9d8d37150fe4]]  

1. Notify the team in Slack channel #disaster_ninja using the tag "here" 
2. Ping a responsible person in Slack 
3. Create an issue with type == `Production issue` priority = `Emergency `and assign the project manager/business analyst and the responsible person for the part which supposably caused the issue
4. Try to collect as many evidence as possible: server logs of crashing, time of crashing, request that were performed, etc. For example:
   1. [https://grafana02.kontur.io](https://grafana02.kontur.io/) - for Disaster Ninja and some external services 
   2. [https://grafana01.kontur.io](https://grafana01.kontur.io/d/2M2D9_p7k/dn2-dashboard?orgId=1&from=now-1h&to=now&var-environment=prod) - for external services 
5. As the application is already in Kubernetes it should not be a long downtime. A new pod in Kubernetes should be created automatically. Still this document can be of use  [[Tasks/document: How to restart an app in k8s#^b2d59af0-3b70-11e9-be77-04d77e8d50cb/2dbc3480-b9b9-11ec-beaa-6dcbc6ebb5c6]] . If the problem remains jump  to the point 7 in this document. 
6. Still Disaster Ninja uses a lot of external services and some of them can be down:
   1. **EventAPI** - affects on Panel with Disasters → Current Disaster → Panel with Analytics → Panel with Layers [[Tasks/document: What to do if event-api prod is down#^b2d59af0-3b70-11e9-be77-04d77e8d50cb/6ad78f90-2c15-11ec-afb8-f54a2374a7cc]] \
      \
      Inform Disasters Team in Slack #event-api with the tag "here". \
      \
      If you can, restart the application [[Tasks/document: How to restart Event API#^b2d59af0-3b70-11e9-be77-04d77e8d50cb/19c00640-3c83-11ec-a815-cdff0c56b0c0]] 
   2. **InsightsAPI** - affects on Panel with Analytics (+Advanced Analytics), Bivariate Manager, Bivariate presets, Urban Core and Settled Periphery layers \
      \
      The application is in Kubernetes as well so it should restart itself (look at point 5). If the problem remain go to the point 7 in this documents. \
      \
      Inform Insights Team in Slack #team-insights with the tag "here".\
      If you can, restart the application [[Tasks/document: What to do if prod is down#^b2d59af0-3b70-11e9-be77-04d77e8d50cb/a1894850-6958-11ec-8185-9d8d37150fe4]] 
   3. **kcAPI** - affects on Layers (e.g. external Layers form Editor Layer Index) and Admin Boundaries \
      \
      The application is going to be shut down ([[Tasks/User Story: Migrate kcapi to Layers DB#^7a8452d0-8558-11ea-8035-51799a2fd608/39934ca0-c1dd-11eb-ad34-0906196a3a54]]) and the responsibility should be taken by Layers API \
      \
      Inform Map_Viewer Team or Layers Teams in Slack #team-map-viewer or #team-layers or #gis with the tag "here".\
      \
      If you can, restart the application [[Tasks/document: What to do if prod is down#^b2d59af0-3b70-11e9-be77-04d77e8d50cb/a1894850-6958-11ec-8185-9d8d37150fe4]].
   4. **LayersAPI** - affects on some layers (HOT projects, Active Contributors layer - soon, layers related to some events (e.g. Humanitarian Crisis In Ukraine) \
      \
      Later most of layers are expected to come from Layers API\
      \
      Inform Map_Viewer Team or Layers Teams in Slack #team-map-viewer or #team-layers or #gis with the tag "here".\
      \
      If you can, restart the application [[Tasks/document: What to do if prod is down#^b2d59af0-3b70-11e9-be77-04d77e8d50cb/a1894850-6958-11ec-8185-9d8d37150fe4]].
   5. **User-Profile-Service** - affects on features on Disaster Ninja, ability to log in.\
      \
      Inform Map_Viewer Team or Layers Teams in Slack #team-map-viewer or #team-layers or #gis with the tag "here".\
      \
      If you can, restart the application [[Tasks/document: What to do if prod is down#^b2d59af0-3b70-11e9-be77-04d77e8d50cb/a1894850-6958-11ec-8185-9d8d37150fe4]].
   6. **Keyclock -** affects possibility to log in, panel with disasters\
      \
      Inform Map_Viewer Team or Operations Teams in Slack #team-map-viewer or #operations with the tag "here".\
      \
      If you can, restart the application [[Tasks/document: What to do if prod is down#^b2d59af0-3b70-11e9-be77-04d77e8d50cb/a1894850-6958-11ec-8185-9d8d37150fe4]] 
   7. **Basemap** - affects basemap on Disaster Ninja \
      \
      Inform Map_Viewer Team or Operations Teams in Slack #team-map-viewer or #operations with the tag "here".
   8. **Reports** - reports will unavailable on Disaster Ninja \
      \
      Inform Map_Viewer Team or Layers Teams in Slack #team-map-viewer or #team-layers or #gis with the tag "here".
7. If the problem persists after restarting the application and is no activity on the problem -  try to reach the responsible person using not only slack and Fibery. \
   Contact responsible person via a channel from column "For emergency (prod is down)"  [[Tasks/document: How to reach any of team members#^b2d59af0-3b70-11e9-be77-04d77e8d50cb/aa404960-4124-11eb-8275-7f1ebd76bb4e]]. 
8. After eliminating the incident, write a report for Disaster Ninja project as a document and name it "Prod Incident date". The project manager/business analyst is responsible for the document. The document should be discussed on teams' and general retros. 
* What happened? 
* How was it fixed (general description and technical details)?
* Why did this problem occur (broken process, technical issue, third-party etc)? 
* What needs to be done  in processes/approaches etc so that it does not arise in the future?
