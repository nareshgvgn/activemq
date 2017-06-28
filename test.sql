/*
SQLyog Ultimate v8.55 
MySQL - 5.1.39-community : Database - seleniumkeyword
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`seleniumkeyword` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `seleniumkeyword`;

/*Table structure for table `keyword_mst` */

DROP TABLE IF EXISTS `keyword_mst`;

CREATE TABLE `keyword_mst` (
  `keyword` varchar(45) DEFAULT NULL,
  `javacode` blob,
  `class_name` varchar(90) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `keyword_mst` */

insert  into `keyword_mst`(`keyword`,`javacode`,`class_name`) values ('CLICK_BTN','import org.openqa.selenium.WebDriver;\r\npublic class BtnClickHandler {\r\n	public static void test(WebDriver driver)\r\n	{\r\n		driver.navigate().to(\"http://google.com\");\r\n		String appTitle = driver.getTitle();\r\n		System.out.println(\"Application title is :: \"+appTitle);\r\n		driver.quit();\r\n		\r\n	}\r\n}\r\n','BtnClickHandler');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
