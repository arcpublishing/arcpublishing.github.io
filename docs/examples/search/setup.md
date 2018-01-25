# Getting Started with Arc Search

## Introduction

Arc Search allows your readers to discover content on your website. They can search, filter, and sort while searching. Discoverability in the search process is a key component to the user experience of Arc Search, allowing for content to quickly accessible to readers. Arc Search is also natively be in ANS, which conforms to the rest of Arc’s platform and your Pagebuilder templates - creating an easier-to-use solution, and the ability to adapt search as the Arc platform grows. This guide is designed to help you get up and running with Arc Search.

### Prequisites

* An existing account on Arc Publishing
* Familiarity with ANS
* Familiarity with PageBuilder content sources, resolvers and features
* An Arc Search API Key (see below)

### Requesting an API Key

Arc Search is powered by data from Arc Content API. Indexing the Content API data into Search takes some time
and must be requested. To turn on Arc Search, contact your account manager and request an API key for Arc Search.

### Additional Documentation

* [Arc Search API Documentation](https://s3.amazonaws.com/search-service-documentation-production/index.html)
* [PageBuilder Documentation](https://arcpublishing.atlassian.net/wiki/spaces/PD/pages/13336857/PageBuilder+Documentation)

## Instructions

### Introducing the Arc Search API

You can test your API key by hitting the Arc Search API directly in your browser. For example, if your search key is `ABC`, then opening the URL (https://search.arcpublishing.com/search?key=ABC&q=allison%20janney) should return something like:

```json
{
	"metadata": {
		"q": "allison janney",
		"page": 1,
		"per_page": 10,
		"t": "ALL",
		"s": "score",
		"timeframe": "1|w",
		"total_hits": 0,
		"took": 2
	},
	"data": [{
		"display_date": "2018-01-24T02:01:00Z",
		"credits": {
			"by": [{
				"name": "Sarah Smith"
			}]
		},
		"headlines": {
			"basic": "Allison Janney wins first Oscar nomination."
		},
		"first_publish_date": "2018-01-24T02:01:00Z",
		"created_date": "2018-01-24T02:00:00.400Z",
		"taxonomy": {},
		"type": "story",
		"last_updated_date": "2018-01-24T02:58:21.120Z",
		"canonical_url": "/culture/entertainment/allison-janey-wins-oscar-nomination/",
		"promo_items": {},
		"publish_date": "2018-01-24T02:01:00Z"
	}],
	"aggregations": {
		"all": 0,
		"story": 0,
		"image": 0,
		"video": 0,
		"gallery": 0
	}
}
```

Because it use in your organization's API key, you should *not* make search requests directly client-side, but instead create a PageBuilder content source to host your queries. (We'll come back to that later.)

The most important request and response fields are detailed below.

### Basic Search Parameters

* `q` is a tokenized keyword query that will be used to search your content. It is **required**.
* `page` and `per_page` are used to control pagination
* `t` enables filtering by content type (e.g., "story", "gallery" or "video"). These are the same types as used in Arc Content API and [ANS](https://github.com/washingtonpost/ans-schema).
* `s` is the sort parameter. Its values can be:
  * `score` - sort results by relevancy
  * `date` -- sort results in a reverse chronological order

### Response Data

* `metadata` includes all of the original search parameters as well as the count of the query results and and time of the

* `data` is a list of ANS documents returned by our search query. Note that although these documents are sourced from the Arc Content API, they do **not** include the full document that is available in the Content API.  This keeps the payload smaller and faster, which is important if you're rendering this data client-side.

For convenience, the `data`, `metadata` and `aggregations` response attributes can each be renamed (e.g, to `content_elements`) by setting them as a query parameter in the request. (E.g. `?data=content_elements`)

A full list of API parameters and response fields is available in the [API Documentation](https://s3.amazonaws.com/search-service-documentation-production/index.html#api-Search).

### Setting up Arc Search as a PageBuilder content source

   1. Ensure that the `data` attribute is set to `data=content_elements`. This will place all results from the endpoint in a
      `content_elements` object in the response, which mimics the ANS format. This will allow you to pipe search results
      into any feed-driven feature.

      Example:
      `https://search.arcpublishing.com/search?q={QUERY}&timeframe={TIMEFRAME}&t={TYPE}&page={PAGE}&per_page={NUM_RESULTS}&data=content_elements&key=<your_key_here>`

   2. Set up a resolver or modify the existing resolver for search to use the new search content source
      1. Identify whether the search term will be incorporated into the URL pattern or appended as a parameter.
   3. Set the default values for the TIMEFRAME, TYPE, PAGE, and NUM_RESULTS variables in the endpoint.
   4. The only variable required to come from the URL or parameter is QUERY, so others should be given fallback/default values.
   5. In the search template, update the search feed feature to use the feed-driven flex feature, or any similar
      feature that populates multiple results (if not using a feed-driven flex feature).
      1. Anyone who uses the Feature Pack should be able to use the feed-driven flex feature to format a results list
         that more or less resembles the existing search results list feature.

### Tips for Building Custom Search Features:

To get the number of total hits, include this in your JSP:
`<fmt:formatNumber value="${content.metadata.total_hits}" pattern="#,###" var="formattedTotalHits" />`

To display the search term to the user in a page header, we built a searchqueryformat.tag to sanitize the search term
and print it out nicely.

Button-based pagination can be created by utilizing the `page` option within the API.

### A Basic Search Feature in PageBuilder
