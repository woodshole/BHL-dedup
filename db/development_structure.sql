CREATE TABLE `books` (
  `id` int(11) NOT NULL auto_increment,
  `oclc` int(11) default NULL,
  `internal_identifier` varchar(255) default NULL,
  `volume` varchar(255) default NULL,
  `chronology` varchar(255) default NULL,
  `call_number` varchar(255) default NULL,
  `author` varchar(255) default NULL,
  `publisher_place` varchar(255) default NULL,
  `publisher` varchar(255) default NULL,
  `title` varchar(255) default NULL,
  `picklist_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_books_on_oclc` (`oclc`),
  KEY `index_books_on_title` (`title`),
  KEY `index_books_on_author` (`author`)
) ENGINE=InnoDB AUTO_INCREMENT=20991 DEFAULT CHARSET=utf8;

CREATE TABLE `institutions` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

CREATE TABLE `picklists` (
  `id` int(11) NOT NULL auto_increment,
  `institution_id` int(11) default NULL,
  `content_type` varchar(255) default NULL,
  `size` int(11) default NULL,
  `filename` varchar(255) default NULL,
  `header_row` int(11) default NULL,
  `header_map` text,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('10');

INSERT INTO schema_migrations (version) VALUES ('11');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('9');