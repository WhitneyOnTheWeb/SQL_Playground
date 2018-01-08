USE [master]
GO

/****** Object:  Database [MarvelCharApps]    Script Date: 6/11/2015 11:38:43 AM ******/
CREATE DATABASE [MarvelCharApps]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MarvelCharApps', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.SQUIRTLE\MSSQL\DATA\MarvelCharApps.mdf' , SIZE = 7360KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'MarvelCharApps_log', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL12.SQUIRTLE\MSSQL\DATA\MarvelCharApps_log.ldf' , SIZE = 1856KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [MarvelCharApps] SET COMPATIBILITY_LEVEL = 120
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MarvelCharApps].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [MarvelCharApps] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [MarvelCharApps] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [MarvelCharApps] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [MarvelCharApps] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [MarvelCharApps] SET ARITHABORT OFF 
GO

ALTER DATABASE [MarvelCharApps] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [MarvelCharApps] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [MarvelCharApps] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [MarvelCharApps] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [MarvelCharApps] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [MarvelCharApps] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [MarvelCharApps] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [MarvelCharApps] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [MarvelCharApps] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [MarvelCharApps] SET  ENABLE_BROKER 
GO

ALTER DATABASE [MarvelCharApps] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [MarvelCharApps] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [MarvelCharApps] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [MarvelCharApps] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [MarvelCharApps] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [MarvelCharApps] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [MarvelCharApps] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [MarvelCharApps] SET RECOVERY FULL 
GO

ALTER DATABASE [MarvelCharApps] SET  MULTI_USER 
GO

ALTER DATABASE [MarvelCharApps] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [MarvelCharApps] SET DB_CHAINING OFF 
GO

ALTER DATABASE [MarvelCharApps] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO

ALTER DATABASE [MarvelCharApps] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO

ALTER DATABASE [MarvelCharApps] SET DELAYED_DURABILITY = DISABLED 
GO

ALTER DATABASE [MarvelCharApps] SET  READ_WRITE 
GO


