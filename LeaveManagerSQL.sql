/*
SQLyog Ultimate v8.55 
MySQL - 5.6.10 : Database - seleniumkeyword1
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`seleniumkeyword1` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `seleniumkeyword1`;

/*Table structure for table `keyword_mst` */

DROP TABLE IF EXISTS `keyword_mst`;

CREATE TABLE `keyword_mst` (
  `keyword` varchar(45) NOT NULL,
  `javacode` blob NOT NULL,
  `class_name` varchar(90) NOT NULL,
  `description` varchar(100) NOT NULL,
  `report_success_desc` varchar(200) NOT NULL,
  `report_error_desc` varchar(200) NOT NULL,
  PRIMARY KEY (`keyword`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `keyword_mst` */

insert  into `keyword_mst`(`keyword`,`javacode`,`class_name`,`description`,`report_success_desc`,`report_error_desc`) values ('FILTERVIEW_EXPAND','import org.openqa.selenium.WebDriver;\r\nimport org.openqa.selenium.JavascriptExecutor;\r\npublic class FilterViewExpander {\r\n	public static void test(WebDriver driver)\r\n	{\r\n		try\r\n		{\r\n		JavascriptExecutor js = (JavascriptExecutor)driver;\r\n		js.executeScript(jsCode());\r\n		}\r\n		catch(Exception e){\r\n		System.out.println(e);\r\n		e.printStackTrace();\r\n		}\r\n	}\r\n	public static String jsCode()\r\n	{\r\n		return \"var filterViews = Ext.ComponentQuery.query(\'filterView\');filterViews[0].expand();\";\r\n	}\r\n}\r\n','FilterViewExpander','Expanded the Filter View','Expanded the Filter View','Unable to Expand Filter View');

/*Table structure for table `project_mst` */

DROP TABLE IF EXISTS `project_mst`;

CREATE TABLE `project_mst` (
  `project_id` varchar(10) NOT NULL,
  `project_name` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`project_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `project_mst` */

insert  into `project_mst`(`project_id`,`project_name`) values ('PRJ001','GCP');

/*Table structure for table `property_set_dtl` */

DROP TABLE IF EXISTS `property_set_dtl`;

CREATE TABLE `property_set_dtl` (
  `property_name` varchar(30) NOT NULL,
  `property_value` varchar(100) DEFAULT NULL,
  `parent_record_key` varchar(10) NOT NULL,
  PRIMARY KEY (`property_name`,`parent_record_key`),
  KEY `FK_property_set_dtl` (`parent_record_key`),
  CONSTRAINT `FK_property_set_dtl` FOREIGN KEY (`parent_record_key`) REFERENCES `property_set_mst` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `property_set_dtl` */

insert  into `property_set_dtl`(`property_name`,`property_value`,`parent_record_key`) values ('baseUrl','http://192.168.100.109:7070/gcpuscash/','8640e02b-6'),('baseUrl','http://192.168.100.109:7070','9cdddea5-6'),('Prop1','Prop vaue1','ae0bdd92-6');

/*Table structure for table `property_set_mst` */

DROP TABLE IF EXISTS `property_set_mst`;

CREATE TABLE `property_set_mst` (
  `id` varchar(10) NOT NULL,
  `set_name` varchar(30) DEFAULT NULL,
  `modified_by` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `property_set_mst` */

insert  into `property_set_mst`(`id`,`set_name`,`modified_by`) values ('8640e02b-6','Ruchita GCP','Naresh'),('9cdddea5-6','Naresh GCP','Naresh'),('ae0bdd92-6','DOn2','Naresh');

/*Table structure for table `testcase_mst` */

DROP TABLE IF EXISTS `testcase_mst`;

CREATE TABLE `testcase_mst` (
  `testcase_id` varchar(10) NOT NULL,
  `priority` int(1) DEFAULT NULL,
  `module_name` varchar(100) DEFAULT NULL,
  `test_designed_by` varchar(200) NOT NULL,
  `testcase_title` varchar(255) NOT NULL,
  `testcase_description` varchar(800) DEFAULT NULL,
  `testcase_preexecute` varchar(100) DEFAULT NULL COMMENT 'comma seperated Test case Ids which should be executed before this test case',
  `project_id` varchar(10) DEFAULT NULL,
  `record_id` varchar(10) NOT NULL,
  `version` int(10) NOT NULL DEFAULT '0',
  `skip_flag` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`record_id`),
  UNIQUE KEY `uk_testcaseId` (`testcase_id`),
  KEY `FK_testcase_mst` (`project_id`),
  CONSTRAINT `FK_testcase_mst` FOREIGN KEY (`project_id`) REFERENCES `project_mst` (`project_id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `testcase_mst` */

insert  into `testcase_mst`(`testcase_id`,`priority`,`module_name`,`test_designed_by`,`testcase_title`,`testcase_description`,`testcase_preexecute`,`project_id`,`record_id`,`version`,`skip_flag`) values ('TST001',0,'Security','Naresh','User Category List','User Category List','',NULL,'887f477f-5',0,NULL);

/*Table structure for table `testcase_steps_mst` */

DROP TABLE IF EXISTS `testcase_steps_mst`;

CREATE TABLE `testcase_steps_mst` (
  `sequence_no` int(4) NOT NULL,
  `keyword` varchar(100) NOT NULL,
  `description` varchar(400) NOT NULL,
  `input_data` varchar(200) DEFAULT NULL,
  `teststep_id` varchar(10) NOT NULL,
  `object_name` varchar(100) DEFAULT NULL,
  `object_type` varchar(100) DEFAULT NULL,
  `record_id` varchar(10) NOT NULL,
  `version` int(10) NOT NULL DEFAULT '0',
  `parent_record_id` varchar(10) NOT NULL,
  PRIMARY KEY (`record_id`),
  UNIQUE KEY `uk_teststepid` (`teststep_id`),
  KEY `FK_testcase_steps_mst` (`parent_record_id`),
  CONSTRAINT `FK_testcase_steps_mst` FOREIGN KEY (`parent_record_id`) REFERENCES `testcase_mst` (`record_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `testcase_steps_mst` */

insert  into `testcase_steps_mst`(`sequence_no`,`keyword`,`description`,`input_data`,`teststep_id`,`object_name`,`object_type`,`record_id`,`version`,`parent_record_id`) values (5,'FILTERVIEW_EXPAND','Expand Filter View',NULL,'TSP005',NULL,NULL,'3b9bd9f0-5',0,'887f477f-5'),(1,'GOTOURL','Go to Login Page','${baseUrl}/gcpuscash/loginform.action','TSP001',NULL,NULL,'887f477f-6',0,'887f477f-5'),(2,'SETTEXT','Set text in User Code','MARK','TSP002','txtUser','ID','9b2743af-5',0,'887f477f-5'),(6,'CLICK','CLick on Create role Button',NULL,'TSP006','addNewUserCategoryT41','ID','a0e99755-5',0,'887f477f-5'),(3,'CLICK','Click on Login Button','','TSP003','btnLogin','ID','dce83836-5',0,'887f477f-5'),(4,'GOTOURL','Goto Role List','${baseUrl}/gcpuscash/userAdminCategoryList.form','TSP004',NULL,NULL,'fc5c75b1-5',0,'887f477f-5');

/*Table structure for table `testcaseresult` */

DROP TABLE IF EXISTS `testcaseresult`;

CREATE TABLE `testcaseresult` (
  `TestRunID` varchar(10) NOT NULL,
  `TestCaseRecordID` varchar(10) NOT NULL,
  `Status` int(1) DEFAULT NULL,
  PRIMARY KEY (`TestRunID`,`TestCaseRecordID`),
  CONSTRAINT `FK_testcaseresult` FOREIGN KEY (`TestRunID`) REFERENCES `testrunresult` (`TestRunID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `testcaseresult` */

insert  into `testcaseresult`(`TestRunID`,`TestCaseRecordID`,`Status`) values ('0f1154df-6','887f477f-5',2),('10acfbb4-6','887f477f-5',2),('157f461b-6','887f477f-5',2),('16549a4e-6','887f477f-5',2),('1b9f7951-6','887f477f-5',2),('2575ee4e-6','887f477f-5',2),('2c6bd80d-6','887f477f-5',2),('36415640-6','887f477f-5',2),('42f6a512-6','887f477f-5',2),('452a39b8-6','887f477f-5',2),('4599833a-6','887f477f-5',2),('653fd6ca-6','887f477f-5',2),('7742fd6d-6','887f477f-5',2),('7964fefd-6','887f477f-5',2),('798ce8e2-6','887f477f-5',2),('8b751bed-6','887f477f-5',3),('8f4c0b0e-6','887f477f-5',3),('928326e8-6','887f477f-5',2),('aa054b8a-6','887f477f-5',2),('aabd12e4-6','887f477f-5',2),('b10d7399-6','887f477f-5',2),('bb068dda-6','887f477f-5',2),('bb103b40-6','887f477f-5',2),('cb49dcc2-6','887f477f-5',2),('d8bcef4b-6','887f477f-5',2),('ed25ed7a-6','887f477f-5',2),('f841f24a-6','887f477f-5',2);

/*Table structure for table `testcasestepresult` */

DROP TABLE IF EXISTS `testcasestepresult`;

CREATE TABLE `testcasestepresult` (
  `TestRunID` varchar(10) NOT NULL,
  `TestCaseRecordID` varchar(10) NOT NULL,
  `TestStepRecordId` varchar(10) NOT NULL,
  `Status` int(1) DEFAULT NULL,
  `details` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`TestRunID`,`TestCaseRecordID`,`TestStepRecordId`),
  CONSTRAINT `FK_testcasestepresult` FOREIGN KEY (`TestRunID`, `TestCaseRecordID`) REFERENCES `testcaseresult` (`TestRunID`, `TestCaseRecordID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `testcasestepresult` */

insert  into `testcasestepresult`(`TestRunID`,`TestCaseRecordID`,`TestStepRecordId`,`Status`,`details`) values ('0f1154df-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('0f1154df-6','887f477f-5','9b2743af-5',2,'{\"description\":\"Specified Element Not Found\"}'),('10acfbb4-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('10acfbb4-6','887f477f-5','9b2743af-5',2,'{\"description\":\"Specified Element Not Found\"}'),('157f461b-6','887f477f-5','3b9bd9f0-5',3,'{\"description\":\"Expanded the Filter View\"}'),('157f461b-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://localhost:7070/gcpuscashadmin/loginform.action\"}'),('157f461b-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set U1TH value in txtUser\"}'),('157f461b-6','887f477f-5','a0e99755-5',2,'{\"description\":\"Specified Element Not Found\"}'),('157f461b-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('157f461b-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://localhost:7070/gcpuscashadmin/userAdminCategoryList.form\"}'),('16549a4e-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to ${baseUrl}/gcpuscash/loginform.action\"}'),('16549a4e-6','887f477f-5','9b2743af-5',2,'{\"description\":\"Specified Element Not Found\"}'),('1b9f7951-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('1b9f7951-6','887f477f-5','9b2743af-5',2,'{\"description\":\"Set MARK value in txtUser\"}'),('2575ee4e-6','887f477f-5','3b9bd9f0-5',3,'{\"description\":\"Expanded the Filter View\"}'),('2575ee4e-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('2575ee4e-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set MARK value in txtUser\"}'),('2575ee4e-6','887f477f-5','a0e99755-5',2,'{\"description\":\"Clicked the addNewUserCategoryT41\"}'),('2575ee4e-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('2575ee4e-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/userAdminCategoryList.form\"}'),('2c6bd80d-6','887f477f-5','3b9bd9f0-5',2,'{\"description\":\"Expanded the Filter View\"}'),('2c6bd80d-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('2c6bd80d-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set MARK value in txtUser\"}'),('2c6bd80d-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('2c6bd80d-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/userAdminCategoryList.form\"}'),('36415640-6','887f477f-5','3b9bd9f0-5',2,'{\"description\":\"Expanded the Filter View\"}'),('36415640-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to ${baseUrl}/gcpuscash/loginform.action\"}'),('36415640-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set MARK value in txtUser\"}'),('36415640-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('36415640-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/userAdminCategoryList.form\"}'),('42f6a512-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('42f6a512-6','887f477f-5','9b2743af-5',2,'{\"description\":\"Specified Element Not Found\"}'),('452a39b8-6','887f477f-5','3b9bd9f0-5',3,'{\"description\":\"Expanded the Filter View\"}'),('452a39b8-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('452a39b8-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set MARK value in txtUser\"}'),('452a39b8-6','887f477f-5','a0e99755-5',2,'{\"description\":\"Specified Element Not Found\"}'),('452a39b8-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('452a39b8-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/userAdminCategoryList.form\"}'),('4599833a-6','887f477f-5','3b9bd9f0-5',2,'{\"description\":\"Expanded the Filter View\"}'),('4599833a-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to ${baseUrl}/gcpuscash/loginform.action\"}'),('4599833a-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set MARK value in txtUser\"}'),('4599833a-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('4599833a-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to ${baseUrl}/gcpuscash/userAdminCategoryList.form\"}'),('653fd6ca-6','887f477f-5','887f477f-6',2,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('7742fd6d-6','887f477f-5','3b9bd9f0-5',3,'{\"description\":\"Expanded the Filter View\"}'),('7742fd6d-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('7742fd6d-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set MARK value in txtUser\"}'),('7742fd6d-6','887f477f-5','a0e99755-5',2,'{\"description\":\"Specified Element Not Found\"}'),('7742fd6d-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('7742fd6d-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/userAdminCategoryList.form\"}'),('7964fefd-6','887f477f-5','3b9bd9f0-5',3,'{\"description\":\"Expanded the Filter View\"}'),('7964fefd-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('7964fefd-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set MARK value in txtUser\"}'),('7964fefd-6','887f477f-5','a0e99755-5',2,'{\"description\":\"Specified Element Not Found\"}'),('7964fefd-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('7964fefd-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/userAdminCategoryList.form\"}'),('798ce8e2-6','887f477f-5','3b9bd9f0-5',3,'{\"description\":\"Expanded the Filter View\"}'),('798ce8e2-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://localhost:7070/gcpuscashadmin/loginform.action\"}'),('798ce8e2-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set U1TH value in txtUser\"}'),('798ce8e2-6','887f477f-5','a0e99755-5',2,'{\"description\":\"Specified Element Not Found\"}'),('798ce8e2-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('798ce8e2-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://localhost:7070/gcpuscashadmin/userAdminCategoryList.form\"}'),('8b751bed-6','887f477f-5','3b9bd9f0-5',3,'{\"description\":\"Expanded the Filter View\"}'),('8b751bed-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://localhost:7070/gcpuscashadmin/loginform.action\"}'),('8b751bed-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set U1TH value in txtUser\"}'),('8b751bed-6','887f477f-5','a0e99755-5',3,'{\"description\":\"Clicked the addNewUserCategoryT4\"}'),('8b751bed-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('8b751bed-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://localhost:7070/gcpuscashadmin/userAdminCategoryList.form\"}'),('8f4c0b0e-6','887f477f-5','3b9bd9f0-5',3,'{\"description\":\"Expanded the Filter View\"}'),('8f4c0b0e-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://localhost:7070/gcpuscashadmin/loginform.action\"}'),('8f4c0b0e-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set U1TH value in txtUser\"}'),('8f4c0b0e-6','887f477f-5','a0e99755-5',3,'{\"description\":\"Clicked the addNewUserCategoryT4\"}'),('8f4c0b0e-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('8f4c0b0e-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://localhost:7070/gcpuscashadmin/userAdminCategoryList.form\"}'),('928326e8-6','887f477f-5','3b9bd9f0-5',3,'{\"description\":\"Expanded the Filter View\"}'),('928326e8-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://localhost:7070/gcpuscashadmin/loginform.action\"}'),('928326e8-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set U1TH value in txtUser\"}'),('928326e8-6','887f477f-5','a0e99755-5',2,'{\"description\":\"Specified Element Not Found\"}'),('928326e8-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('928326e8-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://localhost:7070/gcpuscashadmin/userAdminCategoryList.form\"}'),('aa054b8a-6','887f477f-5','3b9bd9f0-5',3,'{\"description\":\"Expanded the Filter View\"}'),('aa054b8a-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('aa054b8a-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set MARK value in txtUser\"}'),('aa054b8a-6','887f477f-5','a0e99755-5',2,'{\"description\":\"Specified Element Not Found\"}'),('aa054b8a-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('aa054b8a-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/userAdminCategoryList.form\"}'),('aabd12e4-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://localhost:7070/gcpuscashadmin/loginform.action\"}'),('aabd12e4-6','887f477f-5','9b2743af-5',2,'{\"description\":\"Specified Element Not Found\"}'),('b10d7399-6','887f477f-5','3b9bd9f0-5',3,'{\"description\":\"Expanded the Filter View\"}'),('b10d7399-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://localhost:7070/gcpuscashadmin/loginform.action\"}'),('b10d7399-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set U1TH value in txtUser\"}'),('b10d7399-6','887f477f-5','a0e99755-5',2,'{\"description\":\"Specified Element Not Found\"}'),('b10d7399-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('b10d7399-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://localhost:7070/gcpuscashadmin/userAdminCategoryList.form\"}'),('bb068dda-6','887f477f-5','3b9bd9f0-5',3,'{\"description\":\"Expanded the Filter View\"}'),('bb068dda-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('bb068dda-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set MARK value in txtUser\"}'),('bb068dda-6','887f477f-5','a0e99755-5',2,'{\"description\":\"Specified Element Not Found\"}'),('bb068dda-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('bb068dda-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/userAdminCategoryList.form\"}'),('bb103b40-6','887f477f-5','3b9bd9f0-5',3,'{\"description\":\"Expanded the Filter View\"}'),('bb103b40-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://localhost:7070/gcpuscashadmin/loginform.action\"}'),('bb103b40-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set U1TH value in txtUser\"}'),('bb103b40-6','887f477f-5','a0e99755-5',2,'{\"description\":\"Specified Element Not Found\"}'),('bb103b40-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('bb103b40-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://localhost:7070/gcpuscashadmin/userAdminCategoryList.form\"}'),('cb49dcc2-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('cb49dcc2-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set MARK value in txtUser\"}'),('cb49dcc2-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('cb49dcc2-6','887f477f-5','fc5c75b1-5',2,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/userAdminCategoryList.form\"}'),('d8bcef4b-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('d8bcef4b-6','887f477f-5','9b2743af-5',2,'{\"description\":\"Specified Element Not Found\"}'),('ed25ed7a-6','887f477f-5','3b9bd9f0-5',3,'{\"description\":\"Expanded the Filter View\"}'),('ed25ed7a-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('ed25ed7a-6','887f477f-5','9b2743af-5',3,'{\"description\":\"Set MARK value in txtUser\"}'),('ed25ed7a-6','887f477f-5','a0e99755-5',2,'{\"description\":\"Specified Element Not Found\"}'),('ed25ed7a-6','887f477f-5','dce83836-5',3,'{\"description\":\"Clicked the btnLogin\"}'),('ed25ed7a-6','887f477f-5','fc5c75b1-5',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/userAdminCategoryList.form\"}'),('f841f24a-6','887f477f-5','887f477f-6',3,'{\"description\":\"Navigated to http://192.168.100.109:7070/gcpuscash/loginform.action\"}'),('f841f24a-6','887f477f-5','9b2743af-5',2,'{\"description\":\"Set MARK value in txtUser\"}');

/*Table structure for table `testrunresult` */

DROP TABLE IF EXISTS `testrunresult`;

CREATE TABLE `testrunresult` (
  `TestRunID` varchar(10) NOT NULL,
  `TestRunBy` varchar(100) DEFAULT NULL,
  `StartTime` datetime DEFAULT NULL,
  `EndTime` datetime DEFAULT NULL,
  `Status` int(1) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `machine` varchar(50) DEFAULT NULL,
  `browser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`TestRunID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `testrunresult` */

insert  into `testrunresult`(`TestRunID`,`TestRunBy`,`StartTime`,`EndTime`,`Status`,`title`,`machine`,`browser`) values ('095b9145-6','Naresh','2017-07-05 14:13:37',NULL,0,NULL,NULL,NULL),('0f1154df-6','Naresh','2017-07-11 17:55:47','2017-07-11 17:55:49',1,NULL,NULL,NULL),('10acfbb4-6','Naresh','2017-07-07 14:32:57','2017-07-07 14:33:20',1,NULL,NULL,NULL),('157f461b-6','Naresh','2017-07-05 14:13:57','2017-07-05 14:14:20',1,NULL,NULL,NULL),('16549a4e-6','Naresh','2017-07-13 19:19:28','2017-07-13 19:19:31',1,'Naresh Second','192.168.100.109','chrome'),('1b9f7951-6','Naresh','2017-07-11 17:56:08',NULL,0,'345',NULL,NULL),('2575ee4e-6','Naresh','2017-07-11 18:10:43',NULL,0,'test','192.168.100.109','111'),('2c6bd80d-6','Naresh','2017-07-13 19:12:55','2017-07-13 19:13:19',1,'Naresh First','192.168.100.109','chrome'),('343a17ca-6','Naresh','2017-07-12 13:37:53',NULL,0,'Chrome test','192.168.100.109','chrome'),('36415640-6','Naresh','2017-07-13 19:20:21','2017-07-13 19:20:35',1,'234','192.168.100.109','chrome'),('37ad2c4e-6','Naresh','2017-07-13 19:27:33',NULL,0,'Test','192.168.100.109','chromwe'),('42f6a512-6','Naresh','2017-07-12 13:38:18','2017-07-12 13:38:23',1,'Chrome test','192.168.100.109','chrome'),('452a39b8-6','Naresh','2017-07-07 14:34:25','2017-07-07 14:34:37',1,NULL,NULL,NULL),('4599833a-6','Naresh','2017-07-13 19:27:57','2017-07-13 19:28:13',1,'Test','192.168.100.109','chromwe'),('5baf4eb2-6','Naresh','2017-07-11 15:27:36',NULL,0,NULL,NULL,NULL),('653fd6ca-6','Naresh','2017-07-11 17:58:11',NULL,0,'qe',NULL,NULL),('7742fd6d-6','Naresh','2017-07-07 19:15:00','2017-07-07 19:15:09',1,NULL,NULL,NULL),('7964fefd-6','Naresh','2017-07-07 19:15:04','2017-07-07 19:15:12',1,NULL,NULL,NULL),('798ce8e2-6','Naresh','2017-07-05 16:04:07','2017-07-05 16:04:28',1,NULL,NULL,NULL),('8b751bed-6','Naresh','2017-07-05 13:34:18','2017-07-05 13:34:38',1,NULL,NULL,NULL),('8f4c0b0e-6','Naresh','2017-07-05 13:34:25','2017-07-05 13:34:42',1,NULL,NULL,NULL),('928326e8-6','Naresh','2017-07-05 14:46:05','2017-07-05 14:46:27',1,NULL,NULL,NULL),('aa054b8a-6','Naresh','2017-07-07 19:09:16','2017-07-07 19:09:25',1,NULL,NULL,NULL),('aabd12e4-6','Naresh','2017-07-07 12:42:42','2017-07-07 12:42:48',1,NULL,NULL,NULL),('b10d7399-6','Naresh','2017-07-05 14:39:47','2017-07-05 14:40:09',1,NULL,NULL,NULL),('bb068dda-6','Naresh','2017-07-07 19:16:54','2017-07-07 19:17:04',1,NULL,NULL,NULL),('bb103b40-6','Naresh','2017-07-05 14:47:13','2017-07-05 14:47:34',1,NULL,NULL,NULL),('cb49dcc2-6','Naresh','2017-07-07 19:17:21','2017-07-07 19:17:26',1,NULL,NULL,NULL),('d8bcef4b-6','Naresh','2017-07-07 12:44:00','2017-07-07 12:44:22',1,NULL,NULL,NULL),('ed25ed7a-6','Naresh','2017-07-07 19:11:09','2017-07-07 19:11:18',1,NULL,NULL,NULL),('f841f24a-6','Naresh','2017-07-11 17:55:08',NULL,0,NULL,NULL,NULL);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
