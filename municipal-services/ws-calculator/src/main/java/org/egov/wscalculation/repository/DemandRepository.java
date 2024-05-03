package org.egov.wscalculation.repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.egov.common.contract.request.RequestInfo;
import org.egov.tracer.model.CustomException;
import org.egov.wscalculation.config.WSCalculationConfiguration;
import org.egov.wscalculation.constants.WSCalculationConstant;
import org.egov.wscalculation.web.models.Demand;
import org.egov.wscalculation.web.models.DemandNotificationObj;
import org.egov.wscalculation.web.models.DemandRequest;
import org.egov.wscalculation.web.models.DemandResponse;
import org.egov.wscalculation.producer.WSCalculationProducer;
import org.egov.wscalculation.repository.builder.DemandQueryBuilder;
import org.egov.wscalculation.repository.rowmapper.DemandRowMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.util.CollectionUtils;


@Repository
public class DemandRepository {


    @Autowired
    private ServiceRequestRepository serviceRequestRepository;

    @Autowired
    private WSCalculationConfiguration config;

    @Autowired
    private ObjectMapper mapper;

    @Autowired
    private WSCalculationProducer wsCalculationProducer;
    
    @Autowired
    private DemandQueryBuilder demandQueryBuilder;
    
    @Autowired
    private DemandRowMapper demandRowMapper;

    /**
     * Creates demand
     * @param requestInfo The RequestInfo of the calculation Request
     * @param demands The demands to be created
     * @return The list of demand created
     */
    public List<Demand> saveDemand(RequestInfo requestInfo, List<Demand> demands,DemandNotificationObj notificationObj){
        StringBuilder url = new StringBuilder(config.getBillingServiceHost());
        url.append(config.getDemandCreateEndPoint());
        DemandRequest request = new DemandRequest(requestInfo,demands);
        try{
            Object result = serviceRequestRepository.fetchResult(url, request);
            List<Demand>  demandList =  mapper.convertValue(result,DemandResponse.class).getDemands();
            if(!CollectionUtils.isEmpty(demandList)) {
                notificationObj.setSuccess(true);
                wsCalculationProducer.push(config.getOnDemandsSaved(), notificationObj);
            }
            return demandList;
        }
        catch(IllegalArgumentException e){
            notificationObj.setSuccess(false);
            wsCalculationProducer.push(config.getOnDemandsFailure(), notificationObj);
            throw new CustomException("EG_WS_PARSING_ERROR","Failed to parse response of create demand");
        }
    }

    /**
     * Updates the demand
     * @param requestInfo The RequestInfo of the calculation Request
     * @param demands The demands to be updated
     * @return The list of demand updated
     */
    public List<Demand> updateDemand(RequestInfo requestInfo, List<Demand> demands){
        StringBuilder url = new StringBuilder(config.getBillingServiceHost());
        url.append(config.getDemandUpdateEndPoint());
        DemandRequest request = new DemandRequest(requestInfo,demands);
        Object result = serviceRequestRepository.fetchResult(url, request);
        try{
            return mapper.convertValue(result,DemandResponse.class).getDemands();
        }
        catch(IllegalArgumentException e){
            throw new CustomException("EG_WS_PARSING_ERROR","Failed to parse response of update demand");
        }
    }
    
	
	/**
	 * Fetches demand from DB based on a map of business code and set of consumer codes
	 * 
	 * @param businessConsumercodeMap
	 * @param tenantId
	 * @return
	 */
	public List<Demand> getDemandsForConsumerCodes(Set<String> businessConsumercodes, String tenantId) {

		List<Object> presparedStmtList = new ArrayList<>();
		String sql = demandQueryBuilder.getDemandQueryForConsumerCodes(businessConsumercodes, presparedStmtList,
				tenantId);
		return JdbcTemplate.query(sql, presparedStmtList.toArray(), demandRowMapper);
	}


}
