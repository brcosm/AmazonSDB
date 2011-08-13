Amazon SDB
==========
This is a simple interface to the Amazon Web Services product called SimpleDB.  SimpleDB is a key-value store that can be accessed via http requests.

Supported Operations
--------------------
A full list of SDB Operations (queries) can be found here:
http://docs.amazonwebservices.com/AmazonSimpleDB/latest/DeveloperGuideindex.html?SDB_API_Operations.html
Currently, the following of these are implemented:
* ListDomains
* DomainMetadata
* CreateDomain
* DeleteDomain
* Select
* GetAttributes
* PutAttributes
* DeleteAttributes

Installation
------------
* Requires Xcode 4.2 or greater (BETA version)
* Edit APIKey.h with your AWS access and secret keys
* Edit the sdbExample methods in the AppDelegate to be appropriate in the context of your SDB account
* Build and run!

TODO
-----
* Paging/NextToken handling
* Handle exceptions (No network, etc.)
* Provide better parsing of SDB error messages
* Input validation
* Build out full example application
* BatchPut/Delete operations