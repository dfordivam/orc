Given /^a visitor named "([^"]*)"$/ do |arg1|
  @visitor_attr = { name: "name_test" , age: 23}
end

When /^I click on add visitor$/ do
  visit add_visitor
end

When /^I enter the visitor details$/ do
  pending # express the regexp above with the code you wish you had
end

When /^I click the "([^"]*)" button$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then /^the visitor details should come in the list of visitors$/ do
  pending # express the regexp above with the code you wish you had
end

