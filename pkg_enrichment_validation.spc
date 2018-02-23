CREATE OR REPLACE PACKAGE pkg_enrichment_validation AS

  PROCEDURE clear_enrichment_dtl_cache;
  
  PROCEDURE p_validate_enrich_set(piv_enrich_profile_id       VARCHAR2,
                                  piv_enrichment_set_value    VARCHAR2,
                                  v_prodenrich_reject_remarks OUT VARCHAR2);
                                  
  PROCEDURE p_validate_enrich(piv_enrich_profile_id       VARCHAR2,
                              piv_enrich_code             VARCHAR2,
                              piv_enrich_value            VARCHAR2,
                              v_prodenrich_reject_remarks OUT VARCHAR2);

  PROCEDURE p_add_enrichment_error_desc(piv_error_msg VARCHAR2);

END pkg_enrichment_validation;
/