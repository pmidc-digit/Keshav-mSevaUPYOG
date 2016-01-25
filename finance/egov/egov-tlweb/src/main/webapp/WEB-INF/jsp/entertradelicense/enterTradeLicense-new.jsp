<%--
  ~ eGov suite of products aim to improve the internal efficiency,transparency,
  ~    accountability and the service delivery of the government  organizations.
  ~
  ~     Copyright (C) <2015>  eGovernments Foundation
  ~
  ~     The updated version of eGov suite of products as by eGovernments Foundation
  ~     is available at http://www.egovernments.org
  ~
  ~     This program is free software: you can redistribute it and/or modify
  ~     it under the terms of the GNU General Public License as published by
  ~     the Free Software Foundation, either version 3 of the License, or
  ~     any later version.
  ~
  ~     This program is distributed in the hope that it will be useful,
  ~     but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~     GNU General Public License for more details.
  ~
  ~     You should have received a copy of the GNU General Public License
  ~     along with this program. If not, see http://www.gnu.org/licenses/ or
  ~     http://www.gnu.org/licenses/gpl.html .
  ~
  ~     In addition to the terms of the GPL license to be adhered to in using this
  ~     program, the following additional terms are to be complied with:
  ~
  ~         1) All versions of this program, verbatim or modified must carry this
  ~            Legal Notice.
  ~
  ~         2) Any misrepresentation of the origin of the material is prohibited. It
  ~            is required that all modified versions of this material be marked in
  ~            reasonable ways as different from the original version.
  ~
  ~         3) This license does not grant any rights to any user of the program
  ~            with regards to rights under trademark law for use of the trade names
  ~            or trademarks of eGovernments Foundation.
  ~
  ~   In case of any queries, you can reach eGovernments Foundation at contact@egovernments.org.
  --%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/includes/taglibs.jsp"%>
<html>
	<head>
		<title><s:text name="page.title.entertrade" /></title>
 	</head>
	<body>
		<div id="enterLicense_error" class="error-msg" style="display:none;"></div> 
                <div class="row">
                    <div class="col-md-12">
                     <div class="text-right error-msg" style="font-size:14px;"><s:text name="dateofapplication.lbl" /> : <s:date name="applicationDate"  format="dd/MM/yyyy"/></div>
                     <s:if test="%{applicationNumber!=null}">
                    	 <div class="text-right error-msg" style="font-size:14px;"><s:text name="application.num" /> : <s:property value="%{applicationNumber}" /></div>
                 	</s:if>
               		<s:if test="%{hasErrors()}">
						<div align="center" class="error-msg" >
							<s:actionerror />
							<s:fielderror/>
						</div>			 
					</s:if>
					<s:if test="%{hasActionMessages()}">
						<div class="messagestyle">
							<s:actionmessage theme="simple" />
						</div>
					</s:if>
                 	
                 	<s:form name="registrationForm" action="enterTradeLicense-enterExisting" theme="css_xhtml"  enctype="multipart/form-data" 
					cssClass="form-horizontal form-groups-bordered" validate="true" >    
					<s:push value="model"> 
							<s:token/>
							<s:hidden name="actionName" value="create" />
							<s:hidden id="detailChanged" name="detailChanged" />
							<s:hidden id="applicationDate" name="applicationDate" />
							<s:hidden name="id" id="id" />
							<s:hidden name="feeTypeId" id="feeTypeId" />
                        <div class="panel panel-primary" data-collapsed="0">
                            <div class="panel-heading">
								<div class="panel-title" style="text-align:center">
										<s:text name='page.title.entertrade' /> 
								</div>
                                <ul class="nav nav-tabs" id="settingstab">
                                    <li class="active"><a data-toggle="tab" href="#tradedetails" data-tabidx="0" aria-expanded="true">Trade Details</a></li>
                                    <li class=""><a data-toggle="tab" href="#tradeattachments" data-tabidx="1" aria-expanded="false">Enclosed Documents</a></li>
                                </ul>
                            </div>
                            
                             <div class="panel-body custom-form">
                                <div class="tab-content">
                                    <div class="tab-pane fade active in" id="tradedetails">
													
											<div class="form-group">
											    <label class="col-sm-3 control-label text-right"><s:text name='license.old.license.number' /><span class="mandatory"></span></label>
											    <div class="col-sm-3 add-margin">
											           <s:textfield name="oldLicenseNumber"  id="oldLicenseNumber" onBlur="checkLength(this,50)"  maxlength="50" cssClass="form-control patternvalidation"  data-pattern="alphanumerichyphenbackslash" />
											    </div>
											    <label class="col-sm-2 control-label text-right"><s:text name='license.enter.issuedate' /><span class="mandatory"></span></label>
											     <div class="col-sm-3 add-margin">
											      	<s:date name="dateOfCreation" id="dateOfCreationformat" format="dd/MM/yyyy" />
													<s:textfield  name="dateOfCreation" id="dateOfCreation" class="form-control datepicker" data-date-end-date="0d" maxlength="10" size="10" value="%{dateOfCreationformat}" />
											   </div> 
											</div>		
                                             <%@ include file='../common/licensee.jsp'%>
	                                         <%@ include file='../common/address.jsp'%>
	                                         <%@ include file='../common/license.jsp'%>
	                                         
	                                         <div class="panel-heading custom_form_panel_heading">
											    <div class="panel-title"><s:text name='license.title.feedetail' /></div>
											</div>
											
											<div class="col-md-12">
											<table class="table table-bordered">
												<thead>
													<tr>
														<th><s:text name='license.fin.year'/></th>
														<th><s:text name='license.fee.amount'/></th>
													</tr>
												</thead>
												<tbody>
												<s:iterator value="legacyInstallmentwiseFees" var="LIFee" status="status">
													<tr>
														<c:set value="${LIFee.key}-${fn:substring(LIFee.key+1,2, 4)}" var="finyear"/>
														<td><s:textfield  name="" cssClass="form-control" readonly="true" value="%{#attr.finyear}" tabindex="-1"/></td>
														<td><s:textfield name="legacyInstallmentwiseFees[%{#attr.LIFee.key}]" cssClass="form-control patternvalidation" value="%{#attr.LIFee.value}" data-pattern="decimalvalue"/> </td>
													</tr>
												</s:iterator>
												</tbody>
												<tfoot>
													<tr>
														<td class="error-msg" colspan="2">
															<s:text  name="license.legacy.info">
																<s:param>${finyear}</s:param>
															</s:text>
														</td>
													</tr>
												</tfoot>
											</table>
											</div>
											
                                    </div>
                                    <div class="tab-pane fade" id="tradeattachments"> 
                                        <div>
											<%@include file="../common/documentUpload.jsp" %>
										</div>
                                    </div>
                            	</div>
                            </div>
                        </div> 
                        <div class="row">
							<div class="text-center">
								<button type="submit" id="btnsave" class="btn btn-primary" onclick="return validateForm();">
									Save</button>
								<button type="button" id="btnclose" class="btn btn-default" onclick="window.close();">
									Close</button>
							</div>
						</div>
                        </s:push>  
                    </s:form> 
                    </div>
                </div>
                <script>
					jQuery(".datepicker").datepicker({
						format: "dd/mm/yyyy",
						autoclose: true 
					}); 
				</script>
        <script src="../resources/app/js/newtrade.js"></script>
        <script>
	
			function validateForm() {
				if (document.getElementById("oldLicenseNumber").value == '' || document.getElementById("oldLicenseNumber").value == null){
					showMessage('enterLicense_error', '<s:text name="newlicense.oldlicensenumber.null" />');
					document.getElementById("oldLicenseNumber").focus();
					return false;
				} else if (document.getElementById("dateOfCreation").value == '' || document.getElementById("dateOfCreation").value == null){
					showMessage('enterLicense_error', '<s:text name="newlicense.dateofcreation.null" />');
					document.getElementById("dateOfCreation").focus();
					return false;
				} else if (document.getElementById("mobilePhoneNumber").value == '' || document.getElementById("mobilePhoneNumber").value == null){
					showMessage('enterLicense_error', '<s:text name="newlicense.mobilephonenumber.null" />');
					document.getElementById("mobilePhoneNumber").focus();
					return false;
				} else if (document.getElementById("applicantName").value == '' || document.getElementById("applicantName").value == null){
					showMessage('enterLicense_error', '<s:text name="newlicense.applicantname.null" />');
					document.getElementById("applicantName").focus();
					return false;
				} else if (document.getElementById("fatherOrSpouseName").value == '' || document.getElementById("fatherOrSpouseName").value == null){
					showMessage('enterLicense_error', '<s:text name="newlicense.fatherorspousename.null" />');
					document.getElementById("fatherOrSpouseName").focus();
					return false;
				} else if (document.getElementById("emailId").value == '' || document.getElementById("emailId").value == null){
					showMessage('enterLicense_error', '<s:text name="newlicense.email.null" />');
					document.getElementById("emailId").focus();
					return false;
				} else if (document.getElementById("licenseeAddress").value == '' || document.getElementById("licenseeAddress").value == null){
					showMessage('enterLicense_error', '<s:text name="newlicense.licenseeaddress.null" />');
					document.getElementById("licenseeAddress").focus();
					return false;
				} else if (document.getElementById("boundary").value == '-1'){
					showMessage('enterLicense_error', '<s:text name="newlicense.locality.null" />');
					document.getElementById("boundary").focus();
					return false;
				} else if (document.getElementById("ownershipType").value == '-1'){
					showMessage('enterLicense_error', '<s:text name="newlicense.ownershiptype.null" />');
					document.getElementById("ownershipType").focus();
					return false;
				} else if (document.getElementById("address").value == '' || document.getElementById("address").value == null){
					showMessage('enterLicense_error', '<s:text name="newlicense.licenseaddress.null" />');
					document.getElementById("address").focus();
					return false;
				} else if (document.getElementById("buildingType").value == '-1'){
					showMessage('enterLicense_error', '<s:text name="newlicense.buildingtype.null" />');
					document.getElementById("buildingType").focus();
					return false;
				} else if (document.getElementById("category").value == '-1'){
					showMessage('enterLicense_error', '<s:text name="newlicense.category.null" />');
					document.getElementById("category").focus();
					return false;
				}  else if (document.getElementById("subCategory").value == '-1'){
					showMessage('enterLicense_error', '<s:text name="newlicense.subcategory.null" />');
					document.getElementById("subCategory").focus();
					return false;
				}	else if (document.getElementById("tradeArea_weight").value == '' || document.getElementById("tradeArea_weight").value == null){
					showMessage('enterLicense_error', '<s:text name="newlicense.tradeareaweight.null" />');
					document.getElementById("tradeArea_weight").focus();
					return false;
				}	else if (document.getElementById("uom").value == ""){
					showMessage('enterLicense_error', '<s:text name="newlicense.uom.null" />');
					document.getElementById("uom").focus();
					return false;
				} else if (document.getElementById("workersCapacity").value == '' ||  document.getElementById("workersCapacity").value == null ||
						 document.getElementById("workersCapacity").value == 0) {
					showMessage('enterLicense_error', '<s:text name="newlicense.workerscapacity.null" />');
					document.getElementById("workersCapacity").focus();
					return false;
				} else{
					clearMessage('enterLicense_error');
					toggleFields(false,"");
					document.registrationForm.action='${pageContext.request.contextPath}/entertradelicense/enterTradeLicense-enterExisting.action';
					document.registrationForm.submit();

					}
  			}

			// Calls propertytax REST api to retrieve property details for an assessment no
			// url : contextpath/ptis/rest/property/assessmentno (ex: contextpath/ptis/rest/property/1085000001)
    		function callPropertyTaxRest(){
               	var propertyNo = jQuery("#propertyNo").val();
            	if(propertyNo!="" && propertyNo!=null){
					console.log(propertyNo); 
					jQuery.ajax({
						url: "/ptis/rest/property/" + propertyNo,
						type:"GET",
						contentType:"application/x-www-form-urlencoded",
						success:function(data){
							if(data.errorDetails.errorCode != null && data.errorDetails.errorCode != ''){
								bootbox.alert(data.errorDetails.errorMessage);
							} else{
								if(data.boundaryDetails!=null){
									jQuery("#zoneName").val(data.boundaryDetails.zoneName);
									jQuery("#wardName").val(data.boundaryDetails.wardName);
									jQuery("#address").val(data.propertyAddress);
								}
							}
						},
						error:function(e){
							document.getElementById("propertyNo").value="";
							resetOnPropertyNumChange();
							bootbox.alert("Error getting property details");
						}
					});
            	} else{
					showMessage('enterLicense_error', '<s:text name="newlicense.propertyNo.null" />');
                }
            }

 		</script>
    </body>
</html>
