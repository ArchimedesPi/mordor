Feature: Help
  In order to understand how to use this program
  As a CLI user
  I want to have a command that tells me how to use it
  
  
  Scenario: I need *all* the help
    When I run `mordor help`
    Then the output should contain "Commands:"
    Then the output should contain:
    """
      mordor fetch           # Fetch a package's repo to the current directory
      mordor help [COMMAND]  # Describe available commands or one specific command
      mordor install         # Install a package
      mordor status          # Status of a package
      mordor zap             # Remove Mordor from this computer
    """