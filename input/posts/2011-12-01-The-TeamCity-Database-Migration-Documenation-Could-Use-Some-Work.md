---
layout: post
title: 'The TeamCity Database Migration Documenation Could Use Some Work'
tags: ['Uncategorized', 'msmvps', 'December 2011']
---
[Source](http://blogs.msmvps.com/peterritchie/2011/12/01/the-teamcity-database-migration-documenation-could-use-some-work/ "Permalink to The TeamCity Database Migration Documenation Could Use Some Work")

# The TeamCity Database Migration Documenation Could Use Some Work

I have a client who wants all the benefits of [ALM][1] but doesn't really want to spend the money on them. They're a start-up; so, I can respect that. As a result, I've been getting them up and running with some of the freely-available and open-source tools. They're also cross-platform, so getting on some of the great Microsoft programs like [BizSpark][2] and [WebsiteSpark][3] wasn't really in the cards.

Anywho… One of those tools was [TeamCity][4]. It's a great too for Continuous Integration and Deployment. I've used it with a couple of clients now and have nothing but good things to say about it. When I installed it, I probably read some yellow box talking about _HSQLDB_ and _External Database_ and _evaluating the system_ and _production_; but, honestly, just follow the steps. :). I created several configurations and had artifacts and build logs, so upgrading needed to include backup and restore… I had a couple spare cycles to look into migrating to an external database (as well as run through a backup/restore cycle) so I thought I might as well bite the bullet.

Well, the title of the post explains it. I'm not going to go too much into the [existing documentation][5] and how it jumps from page to page before you actually get a migration done; I'm just going to say there wasn't just a single list of steps (and, I think a couple things were missing). There's support for multiple platforms and multiple databases, so I get it's _hard_. It's seemed a bit too hard; so, I'm going to detail the process of migrating a TeamCity database to a SQL Server Express database here in case anyone else might find it useful.

[NOTE: I did this with TeamCity 6.5.4 build 18046, YMMV]

First off, **backup**. I did this from the web interface. I clicked on the _Administration_ link near the top right, clicked the _Backup Data_ link on the right-hand list, selected "_Custom_" scope and checked _everything_. This created a zip file in the backup directory in the [TeamCity data directory][6]. For me, this was C:TeamCity.BuildServerbackupTeamCity_Backup_20111130_210020.zip—but, yours will be different.

After doing a TeamCity backup, **stop the TeamCity services**. (Start menu, Control Panel, … you know the drill … or net stop TCBuildAgent and net stop TeamCity from a command prompt).

Next, I did a file system backup. I just copied the TeamCity directory to another folder. I had installed TeamCity to C:TeamCity. I think the default was my user folder; but, I'm only at my client for a limited time and when I'm gone that's going to cause a bit of grief (yeah, it happened :), so that meant copying C:TeamCity to somewhere else on C:. I've digressed from the the Jetbrains instructions already…

Next, I **set up the external SQL Server Express database**. I already had SQL Server 2005 Express installed, so, I won't go through that installation process. In _SQL Server Management Studio_ I created a "TeamCity" database, and added a "TeamCity" login—you'll need those _later_.

Next, I **installed some JDBC drivers for SQL Server**. I just grabbed the Microsoft ones—the "Native" driver—I figured they might know a thing or two about writing a SQL Server driver. I downloaded from [here][7]. I unzipped (or ran the EXE) into a directory then copied the sqljdbc4.jar file into the libjdbc TeamCity data sub-directory (which was C:TeamCity.BuildServerlibJDBC for me).

Next, I **configured TeamCity to use SQL Server**. I created a database.properties file in the config data folder (C:TeamCity.BuildServerconfig, for me). It's _later_: the file was similar to:

connectionUrl=jdbc:sqlserver://localhost\sqlexpress:1433;databaseName=TeamCity   
connectionProperties.user=TeamCity   
connectionProperties.password=P@nda$

…names and passwords might have been changed to protect the pandas. Since I'm using SQL Express I had to throw the \sqlexpress named-instance stuff in there. If you're using a different named instance, the"sqlexpress" part will be different. If you're using a "real" install of SQL Server, you don't need the "\sqlexpress" part at all, e.g. "//localhost:1433". I also had to throw the :1433 stuff in there (long story), you may not need that.

At this point, be sure not to be running the TeamCity services and don't even think about logging into the TeamCity web interface (well, you can't if the server isn't running). As far as TeamCity is concerned at this point, you've got a fresh install. If you log in now it will ask you to create an Administrator login and create all the database tables. The next step requires an empty database and will _fail_ if you do create that login…

Now, restore. Okay, I lied, this is one of those parts where the documentation has misled you. The restore requires that you have an empty config directory—i.e. you can't have database.properties in the config directory. You also need an empty system directory (CTeamCity.BuildServersystem for me)—a fresh install might mean those directories are empty, I don't know. I simply **renamed config to config-old and system to system-old and created new config and system directories**. _Then_, I had to **add the Java bin directory to the PATH**. TeamCity has all the Java binaries included with it—it doesn't actually install Java (oh, BTW, TeamCity uses Java). For me, I just ran path=%path%;c:TeamCityjrebin to let the command prompt know where java.exe is. If you have Java installed, you might not need to do this. _Then_, I performed a **restore**; which is just a matter of running maintainDB with the _restore_ command from the TeamCity bin directory (C:TeamCitybin directory—note no ".BuildServer"—for me):

C:TeamCitybin>maintainDB.cmd restore -F c:TeamCity.BuildServerbackupTeamCity_Backup_20111130_210020.zip -A c:TeamCity.BuildServer -T C:TeamCity.BuildServerconfig-olddatabase.properties 

…which tells TeamCity to restore from my backup (zip) file, where the data directory is, and what database configuration to use (note the config-old business). Either TeamCity or Java doesn't grok relative directories; so, note that I used "C:TeamCity" instead of "..".

Once the restore is done (and it's kind enough to remind you :), **copy the database.properties file that you used to the config directory** (for me, this was just copy ...BuildServerconfig-olddatabase.properties ...BuildServerconfig ).

Then, **restart the TeamCity services**:

C:TeamCitybin>net start TCBuildAgent   
C:TeamCitybin>net start TeamCity 

And you're done. If you can now log into the TeamCity web interface with all your old logins and all your old configurations are still there… I did a bit of housework by deleting config-old, system-old, and went ahead and deleted the C:TeamCity copy that I made. (I don't need that, now that I've migrated to SQL Server and verified that everything works).

_If_ you ran into a problem along the way, you _could_ simply copy the backed-up TeamCity directory over-top the old one (making sure the services were stopped first) and you _should_ be back to where you were before. I didn't have a problem, so I can't confirm that actually works; but the docs [detail that it does][8].

Since you have to have an empty database and empty config/system directories, I gather the actual restore process would be identical (minus dropping all the tables in the TeamCity SQL Server database).

[1]: http://bit.ly/taJxZg
[2]: http://bit.ly/t4MS1w
[3]: http://bit.ly/v5sCg5
[4]: http://www.jetbrains.com/teamcity/
[5]: http://bit.ly/rUhR9G
[6]: http://bit.ly/vJCQjz
[7]: http://bit.ly/vZzMQr
[8]: http://bit.ly/s4fK4I


