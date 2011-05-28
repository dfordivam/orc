Feature: Visitor Registration

So that I can keep track of all the visitors coming to campus
As a registrations administration
I want to add visitors details when they arrive.



Scenario: Add visitor information
Given a visitor named "Name_example"
When I click on add visitor 
And I enter the visitor details
And I click the "Add Visitor" button
Then the visitor details should come in the list of visitors

