# BurnInn website

CMS : Umbraco 8.3

Local domain : http://dev.burbolka.com

## Setup local environment

After you have cloned the repository run the following batch files :

- create-iis-site.bat : this will configure your IIS server for the website 
- Build the solution

After this you can continue with a copy of a database that you got from another developer or start from scratch with a empty database

### Using an exisiting database

Change the connection string in config/connectionstrings.config to point to your local database

### Using an empty database

1. Change the web.config connectionstrings section to this :
```
<connectionStrings>
	<remove name="umbracoDbDSN" />
	<add name="umbracoDbDSN" connectionString="" providerName="" />
	<!-- Important: If you're upgrading Umbraco, do not clear the connection string / provider name during your web.config merge. -->
</connectionStrings>
```
2. Clear the appsetting umbracoConfigurationStatus
3. Run the installer. Use the username and password above to create the admin account
4. After installing move the connectionstring in the web.config to config/connectionstrings.config and undo the changes in the web.config
5. Run uSync full import

## Development guidelines

For this project every developer will work on his own local database. With this great flexibility comes also great responsibility. It now requires developers to do a uSync import **each time** after the master branch has been pulled.


