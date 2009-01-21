*******************************************************************&******
***                                                                    ***
***  FOR THE OFFICIAL PROJECT DESCRIPTION, PLEASE SEE                  ***
***  http://e168f08.plugh.org/assignments/assignment-3-milestone-iii/  ***
***                                                                    ***
**************************************************************************

Harvard CSCI E-168, Fall 2008
Project: Final Project, Address Book
By: Adam Winter
email: awinter@fas.harvard.edu

Due date: Wednesday, January 21


In Assignment 3, you will modify MetricMine, adding controllers and views.

There are some small changes between this version and the prior version: 20081111021247_add_current_observation_set_id_to_user.rb adds a column to user "current_observation_set_id" - whenever you view an observation set, the id is saved here so that when you log in from a cookie, you can be redirected to that set: This makes it especially easy to enter a new observation for whatever set you were last looking at. There are also some extra validations on the models; these changes required some tweaks to the tests (we didn't add tests for the additional validations, but we did need to change our existing tests). We added a default value of '' for the notes field on observations. We also added a "dependent" option for ObservationKind so that when it is deleted, the foreign key will be set to null on any ObservationSets that belong to it. Finally, there is an additional data migration so that the "john" user has two relatively detailed observation sets (for weight and savings).


About nomenclature:

In the UI, an observation set is called a metric, and an observation kind is called a "kind of metric" or a "metric kind." It seemed to us that for the end user this language is easier that observation/observation set.


Now, what are you supposed to do?

You need to flesh out the controllers and views that manage certain models for basic CRUD operations.

Any time you like, you may play with a "reference implementation" here:

  http://metricsmine.plugh.org/

We will re-run the migrations periodically to clear out the database.

Also note that you can fire up your server (ruby script/server), browse to http://localhost:3000, and quite a bit of MetricsMine will run. You will see some missing data because your controllers aren't finished, or some static data that doesn't apply to your user, because the views aren't all dynamic. In a number of cases, we have marked out views that need to be made dynamic; in some cases, we give you some static rendered HTML that is the result of the reference view code. All of this is to alert you to what must be done.

Regarding the static HTML: Remember that almost all of this is generated dynamically! E.g., if the action on a form is to "/observation_sets/create_observation" that is probably generated with something like this:

<% form_for :observation, :url => { :action => :create_observation } do |form| %>

In other words, USE YOUR VIEW HELPERS! We don't want to see "raw" HTML links, form actions, etc., etc. Such things will count against you.

For controllers, make sure that you choose redirect or render properly; we will mention this occasionally below, but the behavior should be like the reference MetricsMine application. When this assignment is graded, we will spot-check for this. In the views, there are a number of little details you need to get right: The page title; the error display (both summary and per-fiend); setting the focus on the first element for a field; etc. Again, graders will spot-check, so you need to get this right everywhere.

NOTE: On occasion, you may see an error message claiming that there is no template for the "create" (or another) action. Remember that in Rails, we typically redirect after create, or use the view template for another action; in other words, these error messages may be spurious, depending on where you are with the assignment. When in doubt, review the reference implementation.
 
This download includes a fully-migrated version of the database. If you want to get the database back to its original condition, do

  rake db:migrate VERSION=02
  rake db:migrate

During development, you may also find that you need to delete any permanent cookies in your browser for the app associated with the "localhost" server. You would want to do this if the saved user id is forcing you to an action + view you haven't implemented yet.


Let's go through the actions, roughly by controller:


(1) The easy cases: Administrative functions. Remember that you have to log in as "admin" to see these. You should be able to finish these swiftly; within 4 hours, maximum.

Controllers:

MeasurementsController
ObservationKindsController
UnitsController

These are roughly the same as the CRUD operations in LinkWizz, CCC, and LinkWizz's ResearchTopicsController. Remember that a Unit belongs to a Measurement (same for ObservationKind), so for edit and new you will need to set up a @measurements instance variable that holds the options for the drop-down.

Notice that you CAN delete an ObservationKind.

Views: 

For each of these controllers, there are views for edit, index, and new - there is no "show" because the relevant data is shown in the list. A pattern you may see is to implement a "list" action, and have the "index" action utilize it; in MetricsMine we've simply implemented index.

We have included STATIC stubs for the views for ObservationKinds to give you a feel for what the rendered dynamic view should look like (you can do "view source" on the reference implementation to see the same sort of thing). Notice the fancy JavaScript for the "(delete)" link. The view helper link_to's :action => 'destroy' option will do all of this for you.

For the others, we have just included a message asking you to implement the view.




(2) Managing an Observation Set and its Observations

This will be more difficult. There are a lot of little details here. Try to get as far as you can; we will give you hints on the discussion board, particularly if it is clear that you are making headway.

Controller: ObservationSetsController

Notice that this controller manages updates of BOTH ObservationSet and Observation. This is not an unusual pattern. Since Observation is almost completely a "slave" of ObservationSet, it is convenient to manage both Models in the same controller. When we get to REST, we will talk about changing this.

Actions

new and create: The new and create paired actions are for creating a new ObservationSet. Notice that you cannot edit/update the name and kind of a user's ObservationSet!

NOTE: When an ObservationSet is created, don't forget to (a) set the @observation_set's user_id to that of the current user, and (b) also set the @observation_set's preferred unit to the first unit of the selected ObservationKind's Measurement!! These two items (a) and (b) are each easily expressed in a single statement.

show: This shows all of the observations for the observation set, AND it sets up a form for adding a single observation! When an observation set is displayed or edited, the current observation set id is copied to the current user's attribute current_observation_set_id. You must do this as well. This allows the filter on the application controller to bring the user back to the last observation set edited, for easy addition of new data.

create_observation: This is the action to which "show" posts when you want to create a single observation. Let me repeat: *NEW* sets up the form for an observation_set that posts back to *CREATE* to create an observation_set. But *SHOW* shows all the observations, AND sets up a form for an observation; that form posts back to *CREATE_OBSERVATION*. In the reference implementation, the id of the newly-created observation is put into the flash, so that when the list of observations is re-displayed, we can change the background color of the row. You need to do this, too; to get it to happen you will want to dynamically change the style element on the correct <tr> tag. E.g., it would look like:

  <tr>
  
when the row shouldn't be emphasized; and

  <tr style="background-color: #E0FFFF">

when it should be emphasized. This is the sort of thing you can glean from view/source for the reference implementation.

edit and update: These are for setting up the edit view with the checkboxes, so that you can delete specific observations. Notice that after update deletes the appropriate observations, it creates a "flash" message that summarizes how many observations were deleted. Notice that the title of this page has the name for the observation set, so you will need to establish the proper @observation_set as well as @observations. It is possible to implement this so that the view works off of @observation_set only, but I think it will be easier if populate instance variables for both @observation_set and @observations.

Views: 

edit.html.erb - There should be a table around the form; checkboxes are on each row. (Big) HINT: The easiest way to make this work is for the form to be on the observation_set, and to use the checkbox_tag: check_box_tag "observation_ids[]", "#{obs.id}" %>

new.html.erb - Standard.

show.html.erb - The interesting part is defining the form to create an observation. It will look like this:

  <% form_for :observation, :url => { :action => :create_observation } do |form| %>

Now, read closely: An observation is for a particular observation_set, right? Therefore, this form must have in it a field that designates the observation_set for which this observation is destined. We are accustomed to putting all of the new data for a model into form fields -- but do we want the user to be able to edit the observation_set_id? I don't think so. Therefore, the way to implement this is with a hidden field. Inside that form you are going to need to define:

  <%= form.hidden_field :observation_set_id %>

Otherwise, how would the observation_set_id get back into the params hash so that the new @observation is set up correctly . . . ?

That's all we have to say for show.html.erb. Try and get as much of it working as you can; if you have issues, post them to the discussion board.


QUESTIONS AND ANSWERS

Q1. Can I replace the stylesheet or change the HTML?

A1. No.

Q2: Can I add additional information that is "latent" in the model? I.e., can I change what is shown in the tables?

A2: No.

Q3: Is there any extra credit?

A3: Yes. We will give a SMALL number of points (2 or 3) for an implementation of the "compare" function. Compare is a multi-stage process. First a list of links should be displayed where the user picks an observation set (you could also implement this on the index view for observation_sets), so that the user can pick which observation set needs a comparison. That should take the user to a page that would show a list of observation sets owned by other users of the same measurement kind. The UI could present a list of links or a drop-down. Once the other observation set is picked, you should show a view that compares the data. My advice is to KEEP IT SIMPLE. For example, simplying show the first and last observations for each observation set, along with the dates for those observations, would be fine. The learning process here is in the addition of controllers and views to facilitate the comparison. If you want to go nuts, you could try to rollup the data in similar fashion, and then create a Google Chart that charts both data sets -- to do this will require a lot of scrounging around to figure out Google Charts. I think this would be a waste of time at this point, but I mention it for the ambitious.

