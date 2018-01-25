<%-- PAGEBUILDER TAGS --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://platform.washingtonpost.com/pagebuilder" prefix="pb" %>
<%@ taglib tagdir="/WEB-INF/tags/twp" prefix="twp" %>
<%@ taglib tagdir="/WEB-INF/tags/partials" prefix="partials" %>
<%-- END TAGS --%>

<%-- all variables are set in feature.jsp --%>


<%-- left/prev pagination button --%>
<c:set var="leftButtonInactive" value="${currentPage eq 1 ? 'inactive' : '' }" />
<a <c:if test="${empty leftButtonInactive}">href="${selectedUrlParam}=${currentPage - 1}"</c:if> aria-label="page-left" class="button ${leftButtonInactive}">
  <i class="fa fa-angle-left"></i>
</a>

<div>
 <%-- Figure out which page numbers to show in pagination bar --%>
  <c:choose>
    <c:when test="${totalPageCount lt pageButtonThreshold}">
      <%-- If less pages than max amount of pages to show, show all pages --%>
      <c:set var="loopBegin" value="1" />
      <c:set var="loopEnd" value="${totalPageCount}" />
    </c:when>
    <c:when test="${currentPage gt moveAlongThreshold and currentPage le stopMoveAlongThreshold}">
      <%-- If the current page is in between thresholds, begin moving the numbers up ahead with paging --%>
      <c:set var="loopBegin" value="${currentPage - moveAlongThreshold}" />
      <c:set var="loopEnd" value="${currentPage + (pageButtonThreshold - moveAlongThreshold) - 1}" />
    </c:when>
    <c:when test="${currentPage gt stopMoveAlongThreshold and totalPageCount ge pageButtonThreshold}">
      <%-- If there are no more pages to move ahead with paging, stay fixed to end --%>
      <c:set var="loopBegin" value="${totalPageCount - pageButtonThreshold + 1}" />
      <c:set var="loopEnd" value="${totalPageCount}" />
    </c:when>
    <c:otherwise>
      <%-- Default on page 1 to lower threshold, stay fixed to start --%>
      <c:set var="loopBegin" value="1" />
      <c:set var="loopEnd" value="${pageButtonThreshold}" />
    </c:otherwise>
  </c:choose>

  <%-- apply pagination-number buttons --%>
  <c:forEach begin="${loopBegin}" end="${loopEnd}" varStatus="status">
    <c:set var="pageNumber" value="${status.index}" />
    <c:set var="activePage" value="${currentPage eq pageNumber}" />

    <div>
      <a href="${selectedUrlParam}=${pageNumber}" aria-label="pageNumber" class="button ${activePage ? 'active' : '' }">
        ${pageNumber}
      </a>
    </div>
  </c:forEach>
</div>

<%-- right/next pagination button --%>
<c:set var="rightButtonInactive" value="${currentPage eq totalPageCount ? 'inactive' : ''}" />
<a <c:if test="${empty rightButtonInactive}">href="${selectedUrlParam}=${currentPage + 1}"</c:if> aria-label="page-right" class="button ${rightButtonInactive}">
  <i class="fa fa-angle-right"></i>
</a>
