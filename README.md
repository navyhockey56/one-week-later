taleo-magic has two components:
1)taleo-scrapify
2)taleo-autofillers

taleo-scrapify
============================

taleo-scrapify is used to scrape Taleo pages.

Usage
----------------------------
	
	require 'capybara'

	require 'taleo-scrapify'

	s = Capybara::Session.new :selenium    

    fields       = s.all_fields(visible: true)

    field_groups = Taleo::Scrapify.group_fields(fields)

    questions    = field_groups.map{|fg| Taleo::Scrapify.scrapify(fg) }

    the_output   = JSON.pretty_generate(questions)

    File.write("the_page.json", the_output)


    ===============================
    ||  DependentLocationScraper ||
    ===============================

    
        Taleo has Country -> State -> Region dependencies in different 
    parts of their application flows. Candidate info, Education, so on.
    This gem include functionality to grab all of these and turn them 
    into lists for the question service for both robot and API clients.

    
    Usage
    -------------------------------------------------------------------------------------

    You will need to create a directory for your list files to go into.
    Next, apply to a job and navigate to the profile page, which has the 
    dependent location dropdowns. View the source of the page and copy 
    the entire contents into a text file. Save it as countries.txt and 
    place it in the directory you created before.

    Next, navigate to the taleo-magic directory and do a bundle console.
    Now just use the TaleoLocations.scrape method and it will do the 
    rest. The definition is:

    scrape(path, prefix = nil, api = true)

    path is the path to the directory you created (which contains the
    countries.txt file). prefix is a string that will be prepended to 
    the names for the files created. api is treated as a boolean. Use 
    it clients with api credentials. When true, a region mappings file 
    will be created for the applybot so it can map region names to ats 
    ids. Also, locations will be propagated down to the region level. 
    For example, if a country has no states, a default state with the 
    same name and id as the country will be created. If a state has no 
    regions, a default region with the name and id of the state will 
    be created. This way, you can always send the id from the region 
    into the api. When false, this propagation will not occur. Instead, 
    the __NA__ placeholder will be used.

    
    ===============================
    ||         DatePicker        ||
    ===============================			


        Some taleo clients have a datepicker widget that is loaded on the screen
    by a click on a link. These datepickers are the same across clients, so use
    this class instead of wasting time trying to figure out how to select a date.

    Usage
    ------------------------------------------------------------------------------------

    require 'capybara'
    require 'taleo-magic'

    session = Capybara::Session.new :selenium

    session.visit "http://your-job-url.com"

    ## navigate to the page with the datepicker link
    *NOTE*: you must be on the proper page before you can initialize this class 

    (Two ways to initialize)

    (1) options = {
            session: session,
            container_title: "Education 1",
            date_title: "Graduation Date"
       }
    
    OR

    (2) options = {
            session: session,
            date_link: #<Capybara::Element tag="a">
       }



    picker = Taleo::Autofillers::DatePicker.new(options) 

    (Two ways to execute)
    
    (1) picker.pick_date(day: 12, month: 12, year: 2008)
    OR 
    (2) picker.pick_date(ja_date: "2014-07-18T17:12:30Z")



    NOTE: You can have Strings or Integers as parameters month,day,or year
          but ja_date should be a String. You can also set the month to the
          actually month names or abreviations.
    
    e.g month: "january", month: "jan", month: "Jan", month: "January", month: 1,
        month: "01" are all valid


    Initialize option (2): 
        If for some reason the datepicker link is not within a repeated container, 
        you can also initialize the datepicker with the <a> element of the link 
        you are working with.



