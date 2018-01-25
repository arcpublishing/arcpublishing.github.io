<%-- PAGEBUILDER TAGS --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://platform.washingtonpost.com/pagebuilder" prefix="pb" %>
<%@ taglib tagdir="/WEB-INF/tags/twp" prefix="twp" %>
<%@ taglib tagdir="/WEB-INF/tags/partials" prefix="partials" %>
<%@ taglib tagdir="/WEB-INF/tags/arc" prefix="arc" %>
<%-- END TAGS --%>


<%-- Filters --%>
<c:set var="timeframe">
 {
  "label": "Time",
  "urlParameter": "tf",
  "values":
   {
    "100-y": "Anytime",
    "24-h": "Last 24 Hours",
    "4-d": "Past 4 Days",
    "1-w": "Past Week",
    "31-d": "Past Month"
   }
 }
</c:set>
<c:set var="type">
 {
  "label": "Type",
  "urlParameter": "t",
  "values":
   {
    "ALL": "All",
    "story": "Stories",
    "video": "Videos",
    "gallery": "Galleries",
    "images": "Photos"
   },
   "count":
    {
    "ALL": "${global.content.aggregations.all}",
    "story": "${global.content.aggregations.story}",
    "video": "${global.content.aggregations.video}",
    "gallery": "${global.content.aggregations.gallery}",
    "images": "${global.content.aggregations.image}"
    }
 }
</c:set>

<%-- No specific info about this and the search-API is also not ready for this
<c:set var="section" value="" />
<c:set var="author" value="" /> --%>

<pb:json-parser var="filters" json="[${type},${timeframe}]" />

<c:set var="noPbUri" value="/search/?q=${global.content.metadata.q}" />

<%-- Check & consider previous filters to build 1. Selected list of filters 2. URL for future fitlers --%>
<c:forEach items="${filters}" var="filter" varStatus="status">
  <c:set var="urlParam" value="${filter.urlParameter}" />
  <c:set var="urlValue" value="${pageContext.request.getParameter(urlParam)}" />
  <c:if test="${not empty urlValue}">
    <c:set var="filterLabel" value="${filter.values[urlValue]}" />
    <c:set var="selected" value="${selected}${empty selected?'':','}\"${urlParam}\":\"${urlValue}\"" />
  </c:if>
</c:forEach>
<pb:json-parser var="selectedJSON" json="{${selected}}" />

<%-- Filter --%>
    <h3>Filter</h3>
    <a href="${noPbUri}" class="uppercase underlined">
      clear all
    </a>
    <%-- begin = 1 to exclude sort --%>
    <c:forEach items="${filters}" begin="1" var="filter" varStatus="status">
      <c:set var="urlParam" value="${filter.urlParameter}" />

      <%-- build URL based on selected values for this filter --%>
      <c:set var="tmpSelectionUrl" value="" />
      <c:forEach items="${selectedJSON}" var="selectedMap">
        <c:set var="keyParam" value="${selectedMap.key}" />
        <c:set var="value" value="${selectedMap.value}" />
        <c:choose>
          <c:when test="${keyParam ne urlParam}">
            <c:set var="tmpSelectionUrl" value="${tmpSelectionUrl}${empty tmpSelectionUrl ? '':'&'}${keyParam}=${value}" />
          </c:when>
          <c:otherwise>
            <c:set var="selectedValue" value="${value}" />
          </c:otherwise>
        </c:choose>
      </c:forEach>


        <ul>
          <%-- Build entries based on values with updated selectionUrl to trigger filter --%>
          <c:forEach items="${filter.values}" var="valueMap">
            <c:set var="key" value="${valueMap.key}" />
            <c:set var="value" value="${valueMap.value}" />
            <c:if test="${not empty filter.count}">
              <fmt:formatNumber value="${filter.count[key]}" pattern="#,###" var="formattedCount" />
              <c:set var="count" value=" (${formattedCount})" />
            </c:if>

            <li><a class="uppercase ${selectedValue eq key ? 'selected' : ''}" href="${noPbUri}&${tmpSelectionUrl}${empty tmpSelectionUrl ? '':'&'}${urlParam}=${key}">${value}${count}</a></li>
            <c:remove var="count" />
          </c:forEach>
        </ul>
      <c:remove var="selectedValue" />
    </c:forEach>
