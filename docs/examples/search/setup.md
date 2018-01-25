# Getting Started with Arc Search

## Introduction

(Text here - Anais)

This guide is designed to help you get up and running with Arc Search.

### Prequisites

* An existing account on Arc Publishing
* Familiarity with ANS, PageBuilder content sources and PageBuilder templates
* An Arc Search API Key (see below)

#### Requesting an API Key

Arc Search is powered by data from Arc Content API. Indexing the Content API data into Search takes some time
and must be requested. To turn on Arc Search, contact your engagement manager and request an API key for Arc Search.

### Additional Documentation

* [Arc Search API Documentation](https://s3.amazonaws.com/search-service-documentation-production/index.html)
* [PageBuilder Documentation](https://arcpublishing.atlassian.net/wiki/spaces/PD/pages/13336857/PageBuilder+Documentation)

## Instructions

### Setting up Arc Search as a PageBuilder content source

   1. Ensure that the `data` attribute is set to `data=content_elements`. This will place all results from the endpoint in a
      `content_elements` object in the response, which mimics the Content API format. This will allow you to pipe search results
      into any feed-driven feature.

      Example:
      `https://search.arcpublishing.com/search?q={QUERY}&timeframe={TIMEFRAME}&t={TYPE}&page={PAGE}&per_page={NUM_RESULTS}&data=content_elements&key=<your_key_here>`

   2. Set up a resolver or modify the existing resolver for search to use the new search content source
      1. identify whether the search term will be incorporated into the URL pattern or appended as a parameter.
   3. Set the default values for the TIMEFRAME, TYPE, PAGE, and NUM_RESULTS variables in the endpoint.
   4. The only variable required to come from the URL or parameter is QUERY, so others should be given fallback/default values.
   5. In the search template, update the search feed feature to use the feed-driven flex feature, or any similar
      feature that populates multiple results (if not using a feed-driven flex feature).
      1. Anyone who uses the Feature Pack should be able to use the feed-driven flex feature to format a results list
         that more or less resembles the existing search results list feature.

### Tips for Building Custom Search Features:

To get the number of total hits:
<fmt:formatNumber value="${content.metadata.total_hits}" pattern="#,###" var="formattedTotalHits" />

To display the search term to the user in a page header, we built a searchqueryformat.tag to sanitize the search term
and print it out nicely.

Button-based pagination can be created by utilizing the `page` option within the API.

### A Basic Search Feature in PageBuilder
