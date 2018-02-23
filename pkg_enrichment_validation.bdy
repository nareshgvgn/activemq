CREATE OR REPLACE PACKAGE BODY pkg_enrichment_validation AS

  TYPE rec_enrichment_prf_dtl IS RECORD(
    profile_id         enrichment_dtl.profile_id%TYPE,
    enrichment_code    enrichment_dtl.ENRICHMENT_CODE%TYPE,
    mandatory_flag     enrichment_dtl.mandatory_flag%TYPE,
    enrich_sequence    enrichment_dtl.enrich_sequence%TYPE,
    enrich_data_type   enrichment_dtl.enrich_data_type%TYPE,
    enrich_min_length  enrichment_dtl.enrich_min_length%TYPE,
    enrich_max_length  enrichment_dtl.enrich_max_length%TYPE,
    enrich_description enrichment_dtl.enrich_description%TYPE,
    enrich_format      enrichment_dtl.enrich_format%TYPE,
    enrich_min_value   enrichment_dtl.enrich_min_value%TYPE,
    enrich_max_value   enrichment_dtl.enrich_max_value%TYPE,
    max_value_amnt     enrichment_dtl.max_value_amnt%TYPE,
    min_value_amnt     enrichment_dtl.min_value_amnt%TYPE,
    validation_flag    enrichment_dtl.validation_flag%TYPE,
    enrich_type        enrichment_dtl.enrich_type%TYPE,
    lov_values         VARCHAR2(100));

  TYPE ty_tab_enrichment_prf_dtl IS TABLE OF rec_enrichment_prf_dtl INDEX BY varchar2(70);

  TYPE ty_tab_enrichment_prf_mst IS TABLE OF ty_tab_enrichment_prf_dtl INDEX BY varchar2(12);

  enrichment_prf_cache ty_tab_enrichment_prf_mst;

  v_prodenrich_reject_remarks VARCHAR2(1000);

  PROCEDURE clear_enrichment_dtl_cache AS
  BEGIN
    enrichment_prf_cache.DELETE;
  END;

  PROCEDURE p_add_enrich_detail_to_cache(piv_profile_id VARCHAR2) AS
    CURSOR c_get_enrich IS
      SELECT ed.enrichment_code,
             ed.enrich_sequence,
             ed.enrich_data_type,
             ed.enrich_min_length,
             ed.enrich_max_length,
             ed.mandatory_flag,
             ed.enrich_description,
             ed.enrich_format,
             ed.enrich_min_value,
             ed.enrich_max_value,
             ed.max_value_amnt,
             ed.min_value_amnt,
             ed.validation_flag,
             ed.enrich_type,
             (select listagg(option_code, ', ') within
               group(
               order by option_code)
                from enrichment_dtl_lov l
               where l.enrichment_code = ed.enrichment_code
                 and l.profile_id = ed.profile_id) || ',' lov_values,
             (select listagg(enrich_type, ', ') within
               group(
               order by enrich_type)
                from enrichment_dtl l
               where l.profile_id = ed.profile_id) || ',' enrich_types
        FROM prf_enrichment_mst ep, enrichment_dtl ed
       WHERE ep.profile_id = ed.profile_id
         AND ep.valid_flag = 'Y'
         AND ed.valid_flag = 'Y'
         AND ed.profile_id = piv_profile_id
       ORDER BY ed.enrich_sequence;
  
    rec_enrich           rec_enrichment_prf_dtl;
    enrichment_dtl_cache ty_tab_enrichment_prf_dtl;
  BEGIN
    For i IN c_get_enrich LOOP
      IF enrichment_prf_cache.exists(piv_profile_id) = FALSE THEN
      
        rec_enrich.profile_id := piv_profile_id;
        rec_enrich.enrichment_code := i.enrichment_code;
        rec_enrich.enrich_sequence := i.enrich_sequence;
        rec_enrich.enrich_data_type := i.enrich_data_type;
        rec_enrich.enrich_min_length := i.enrich_min_length;
        rec_enrich.enrich_max_length := i.enrich_max_length;
        rec_enrich.mandatory_flag := i.mandatory_flag;
        rec_enrich.enrich_description := i.enrich_description;
        rec_enrich.enrich_format := i.enrich_format;
        rec_enrich.enrich_min_value := i.enrich_min_value;
        rec_enrich.enrich_max_value := i.enrich_max_value;
        rec_enrich.max_value_amnt := i.max_value_amnt;
        rec_enrich.min_value_amnt := i.min_value_amnt;
        rec_enrich.validation_flag := i.validation_flag;
        rec_enrich.enrich_type := i.enrich_type;
        enrichment_dtl_cache(i.enrichment_code) := rec_enrich;
      END IF;
    END LOOP;
    enrichment_prf_cache(piv_profile_id) := enrichment_dtl_cache;
  END;

  PROCEDURE p_split_enrichvalue(rec_enrich       rec_enrichment_prf_dtl,
                                piv_enrichment_set_value    VARCHAR2,
                                piv_position                OUT NUMBER,
                                v_prodenrich_reject_remarks OUT VARCHAR2) AS
  
  BEGIN
    v_prodenrich_reject_remarks := '';
    
  END;

  PROCEDURE p_validate_enrich_set(piv_enrich_profile_id       VARCHAR2,
                                  piv_enrichment_set_value    VARCHAR2,
                                  v_prodenrich_reject_remarks OUT VARCHAR2) AS
  
  enrichment_dtl_cache ty_tab_enrichment_prf_dtl;
  rec_enrich           rec_enrichment_prf_dtl;
  v_enrich_value VARCHAR2(1000);
  n_pos          NUMBER(3) := 0;
  BEGIN
    IF enrichment_prf_cache.exists(piv_enrich_profile_id) = FALSE THEN
      p_add_enrich_detail_to_cache(piv_enrich_profile_id);
    END IF;
    
    enrichment_dtl_cache := enrichment_prf_cache(piv_enrich_profile_id);
    FOR j IN 1.. enrichment_dtl_cache.COUNT  LOOP
    dbms_output.put_line(enrichment_dtl_cache(j).profile_id);
      --  rec_enrich := enrichment_dtl_cache(enrichment_dtl_cache(j).enrichment_code);
       -- p_split_enrichvalue(rec_enrich, piv_enrichment_set_value, n_pos, v_prodenrich_reject_remarks); 
    END LOOP;
    
  END;

  PROCEDURE p_validate_enrich(piv_enrich_profile_id       VARCHAR2,
                              piv_enrich_code             VARCHAR2,
                              piv_enrich_value            VARCHAR2,
                              v_prodenrich_reject_remarks OUT VARCHAR2) AS
  
    n_count              NUMBER(2);
    n_number             NUMBER(20);
    d_date               DATE;
    rec_enrich           rec_enrichment_prf_dtl;
    enrichment_dtl_cache ty_tab_enrichment_prf_dtl;
  BEGIN
    IF enrichment_prf_cache.exists(piv_enrich_profile_id) = FALSE THEN
      p_add_enrich_detail_to_cache(piv_enrich_profile_id);
    END IF;
    enrichment_dtl_cache := enrichment_prf_cache(piv_enrich_profile_id);
    rec_enrich           := enrichment_dtl_cache(piv_enrich_profile_id || '_' ||
                                                 piv_enrich_code);
    IF rec_enrich.mandatory_flag = 'Y' AND
       NVL(TRIM(piv_enrich_value), 'X') = 'X' THEN
      -- Mandatory Validation
      IF INSTR(nvl(v_prodenrich_reject_remarks, 'X'), 'E16', 1) = 0 THEN
        p_add_enrichment_error_desc('E16');
      END IF;
    END IF;
  
    IF NVL(TRIM(piv_enrich_value), 'X') <> 'X' THEN
      -- Length Validation
      --IF LENGTH(piv_enrich_value) > i.enrich_length THEN
      IF LENGTH(piv_enrich_value) > rec_enrich.enrich_max_length THEN
        IF INSTR(v_prodenrich_reject_remarks, 'E17', 1) = 0 THEN
          p_add_enrichment_error_desc('E17');
        END IF;
      END IF;
    
      -- Datatype Validation
      IF rec_enrich.enrich_data_type = 'D' THEN
        IF LENGTH(piv_enrich_value) <> LENGTH(rec_enrich.enrich_format) THEN
          p_add_enrichment_error_desc('E21');
        ELSE
        
          BEGIN
            d_date := TO_DATE(piv_enrich_value, rec_enrich.enrich_format);
          EXCEPTION
            WHEN others THEN
              p_add_enrichment_error_desc('E21');
          END;
        END IF;
      END IF;
    
      IF rec_enrich.enrich_data_type = 'N' OR
         rec_enrich.enrich_data_type = 'A' THEN
        BEGIN
          n_number := TO_NUMBER(piv_enrich_value);
        EXCEPTION
          WHEN OTHERS THEN
            IF INSTR(v_prodenrich_reject_remarks, 'E22', 1) = 0 THEN
              p_add_enrichment_error_desc('E22');
            END IF;
        END;
      END IF;
    
      -- Min Max Validation For Number Datatype
      IF rec_enrich.enrich_data_type = 'N' AND
         rec_enrich.validation_flag = 'Y' THEN
        IF /*i.min_value_flag = 'Y' AND*/
         piv_enrich_value < rec_enrich.min_value_amnt THEN
          IF INSTR(v_prodenrich_reject_remarks, 'E18', 1) = 0 THEN
            p_add_enrichment_error_desc('E18');
          END IF;
        END IF;
      
        IF /*i.max_value_flag = 'Y' AND*/
         piv_enrich_value >= rec_enrich.max_value_amnt THEN
          IF INSTR(v_prodenrich_reject_remarks, 'E19', 1) = 0 THEN
            p_add_enrichment_error_desc('E19');
          END IF;
        END IF;
      END IF;
    
      IF rec_enrich.validation_flag = 'Y' AND
         rec_enrich.enrich_data_type = 'S' THEN
        IF instr(rec_enrich.lov_values, trim(piv_enrich_value)) = 0 THEN
          p_add_enrichment_error_desc('E20');
        END IF;
      END IF;
    END IF;
  
    v_prodenrich_reject_remarks := TRIM(v_prodenrich_reject_remarks);
  
  END p_validate_enrich;

  PROCEDURE p_add_enrichment_error_desc(piv_error_msg VARCHAR2) AS
  BEGIN
    v_prodenrich_reject_remarks := v_prodenrich_reject_remarks ||
                                   piv_error_msg;
  END p_add_enrichment_error_desc;

END pkg_enrichment_validation;
/