-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema db_sales
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema db_sales
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `db_sales` DEFAULT CHARACTER SET utf8 ;
USE `db_sales` ;

-- -----------------------------------------------------
-- Table `db_sales`.`Company`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_sales`.`Company` (
  `id_company` INT NOT NULL AUTO_INCREMENT,
  `serial_identification` VARCHAR(45) NULL,
  `name` VARCHAR(255) NULL,
  `adress` VARCHAR(400) NULL,
  `sector` VARCHAR(45) NULL,
  PRIMARY KEY (`id_company`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_sales`.`TypePerson`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_sales`.`TypePerson` (
  `id_type_person` INT NOT NULL AUTO_INCREMENT,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`id_type_person`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_sales`.`Person`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_sales`.`Person` (
  `id_person` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NULL,
  `email` VARCHAR(45) NULL,
  `Company_id_company` INT NOT NULL,
  `TypePerson_id_type_person` INT NOT NULL,
  PRIMARY KEY (`id_person`),
  INDEX `fk_Person_Company1_idx` (`Company_id_company` ASC) VISIBLE,
  INDEX `fk_Person_TypePerson1_idx` (`TypePerson_id_type_person` ASC) VISIBLE,
  CONSTRAINT `fk_Person_Company1`
    FOREIGN KEY (`Company_id_company`)
    REFERENCES `db_sales`.`Company` (`id_company`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Person_TypePerson1`
    FOREIGN KEY (`TypePerson_id_type_person`)
    REFERENCES `db_sales`.`TypePerson` (`id_type_person`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_sales`.`Supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_sales`.`Supplier` (
  `Person_id_person` INT NOT NULL,
  `status` VARCHAR(45) NULL,
  `num_orders` INT NULL,
  `acc_all_orders` DECIMAL(12,2) NULL,
  INDEX `fk_Supplier_Person_idx` (`Person_id_person` ASC) VISIBLE,
  PRIMARY KEY (`Person_id_person`),
  CONSTRAINT `fk_Supplier_Person`
    FOREIGN KEY (`Person_id_person`)
    REFERENCES `db_sales`.`Person` (`id_person`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_sales`.`Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_sales`.`Order` (
  `id_order` VARCHAR(8) NOT NULL,
  `date_generated` DATETIME NULL,
  `total` DECIMAL(12,2) NULL,
  `Supplier_Person_id_person` INT NOT NULL,
  PRIMARY KEY (`id_order`),
  INDEX `fk_Order_Supplier1_idx` (`Supplier_Person_id_person` ASC) VISIBLE,
  CONSTRAINT `fk_Order_Supplier1`
    FOREIGN KEY (`Supplier_Person_id_person`)
    REFERENCES `db_sales`.`Supplier` (`Person_id_person`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_sales`.`Category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_sales`.`Category` (
  `id_category` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NULL,
  PRIMARY KEY (`id_category`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_sales`.`Brand`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_sales`.`Brand` (
  `id_brand` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NULL,
  `date_creation` DATETIME NULL,
  PRIMARY KEY (`id_brand`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_sales`.`Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_sales`.`Product` (
  `id_product` INT NOT NULL AUTO_INCREMENT,
  `bar_code` CHAR(12) NULL,
  `name` VARCHAR(255) NULL,
  `description` TEXT(400) NULL,
  `unit_price` DECIMAL(8,2) NULL,
  `Category_id_category` INT NOT NULL,
  `Brand_id_brand` INT NOT NULL,
  PRIMARY KEY (`id_product`),
  UNIQUE INDEX `id_product_UNIQUE` (`id_product` ASC) VISIBLE,
  UNIQUE INDEX `bar_code_UNIQUE` (`bar_code` ASC) VISIBLE,
  INDEX `fk_Product_Category1_idx` (`Category_id_category` ASC) VISIBLE,
  INDEX `fk_Product_Brand1_idx` (`Brand_id_brand` ASC) VISIBLE,
  CONSTRAINT `fk_Product_Category1`
    FOREIGN KEY (`Category_id_category`)
    REFERENCES `db_sales`.`Category` (`id_category`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Product_Brand1`
    FOREIGN KEY (`Brand_id_brand`)
    REFERENCES `db_sales`.`Brand` (`id_brand`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_sales`.`OrderDetail`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_sales`.`OrderDetail` (
  `Order_id_order` VARCHAR(8) NOT NULL,
  `Product_id_product` INT NOT NULL,
  `quantity` INT NULL,
  `subtotal` DECIMAL(9,2) NULL,
  PRIMARY KEY (`Order_id_order`, `Product_id_product`),
  INDEX `fk_OrderDetail_Product1_idx` (`Product_id_product` ASC) VISIBLE,
  CONSTRAINT `fk_OrderDetail_Order1`
    FOREIGN KEY (`Order_id_order`)
    REFERENCES `db_sales`.`Order` (`id_order`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_OrderDetail_Product1`
    FOREIGN KEY (`Product_id_product`)
    REFERENCES `db_sales`.`Product` (`id_product`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
