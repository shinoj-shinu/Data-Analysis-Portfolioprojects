*Covid Data Exploration

This project is all about to analsysis the Total deaths and total vacinated details all over the world.

Application used -MY SQL Workbench

Skills used -Basic sql queris, Joins,Agreegate Functions,CTE's, Temp Tables, Windows Functions,Creating Views, Converting Data Types

Basic SQL queris

--Created Database as 'MYPORTFOLIOPROJECT'

CREATE DATABASE MYPORTFOLIOPROJECT;

SHOW DATABASES;

USE MYPORTFOLIOPROJECT;

*Downloaded Data files from https://ourworldindata.org/ and Data's Imported in to MYSQL

SELECT * FROM
MYPORTFOLIOPROJECT.CovidDeaths;

SELECT * FROM
MYPORTFOLIOPROJECT.CovidDeaths
ORDER BY 3,4;

*Covid Vacination details

SELECT * FROM
MYPORTFOLIOPROJECT.Covidvaccinations
ORDER BY 3,4;

*Findout sepecific details

SELECT Location, Date ,total_cases, new_cases, total_deaths, population
FROM MYPORTFOLIOPROJECT.CovidDeaths
ORDER BY 1,2;












