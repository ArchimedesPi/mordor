Feature: Help
  In order to understand how to use this program
  As a CLI user
  I want to have a command that tells me how to use it
  
  
  Scenario: I need *all* the help
    When I run `mordor help`
    Then the output should contain "Commands:"