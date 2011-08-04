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
* Select

Installation
------------
* Requires Xcode 4.2 or greater
* Edit APIKey.h with your AWS access and secret keys
* Edit the sdbExample method in the AppDelegate to be appropriate in the context of your SDB account
* Build and run!

TODO
-----
* Fix metaData parsing for domains
* Automatically generate new operations when a token is provided and no limit was specified
* Add mutable operations such as put attribute
* Handle exceptions (No network, etc.)
* Build out full example application