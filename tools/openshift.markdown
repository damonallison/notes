# OpenShift Notes #

username : damon@damonallison.com
password : All4me11

* "For now, Node.js applications provide most streamline WebSockets support on OpenShift."

***

The OpenShift `ruby` cartridge documentation can be found at:

https://github.com/openshift/origin-server/tree/master/cartridges/openshift-origin-cartridge-ruby/README.md



# Lake Monster Inventory #

## Rails ##

# clean out our DB
$ rake db:reset

#### OpenShift ####

* OpenShift gives you 3 gears by default. You can combine all gears for a single
app, or use 1 gear per app.
* Gear = 512MB / 100MB swap / 1GB


##### useful commands #####

$ rhc app create -n lakemonster -s --enable-jenkins -a playground ruby-1.9
-s (sets scaling = yes for this app - **you need to do this at app creation time**)
--enable-jenkins (will spin up a jenkins app w/ build for this app)

$ rhc cartridge list
$ rhc cartridge add -a **app-name** **cartridge-name**

# show all domain / app info
$ rhc domain show

# ssh ftw
$ rhc ssh **app_name**

# clone an git repo from an app
$ rhc git-clone **app-name**

# stop auto-deploy on git push
$ rhc configure-app -a App_Name --no-auto-deploy

# configure the app to keep x number of deployments (for rollback)
$ rhc configure-app -a App_Name --keep-deployments **number-of-deployments**

# change the branch in which to deploy from
$ rhc configure-app -a App_Name deployment-branch Git_Branch

$ rhc deployments **app-name**
$ rhc activate-deployment **deployment**


## Security / OAuth ##

Basic authentication is a great least common denominator auth mechanism. With
basic auth, the server maintains a list of users and, if necessary, user-role
information. Ensure all endpoints requiring basic auth are performed over SSL
**only**.

Basic auth breaks down if other 3rd party services are used on behalf of the
user. If multiple 3rd party services are used, a system like OAuth (where we can
pass tokens around) is a much cleaner, easier security mechanism.


Including a "Basic" header
`
require 'restclient'
require 'base64'
auth = "Basic " + Base64::strict_encode64("#{username}:#{password}")
response = RestClient.get("https://myhost/resource", :authorization=>auth);
`
### Google Oauth ###

[Google OAuth Authentication URL](https://accounts.google.com/o/oauth2/auth)

This URL is only available over HTTPS.




### OpenShift ###

Configuration saved to

    ~/.openshift/express.conf

All applications run in a domain. Create your domain.

    $ rhc domain create damonallison

Show all details on your domain.

    $ rhc domain show damonallison

List of available cartridges - you'll need this to create your app

    $ rhc cartridge list

If you want to create an app that scales (make sure you do) pass `--scaling`
when creating the application.

    $ rhc app create runmagic nodejs-0.10 --namespace damonallison --scaling


The following gear sizes are available with OpenShift Online:
* Small gears provide 512MB of RAM, 100MB of swap space, and 1GB of disk space
* Medium gears provide 1GB of RAM, 100MB of swap space, and 1GB of disk space
* Large gears provide 2GB of RAM, 100MB of swap space, and 1GB of disk space


"DNS names can be provided for the application by registering an alias with
OpenShift Online and pointing the DNS entry to the OpenShift Online servers."


## Viewing the applications ##

    $ rhc app show --help    # view the app
    $ rhc alias --help       # add a DNS alias

To view enviroment variables, ssh into the box and run `env`

    OPENSHIFT_DATA_DIR : is the *only* that is not emptied and rebuilt whenever
    new code is pushed to an application. Red Hat recommends that you store all
    persistent files in the OPENSHIFT_DATA_DIR directory.

    OPENSHIFT_LOG_DIR - logs in this dir are automatically rolled over at 10MB.

Manipulating environment variables

    $ rhc env list
    $ rhc env set DAMON=damon
    $ rhc env unset DAMON


## Hot Deploy ##

Hot deploy will not restart the cartridges. Jenkins | HAProxy | DIY are *not* hot-deploy supported.
Create a `hot_deploy` marker file to do hot deploy.

## Tidy ##

** NOTE **

Before running `app tidy` - make sure you snapshot your application. Your log
files will be deleted.  `rhc snapshot save`

    $ rhc app tidy

    Runs
      $ git gc
      $ rm -rf /tmp
      * Clears unused app libraries and remove libraries previously installed
        with a `git push` command (**no** idea what libraries these are)


## Backup / Restore ##

    $ rhc snapshot-save runmagic --filepath /tmp/runmagic.tar.gz

What is saved in a snapshot
  repo/
  DAMON : start here

* * * * * * * * * * * *

## Websockets ##

    ws://  == port 8000
    wss:// == port 8443

## Snapshots ##

You can save a snapshot locally and redeploy it later. Need to determine if DB
is part of the snapshot.

Save a snapshot locally:

    $ rhc save-snapshot runmagic --deployment

View a list of deployments:

    $ rhc deployments runmagic

Activating a deployment

    $ rhc activate-deployment -a App_Name Dep_ID
