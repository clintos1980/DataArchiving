USE [master]
GO

--set the directories and file sizes per your needs
CREATE DATABASE [ArchiveDBName] ON  PRIMARY 
( NAME = N'ArchiveDBName', FILENAME = N'X:\ArchiveDBName.mdf' , SIZE = 104857600KB , MAXSIZE = UNLIMITED, FILEGROWTH = 2097152KB )
 LOG ON 
( NAME = N'ArchiveDBName_log', FILENAME = N'X:\ArchiveDBName_log.ldf' , SIZE = 6291456KB , MAXSIZE = 2048GB , FILEGROWTH = 1048576KB )
GO
