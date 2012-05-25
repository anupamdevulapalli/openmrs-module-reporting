<%@ include file="/WEB-INF/template/include.jsp"%>
<%@ include file="../run/localHeader.jsp"%>

<openmrs:require privilege="Run Reports" otherwise="/login.htm" redirect="/admin/reports/runReport.list" />

<style>
	.runTableCell {padding-right:10px; padding-bottom:5px;}
</style>

<div id="page">
	<div id="container">
		<div>
			<h1>${report.reportDefinition.name}</h1>
			<h2>${report.reportDefinition.description}</h2>
			
			<table style="width:100%;">
				<tr>
					<td style="width:50%; vertical-align:top;">
	
						<fieldSet>
							<legend><b><spring:message code="reporting.runReport.runOrScheduleThisReport"/></b></legend>
			
							<spring:nestedPath path="report">
								<spring:bind path="reportDefinition">
									<c:if test="${not empty status.errorMessage}">
										<span class="error">${status.errorMessage}</span>
									</c:if>
								</spring:bind>
			
								<form method="post">
									<table style="padding:10px;">
										<c:forEach var="parameter" items="${report.reportDefinition.parameters}">
							                <tr>
							                    <spring:bind path="userEnteredParams[${parameter.name}]">
										            <td><spring:message code="${parameter.label}"/>:</td>
								                    <td>
						                   				<c:choose>
															<c:when test="${parameter.collectionType != null}">
																<wgt:widget id="userEnteredParam${parameter.name}" name="${status.expression}" type="${parameter.collectionType.name}" genericTypes="${parameter.type.name}" defaultValue="${status.value}" attributes="${parameter.widgetConfigurationAsString}"/>	
															</c:when>
															<c:otherwise>
																<wgt:widget id="userEnteredParam${parameter.name}" name="${status.expression}" type="${parameter.type.name}" defaultValue="${status.value}" attributes="${parameter.widgetConfigurationAsString}"/>	
															</c:otherwise>
														</c:choose>
								                        <c:if test="${not empty status.errorMessage}">
								                            <span class="error">${status.errorMessage}</span>
								                        </c:if>
								                    </td>
									            </spring:bind>
							                </tr>
							            </c:forEach>
										<tr>				
											<td><spring:message code="reporting.Report.run.outputFormat"/>:</td>					
											<td>
												<spring:bind path="selectedRenderer">
										            <select name="${status.expression}">
										                <c:forEach var="renderingMode" items="${report.renderingModes}">
										                	<c:set var="thisVal" value="${renderingMode.descriptor}"/>
										                    <option
										                        <c:if test="${status.value == thisVal}"> selected</c:if>
										                        value="${thisVal}">${renderingMode.label}
										                    </option>
										                </c:forEach>
										            </select>
													<c:if test="${not empty status.errorMessage}">
														<span class="error">${status.errorMessage}</span>
													</c:if>
												</spring:bind>
											</td>		
										</tr>
									</table>
									<table style="padding:10px;">
										<openmrs:globalProperty var="mode" key="reporting.runReportCohortFilterMode" defaultValue="showIfNull"/>
										<c:set var="showCohortFilter" value="${mode == 'hide' ? false : (mode == 'show' ? true : report.reportDefinition.baseCohortDefinition == null)}"/>
										<c:if test="${showCohortFilter}">
											<tr>
												<td class="runTableCell">
													<spring:message code="reporting.Report.run.runForSpecificCohort"/>
												</td>
												<td class="runTableCell">
													<spring:message code="reporting.Report.run.optionalFilterCohort" var="filterCohortLabel"/>
													<spring:message code="reporting.allPatients" var="allPatients"/>
													<rptTag:mappedPropertyForObject id="baseCohort" formFieldName="baseCohort" object="${report}" propertyName="baseCohort" label="${filterCohortLabel}" emptyValueLabel="${allPatients}"/>
									          	</td>
									         </tr>
										</c:if>
						        		<tr valign="top">
							                <td class="runTableCell"><spring:message code="reporting.Report.run.whenShouldReportBeRun"/></td>
							                <td class="runTableCell">
							                	<spring:bind path="schedule">
							                		<rptTag:cronExpressionField id="runReport" formFieldName="${status.expression}" formFieldValue="${status.value}"/>
										       		<c:if test="${not empty status.errorMessage}">
														<span class="error">${status.errorMessage}</span>
													</c:if>
										        </spring:bind>
							                </td>
							            </tr>
							            <tr>
							            	<td colspan="2">
							            		<br/>
												<input type="submit" value="<spring:message code="reporting.Report.run.button"/>" />
												<c:if test="${!empty report.existingRequestUuid}">
													<span style="padding-left:20px;">
														<a onclick="return confirm('<spring:message code="reporting.reportHistory.confirmDelete"/>');" href="../reports/reportHistoryDelete.form?uuid=${report.existingRequestUuid}">
															<button border="0"><spring:message code="general.delete"/></button>
														</a>
													</span>
												</c:if>
							        		</td>
							        	</tr>
							        </table>
								</form>
							</spring:nestedPath>
							
						</fieldSet>
					</td>
					<td style="width:50%; vertical-align:top;">
						<fieldSet>
							<legend>
								<b><spring:message code="reporting.reportHistory.title"/></b>
							</legend>
							<div style="padding:10px;">
								<h4>
									<spring:message code="reporting.Report.mostRecentlyCompletedReport"/>
									&nbsp;&nbsp;
									<a href="${pageContext.request.contextPath}/module/reporting/reports/reportHistory.form?id=${report.reportDefinition.id}">
										(<spring:message code="reporting.viewAll"/>)
									</a>
								</h4>
								<div style="padding:5px 0px 5px 10px;">
									<openmrs:portlet url="reportRequests" id="completedRequests" moduleId="reporting" parameters="reportId=${report.reportDefinition.id}|status=SAVED,COMPLETED,FAILED|mostRecentNum=1"/>
								</div>
								<h4><spring:message code="reporting.Report.currentlyRunning"/></h4>
								<div style="padding:5px 0px 5px 10px;">
									<openmrs:portlet url="reportRequests" id="runningRequests" moduleId="reporting" parameters="reportId=${report.reportDefinition.id}|status=PROCESSING"/>
								</div>
								<h4><spring:message code="reporting.Report.currentlyQueued"/></h4>
								<div style="padding:5px 0px 5px 10px;">
									<openmrs:portlet url="reportRequests" id="queuedRequests" moduleId="reporting" parameters="reportId=${report.reportDefinition.id}|status=REQUESTED"/>
								</div>
								<h4><spring:message code="reporting.Report.currentlyScheduled"/></h4>
								<div style="padding:5px 0px 5px 10px;">
									<openmrs:portlet url="reportRequests" id="scheduledRequests" moduleId="reporting" parameters="reportId=${report.reportDefinition.id}|status=SCHEDULED"/>
								</div>
							</div>
						</fieldSet>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
<%@ include file="/WEB-INF/template/footer.jsp"%>