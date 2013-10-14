Enterprise Semantic Parser
=========

**contributors**:  Jonathan Raiman

Description & Usage
----
A small Ruby server for interfacing with a Semantic Parser.

Send a URL to the port 64646 and receive a JSON containing the *topics* (Wikipedia Articles) and *domains* (Currently taken from a subset of the Wikipedia Ontology).

Installation
----
Simply navigate to the relevant directory, and install the necessary dependencies by running:

    bundle install

An additional project is needed along with its Mongo database and the rest, so for now this is not runnable on other machines, but if the dependencies are available, just hit:

    ruby app.rb
    
to launch the server.

Issues
----
- Parser component and database are not available on other machines besides Jonathan's
- Overly optimistic error handling (malformed URLS) => brittle
- Database is still in construction, so certain pages take longer to parse than others (regular parse time is 0.5s but can take over a minute for page referencing articles than are not precompiled).
    