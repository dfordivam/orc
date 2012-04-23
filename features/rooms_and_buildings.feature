Feature: Add/Modify Buildings and Rooms

	So that I can assign visitors rooms and keep track of their occupancy for every building
	As a registrations administrator
	I want to add/modify room details for all buildings
	I want to assign rooms to visitors
	I want to get a report regarding the occupancy of rooms

	Scenario: Add Building Information
		Given a building named "Peace Palace"
		When I click the "Add Building" link
		And I enter the Building details
		And I click the "Submit" button
		Then the building details should come in the list of buildings

	Scenario: Add Room Information
		Given that I have a building named "Peace Palace"
		When I edit the building details
		And I click the "Add Rooms" button
		And I add the Room information
		And I enter all the rooms numbers for similar rooms
		Then the specified number of rooms should get created with the same details
		And the rooms details should come on the list of rooms for the building "Peace Palace"
