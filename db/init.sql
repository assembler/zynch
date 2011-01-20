-- phpMyAdmin SQL Dump
-- version 3.1.3.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jan 20, 2011 at 02:00 PM
-- Server version: 5.0.41
-- PHP Version: 5.2.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `zynch_development`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `name` varchar(255) default NULL,
  `domain` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_accounts_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE IF NOT EXISTS `countries` (
  `id` char(2) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pages`
--

CREATE TABLE IF NOT EXISTS `pages` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL,
  `host` varchar(255) default NULL,
  `title` varchar(255) default NULL,
  `path` text,
  `search` text,
  `charset` varchar(45) default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_pages_accounts1` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=51 ;

-- --------------------------------------------------------

--
-- Table structure for table `pageviews`
--

CREATE TABLE IF NOT EXISTS `pageviews` (
  `id` int(11) NOT NULL auto_increment,
  `visit_id` int(11) NOT NULL,
  `page_id` int(11) NOT NULL,
  `created_at` timestamp NULL default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_pageviews_pages1` (`page_id`),
  KEY `fk_pageviews_visits1` (`visit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=3714 ;

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) NOT NULL default '',
  `encrypted_password` varchar(128) NOT NULL default '',
  `password_salt` varchar(255) NOT NULL default '',
  `reset_password_token` varchar(255) default NULL,
  `remember_token` varchar(255) default NULL,
  `remember_created_at` datetime default NULL,
  `sign_in_count` int(11) default '0',
  `current_sign_in_at` datetime default NULL,
  `last_sign_in_at` datetime default NULL,
  `current_sign_in_ip` varchar(255) default NULL,
  `last_sign_in_ip` varchar(255) default NULL,
  `confirmation_token` varchar(255) default NULL,
  `confirmed_at` datetime default NULL,
  `confirmation_sent_at` datetime default NULL,
  `failed_attempts` int(11) default '0',
  `locked_at` datetime default NULL,
  `authentication_token` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_users_on_confirmation_token` (`confirmation_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Table structure for table `visits`
--

CREATE TABLE IF NOT EXISTS `visits` (
  `id` int(11) NOT NULL auto_increment,
  `account_id` int(11) NOT NULL,
  `country_id` char(2) default NULL,
  `entry_page_id` int(11) default NULL,
  `exit_page_id` int(11) default NULL,
  `ip_address` char(15) default NULL,
  `pageviews_count` int(10) unsigned NOT NULL default '0',
  `screen_width` int(11) default NULL,
  `screen_height` int(11) default NULL,
  `screen_resolution` varchar(10) default NULL,
  `color_depth` int(11) default NULL,
  `flash_version` varchar(45) default NULL,
  `major_flash_version` int(11) default NULL,
  `language` varchar(45) default NULL,
  `java_enabled` tinyint(1) default NULL,
  `browser` varchar(45) default NULL,
  `browser_version` varchar(45) default NULL,
  `os` varchar(45) default NULL,
  `created_at` timestamp NULL default NULL,
  `updated_at` timestamp NULL default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_visits_accounts1` (`account_id`),
  KEY `fk_visits_countries1` (`country_id`),
  KEY `fk_visits_pages1` (`entry_page_id`),
  KEY `fk_visits_pages2` (`exit_page_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=778 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `fk_accounts_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `pages`
--
ALTER TABLE `pages`
  ADD CONSTRAINT `fk_pages_accounts1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pageviews`
--
ALTER TABLE `pageviews`
  ADD CONSTRAINT `fk_pageviews_pages1` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pageviews_visits1` FOREIGN KEY (`visit_id`) REFERENCES `visits` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `visits`
--
ALTER TABLE `visits`
  ADD CONSTRAINT `fk_visits_pages1` FOREIGN KEY (`entry_page_id`) REFERENCES `pages` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_visits_pages2` FOREIGN KEY (`exit_page_id`) REFERENCES `pages` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_visits_accounts1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_visits_countries1` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
