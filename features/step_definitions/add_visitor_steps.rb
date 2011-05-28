Given /^a visitor named "([^"]*)"$/ do |arg1|
  @visitor_attr = { name: "name_test" , age: 23, gender: "Male", address: "example address" , mobile_no: "9898989898", visitor_type: "BK" }
end

When /^I click on add visitor$/ do
  visit visitors_path
end

When /^I enter the visitor details$/ do
  fill_in "Name", with: @visitor_attr[:name]
end

When /^I click the "([^"]*)" button$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^the visitor details should come in the list of visitors$/ do
  pending # express the regexp above with the code you wish you had
end

