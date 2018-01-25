<c:set var="noPbUri" value="/search/?q=${global.content.metadata.q}" />

<%-- build URL based on existing one --%>
<c:set var="queryStringRaw" value="${pageContext.request.queryString}" />
<c:forEach var="paramItem" items="${fn:split(queryStringRaw, '&')}">
  <c:set var="queryString" value="${queryString}${empty queryString ? '' : '&'}${paramItem}" />
</c:forEach>

<c:set var="urlParam" value="p" />
<c:set var="selectedUrl" value="${noPbUri}&${queryString}" />
<c:set var="selectedUrlParam" value="${selectedUrl}${fn:endsWith(selectedUrl, '&') ? '' : '&'}${urlParam}" />

<%-- pagination data statics--%>
<c:set var="totalPageCountDec" value="${global.content.metadata.total_hits / global.content._config_.NUM_RESULTS}" />

<%-- pagination data calculated values --%>
<fmt:formatNumber var="totalPageCount" value="${totalPageCountDec+(1-(totalPageCountDec%1))%1}" maxFractionDigits="0" pattern="####"/><%-- round up to top, no other ceiling function available --%>

<%-- pagination data from request --%>
<c:set var="showPagination" value="${global.content.metadata.total_hits > 0}" />
<c:set var="currentPage" value="${global.content.metadata.page}" />

<c:if test="${showPagination}">
  <div class="button-container">

    <%-- pagination data statics DESKTOP--%>
    <c:set var="moveAlongThreshold" value="${3}" /><%-- how many not-active pagination-buttons should be around left/right buttons before number moves up/down on paging --%>
    <c:set var="pageButtonThreshold" value="${10}" /><%-- how many button-pages should show --%>

    <%-- pagination data calculated values DESKTOP--%>
    <c:set var="stopMoveAlongThreshold" value="${totalPageCount - (pageButtonThreshold - moveAlongThreshold)}" /><%-- stops numbers moving up, when reaching the end of pages --%>

    <%@include file="generate-buttons.jsp"%>
  </div>

</c:if>
