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

Because it uses your organization's API key, you should *not* make search requests directly client-side, but instead create a PageBuilder content source to host your queries. (We'll come back to that later.)

The most important request and response fields are detailed below.

#### Basic Search Parameters

* `q` is a tokenized keyword query that will be used to search your content. It is **required**.
* `page` and `per_page` are used to control pagination
* `t` enables filtering by content type (e.g., "story", "gallery" or "video"). These are the same types as used in Arc Content API and [ANS](https://github.com/washingtonpost/ans-schema).
* `s` is the sort parameter. Its values can be:
  * `score` - sort results by relevancy
  * `date` -- sort results in a reverse chronological order

#### Response Data

* `metadata` includes all of the original search parameters as well as the count of the query results and and time of the

* `data` is a list of ANS documents returned by our search query. Note that although these documents are sourced from the Arc Content API, they do **not** include the full document that is available in the Content API.  This keeps the payload smaller and faster, which is important if you're rendering this data client-side.

* `aggregations` lists the total count found (`all`) and the total count found by content type (`story`, `gallery`, `video`)

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

### Building Basic Search Features in PageBuilder

A very basic search feature in PageBuilder should include the headline, promo item, publication date, and description for a story. If you wish to support a custom search feature, this can be achieved by using a <c:forEach> loop to iterate over the items in the `data` object and print out the fields you wish to include.

Very often, a search page includes a feature that prints out the name of the search term and the total number of results for the term. To get the number of total hits, include this in your JSP:
`<fmt:formatNumber value="${content.metadata.total_hits}" pattern="#,###" var="formattedTotalHits" />`

Button-based pagination can be created by utilizing the `page` option within the API. See [pagination.jsp](pagination.jsp) for an example of how to create a parameterized pagination feature.

To create features that allow users to filter results based on content type or timeframe, see [filtering.jsp](filtering.jsp).

#### searchqueryformat.tag

To display the search term to the user in a page header, we built a searchqueryformat.tag to sanitize the search term and print it out nicely.

The following code takes in a query and outputs it in a plain-text sanitized string. This prevents any malicious code from being put into the page.

```jsp
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://platform.washingtonpost.com/pagebuilder" prefix="pb" %>
<%@ taglib tagdir="/WEB-INF/tags/arc" prefix="arc" %>
<%@ tag import="java.net.URLDecoder"%>

<%@ attribute name="var" required="true" type="java.lang.Object" %>
<%@ attribute name="query" required="true" type="java.lang.Object" %>

<%-- URL decode the query parameter 'query.' --%>
<c:set var="updatedQuery"><%=URLDecoder.decode(jspContext.getAttribute("query").toString())%></c:set>

<%-- If '+' was encoded, re-decode into spaces.  --%>
<c:set var="updatedQuery" value="${fn:replace(updatedQuery, '+', ' ')}" />

<%-- In case any scripts were introduced as search-term, this will prevent them from running. (Prevents XSS.) --%>
<c:set var="updatedQuery" value="${fn:escapeXml(updatedQuery)}" />

${pageContext.request.setAttribute(var, updatedQuery)}
```

## Questions

#### Which attribute of the section (from Site Service) should be passed as the section parameter in Search API?

The corresponding field from a section object is `site.name` as defined in Site Service. For example, to search for documents with "USA" in the body in a section titled "World Politics":

```
https://search.arcpublishing.com/search?q=USA&sections=World%20Politics&key=<your_key_here>
```

#### Is it possible to perform an exclusion filter in the Search API? E.g. suppose we are searching a website with sections News, Sports, Business and Politics and we want to get the search results from across all the sections *except* Politics. Is this possible?

This is not currently supported. However, you can include the complete the list of sections in the `sections` parameter and omit the section you wish to exclude.
