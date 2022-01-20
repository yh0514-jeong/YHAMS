DROP TABLE IF EXISTS `TB_META_ACCOUNT`;

CREATE TABLE `TB_META_ACCOUNT` (
	`ACCOUNT_CD`	VARCHAR(9)	NOT NULL,
	`USER_SEQ`	VARCHAR(10)	NOT NULL,
	`ACCOUNT_NM`	VARCHAR(100)	NULL,
	`ACCOUNT_CTG`	VARCHAR(10)	NULL,
	`ISUE_AGY`	VARCHAR(50)	NULL,
    `ACCOUNT_HRDR`	VARCHAR(100)	NULL,
	`USE_YN`	CHAR(1)	NULL,
	`CREATE_ID`	VARCHAR(30)	NULL,
	`CREATE_DATE`	DATETIME	NULL,
	`UPDATE_ID`	VARCHAR(30)	NULL,
	`UPDATE_DATE`	DATETIME	NULL
);

DROP TABLE IF EXISTS `TB_CMM_CDDTL`;

CREATE TABLE `TB_CMM_CDDTL` (
	`CODE_CD`	VARCHAR(12)	NOT NULL,
	`PAR_CODE_CD`	VARCHAR(12)	DEFAULT NULL,
	`CODE_ID`	VARCHAR(7)	NOT NULL,
	`CODE_NM`	VARCHAR(100)	NULL,
	`USE_YN`	CHAR(1)	NULL,
	`CREATE_ID`	VARCHAR(30)	NULL,
	`CREATE_DATE`	DATETIME	NULL,
	`UPDATE_ID`	VARCHAR(30)	NULL,
	`UPDATE_DATE`	DATETIME	NULL
);

DROP TABLE IF EXISTS `TB_CMM_CD`;

CREATE TABLE `TB_CMM_CD` (
	`CODE_ID`	VARCHAR(7)	NULL,
	`CODE_NM`	VARCHAR(100)	NULL,
	`CODE_DC`	VARCHAR(200)	NULL,
	`USE_YN`	CHAR(1)	NULL	DEFAULT 'Y',
	`CREATE_ID`	VARCHAR(30)	NULL,
	`CREATE_DATE`	DATETIME	NULL,
	`UPDATE_ID`	VARCHAR(30)	NULL,
	`UPDATE_DATE`	DATETIME	NULL
);

DROP TABLE IF EXISTS `TB_META_USER`;

CREATE TABLE `TB_META_USER` (
	`USER_SEQ`	VARCHAR(10)	NOT NULL,
	`USER_ID`	VARCHAR(30)	NULL,
	`USER_PW`	VARCHAR(300)	NULL,
	`USER_NM`	VARCHAR(20)	NULL,
	`USER_NM_EN`	VARCHAR(40)	NULL,
	`USER_EMAIL`	VARCHAR(100)	NULL,
	`USER_ADRS`	VARCHAR(300)	NULL,
	`USER_PHONE`	VARCHAR(100)	NULL,
	`ACT_ST`	CHAR(1)	NULL DEFAULT 'A',
	`CREATE_ID`	VARCHAR(30)	NULL,
	`CREATE_DATE`	DATETIME	NULL,
	`UPDATE_ID`	VARCHAR(30)	NULL,
	`UPDATE_DATE`	DATETIME	NULL
);

DROP TABLE IF EXISTS `TB_META_ROLE`;

CREATE TABLE `TB_META_ROLE` (
	`ROLE_ID`	VARCHAR(8)	NOT NULL,
	`PAR_ROLE_ID`	VARCHAR(8)	NULL,
	`ROLE_NM`	VARCHAR(100)	NULL,
	`ROLE_DC`	VARCHAR(300)	NULL,
             `DEFAULT_YN`	CHAR(1)	NULL DEFAULT 'N',
	`CREATE_ID`	VARCHAR(30)	NULL,
	`CREATE_DATE`	DATETIME	NULL,
	`UPDATE_ID`	VARCHAR(30)	NULL,
	`UPDATE_DATE`	DATETIME	NULL
);

DROP TABLE IF EXISTS `TB_META_USER_ROLE_MAPPING`;

CREATE TABLE `TB_META_USER_ROLE_MAPPING` (
	`USER_SEQ`	VARCHAR(10)	NOT NULL,
	`ROLE_ID`	VARCHAR(8)	NOT NULL,
	`CREATE_ID`	VARCHAR(30)	NULL,
	`CREATE_DATE`	DATETIME	NULL,
	`UPDATE_ID`	VARCHAR(30)	NULL,
	`UPDATE_DATE`	DATETIME	NULL
);

DROP TABLE IF EXISTS `TB_META_MENU`;

CREATE TABLE `TB_META_MENU` (
	`MENU_ID`	VARCHAR(8)	NOT NULL,
	`PAR_MENU_ID`	VARCHAR(8)	NULL,
	`MENU_NM`	VARCHAR(100)	NULL,
	`MENU_NM_EN`	VARCHAR(200)	NULL,
	`MENU_URL`	VARCHAR(300)	NULL,
	`CREATE_ID`	VARCHAR(30)	NULL,
	`CREATE_DATE`	DATETIME	NULL,
	`UPDATE_ID`	VARCHAR(30)	NULL,
	`UPDATE_DATE`	DATETIME	NULL
);

DROP TABLE IF EXISTS `TB_META_MENU_ROLE_MAPPING`;

CREATE TABLE `TB_META_MENU_ROLE_MAPPING` (
	`ROLE_ID`	             VARCHAR(8)	NOT NULL,
	`MENU_ID`	VARCHAR(8)	NOT NULL,
	`CREATE_ID`	VARCHAR(30)	NULL,
	`CREATE_DATE`	DATETIME	NULL,
	`UPDATE_DATE`	DATETIME	NULL,
	`UPDATE_ID`	VARCHAR(30)	NULL
);

DROP TABLE IF EXISTS `TB_TRAN_ACCT_SMR`;

CREATE TABLE `TB_TRAN_ACCT_SMR` (
	`ACT_SEQ`	VARCHAR(36)	NOT NULL,
	`ACCOUNT_CD`	VARCHAR(9)	NOT NULL,
 	'USER_SEQ'          VARCHAR(10)         NOT NULL,
	'ACT_DATE'       DATETIME	NOT NULL,
	`DEPOSIT_TOTAL`	BIGINT	NULL,
	`WITHDRL_TOTAL`	BIGINT	NULL,
	`DESCRIPT`	VARCHAR(250)	NULL,
	`DW_CATE1`	VARCHAR(12)	NULL,
	`DW_CATE2`	VARCHAR(12)	NULL,
	`CREATE_ID`	VARCHAR(30)	NULL,
	`CREATE_DATE`	DATETIME	NULL,
	`UPDATE_ID`	VARCHAR(30)	NULL,
	`UPDATE_DATE`	DATETIME	NULL
);

DROP TABLE IF EXISTS TB_TRAN_YEARLY_ASSET_PLAN;

CREATE TABLE TB_TRAN_YEARLY_ASSET_PLAN (
	ASSET_PLAN_SEQ	VARCHAR(36)	NOT NULL PRIMARY KEY,
	USER_SEQ   VARCHAR(10) NOT NULL,
	STD_YEAR   BIGINT NOT NULL,
	STD_MONTH   BIGINT NOT NULL,
	MAIN_CTG   VARCHAR(10) NOT NULL,
	SUB_CTG    VARCHAR(36) NOT NULL,
	AMOUNT     BIGINT NOT NULL,
	CREATE_ID	VARCHAR(30)	NULL,
	CREATE_DATE	DATETIME	NULL,
	UPDATE_ID	VARCHAR(30)	NULL,
	UPDATE_DATE	DATETIME	NULL
   
);

DROP TABLE IF EXISTS `TB_TRAN_DAILY_EXP_PLAN`;

CREATE TABLE `TB_TRAN_DAILY_EXP_PLAN` (
	`EXP_PLAN_SEQ`	VARCHAR(10)	NOT NULL  PRIMARY KEY,
             `ASSET_PLAN_SEQ` VARCHAR(36)         NOT NULL,
	`USER_SEQ`	VARCHAR(10)	NOT NULL,
	`STD_YEAR_MONTH` VARCHAR(7)	NULL,
	`STD_DATE`	DATETIME	NULL,
	`CTG`	VARCHAR(10)	NULL,
	`MAIN_CTG`	VARCHAR(10)	NULL,
	`SUB_CTG`	VARCHAR(10)	NULL,
	`AMOUNT`            BIGINT                 NOT NULL,
	`CREATE_ID`	VARCHAR(30)	NULL,
	`CREATE_DATE`	DATETIME	NULL,
	`UPDATE_ID`	VARCHAR(30)	NULL,
	`UPDATE_DATE`	DATETIME	NULL
);

ALTER TABLE `TB_TRAN_DAILY_EXP_PLAN` 
ADD CONSTRAINT TB_TRAN_DAILY_EXP_PLAN_ASSET_PLAN_SEQ_FK 
FOREIGN KEY(ASSET_PLAN_SEQ) REFERENCES TB_TRAN_YEARLY_ASSET_PLAN(ASSET_PLAN_SEQ);

DROP TABLE IF EXISTS `TB_TRAN_SALARY`;

CREATE TABLE `TB_TRAN_SALARY` (
	`SAL_SEQ`	VARCHAR(10)	NOT NULL,
	`SAL_DTL_SEQ`	BIGINT	NOT NULL,
	`USER_SEQ`	VARCHAR(10)	NOT NULL,
	`SAL_DATE`	VARCHAR(10)	NOT NULL,
	`AMOUNT`	BIGINT	NOT NULL DEFAULT 0,
	`PAY_DEDUC`	VARCHAR(12)	NOT NULL,
	`PAY_DEDUC_DTL`	VARCHAR(12)	NOT NULL,
	`CREATE_ID`	VARCHAR(30)	NULL,
	`CREATE_DATE`	DATETIME	NULL,
	`UPDATE_ID`	VARCHAR(30)	NULL,
	`UPDATE_DATE`	DATETIME	NULL
);

DROP TABLE IF EXISTS `TB_TRAN_UNEARNED`;

CREATE TABLE `TB_TRAN_UNEARNED` (
	`UED_SEQ`	VARCHAR(10)	NOT NULL,
	`USER_SEQ`	VARCHAR(10)	NOT NULL,
	`UED_DATE`	DATETIME	NULL,
	`UED_INCM`	BIGINT	NULL,
	`UED_SOURCE`	VARCHAR(100)	NULL,
             'UED_CTG'            VARCHAR(100)	NULL,
	`CREATE_ID`	VARCHAR(30)	NULL,
	`CREATE_DATE`	DATETIME	NULL,
	`UPDATE_ID`	VARCHAR(30)	NULL,
	`UPDATE_DATE`	DATETIME	NULL
);


CREATE TABLE `TB_LOG_USER_ACT` (
	`ACT_LOG_SEQ`	BIGINT	NOT NULL,
	`USER_SEQ`	VARCHAR(10)	NULL,
	`MENU_URL`	VARCHAR(300)	NULL,
	`CREATE_DATE`	DATETIME	NULL,
	`IP_ADDR`	VARCHAR(300)	NULL
);

	
CREATE TABLE TB_META_USER_DEF_ICMEXP_CATEGORY (

USER_DEF_SEQ VARCHAR(36) PRIMARY KEY,
USER_SEQ VARCHAR(10) NOT NULL,
MAIN_CTG VARCHAR(12) NOT NULL,
SUB_CTG_NM VARCHAR(50) NOT NULL,
CODE_ORDR BIGINT NOT NULL,
USE_YN CHAR(1) NOT NULL DEFAULT 'Y',
CREATE_ID VARCHAR(30),
CREATE_DATE DATETIME,
UPDATE_ID VARCHAR(30),
UPDATE_DATE DATETIME

);

ALTER TABLE `TB_META_ACCOUNT` ADD CONSTRAINT `PK_TB_META_ACCOUNT` PRIMARY KEY (
	`ACCOUNT_CD`
);

ALTER TABLE `TB_CMM_CDDTL` ADD CONSTRAINT `PK_TB_CMM_CDDTL` PRIMARY KEY (
	`CODE_CD`,
	`CODE_ID`
);

ALTER TABLE `TB_CMM_CD` ADD CONSTRAINT `PK_TB_CMM_CD` PRIMARY KEY (
	`CODE_ID`
);

ALTER TABLE `TB_META_USER` ADD CONSTRAINT `PK_TB_META_USER` PRIMARY KEY (
	`USER_SEQ`
);

ALTER TABLE `TB_META_ROLE` ADD CONSTRAINT `PK_TB_META_ROLE` PRIMARY KEY (
	`ROLE_ID`
);

ALTER TABLE `TB_META_USER_ROLE_MAPPING` ADD CONSTRAINT `PK_TB_META_USER_ROLE_MAPPING` PRIMARY KEY (
	`USER_SEQ`,
	`ROLE_ID`
);

ALTER TABLE `TB_META_MENU` ADD CONSTRAINT `PK_TB_META_MENU` PRIMARY KEY (
	`MENU_ID`
);

ALTER TABLE `TB_META_MENU_ROLE_MAPPING` ADD CONSTRAINT `PK_TB_META_MENU_ROLE_MAPPING` PRIMARY KEY (
	`ROLE_ID2`,
	`MENU_ID`
);

ALTER TABLE `TB_TRAN_ACCT_SMR` ADD CONSTRAINT `PK_TB_TRAN_ACCT_SMR` PRIMARY KEY (
	`ACT_SEQ`
);

ALTER TABLE `TB_TRAN_EXP_PLAN` ADD CONSTRAINT `PK_TB_TRAN_EXP_PLAN` PRIMARY KEY (
	`EXP_PLAN_SEQ`
);

ALTER TABLE `TB_TRAN_SALARY` ADD CONSTRAINT `PK_TB_TRAN_SALARY` PRIMARY KEY (
	`SAL_SEQ`,
	`SAL_DTL_SEQ`
);

ALTER TABLE `TB_TRAN_UNEARNED` ADD CONSTRAINT `PK_TB_TRAN_UNEARNED` PRIMARY KEY (
	`UED_SEQ`,
	`USER_SEQ`
);

