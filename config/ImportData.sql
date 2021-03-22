use Manifestation;
-- data for address table
INSERT INTO address (state, city, street, number) VALUES ('Serbia', 'Kragujevac', 'Kralja Milana', '21');
INSERT INTO address (state, city, street, number) VALUES ('Serbia', 'Kragujevac', 'Grada Sirena', '15');
INSERT INTO address (state, city, street, number) VALUES ('Serbia', 'Beograd', 'Bulevar Arsenija Carnojevica', '58');
INSERT INTO address (state, city, street, number) VALUES ('Serbia', 'Beograd', 'Carlija Caplina', 'bb');
INSERT INTO address (state, city, street, number) VALUES ('Serbia', 'Beograd', 'Ljutice Bogdana', '1a');
INSERT INTO address (state, city, street, number) VALUES ('Serbia', 'Novi Sad', 'Sutjeska', '2');
INSERT INTO address (state, city, street, number) VALUES ('Serbia', 'Novi Sad', 'Dimitrija Tucovica', '1');
INSERT INTO address (state, city, street, number) VALUES ('Serbia', 'Novi Sad', 'Pozorisni trg', '1');

-- data for location table
INSERT INTO location (name, address) VALUES ('Stadion Cika Daca', 1);
INSERT INTO location (name, address) VALUES ('Hala Jezero', 2);
INSERT INTO location (name, address) VALUES ('Stark Arena', 3);
INSERT INTO location (name, address) VALUES ('Hala Pionir', 4);
INSERT INTO location (name, address) VALUES ('Stadion Rajko Mitic', 5);
INSERT INTO location (name, address) VALUES ('TC Spens', 6);
INSERT INTO location (name, address) VALUES ('Stadion Karadjordje', 7);
INSERT INTO location (name, address) VALUES ('Srpsko narodno pozoriste', 8);


-- data for manifestation table
INSERT INTO manifestation (name, description, category, start_date_time, location) 
VALUES ('Football game Radnicki-Sloboda', 'Football match between the team from Kragujevac and the team from Uzice. Come and support your team.', 'Sport', '2021-04-25 15:00:00', 1);
INSERT INTO manifestation (name, description, category, start_date_time, location) 
VALUES ('Smak concert', 'Concert of the rock group Smak in Kragujevac. Come and enjoy their greatest hits.', 'Concert', '2021-04-05 18:00:00', 2);
INSERT INTO manifestation (name, description, category, start_date_time, location) 
VALUES ('Concert Andre Rieu', 'André Léon Marie Nicolas Rieu is a Dutch violinist and conductor best known for creating the waltz-playing Johann Strauss Orchestra. He and his orchestra have turned classical and waltz music into a worldwide concert touring act, as successful as some of the biggest global pop and rock music acts.', 'Concert', '2021-04-20 19:30:00', 3);
INSERT INTO manifestation (name, description, category, start_date_time, location) 
VALUES ('Basketball game KK Crvena Zvezda-KK Real Madrid', 'Basketball match between Red Star and Real Madrid. It is the 4th round of the Euro League. Come and support your team.', 'Sport', '2021-04-02 20:00:00', 4);
INSERT INTO manifestation (name, description, category, start_date_time, location) 
VALUES ('UEFA Euro Qualifying Serbia-Ukraine', 'Football match between the team of Serbia and Ukraine for the qualification for the European Championship. Lets support our national team to qualify for the Euro.', 'Sport', '2021-04-14 16:00:00', 5);
INSERT INTO manifestation (name, description, category, start_date_time, location) 
VALUES ('Table tennis tournament', 'Serbian table tennis tournament. Teams from all over Serbia will compete for one of the medals.', 'Sport', '2021-05-05 15:00:00', 6);
INSERT INTO manifestation (name, description, category, start_date_time, location) 
VALUES ('Football game FK Vojvodina-FK Rad', 'Football match between the team from Novi Sad and the team from Belgrade. A fight between two teams that are in great shape.', 'Sport', '2021-04-28 15:00:00', 7);
INSERT INTO manifestation (name, description, category, start_date_time, location) 
VALUES ('Ballet Madama Butterfly', 'Although Madame Butterfly is known as an opera by Giacomo Puccini that never ceases to enchant opera lovers, as a ballet - it is a new work in terms of genre and is created in joint cooperation of five countries: Austria, Germany, Japan, Sweden and Serbia.', 'Theater', '2021-05-12 17:30:00', 8);


-- data for comments
INSERT INTO man_comment (text, created, writer, man_id) 
VALUES ('I cant wait, Ill definitely come, my friends told me its great music.', '2021-03-30 17:30:00', 1, 2);
INSERT INTO man_comment (text, created, writer, man_id) 
VALUES ('Great band! I adore their songs.', '2021-03-23 11:13:20', 2, 2);
INSERT INTO man_comment (text, created, writer, man_id) 
VALUES ('This is going to be a very difficult match.', '2021-03-28 21:33:31', 1, 4);