use Manifestation;
-- data for address table
INSERT INTO address (state, city, street, number) VALUES ('Serbia', 'Kg', 'Kralja Milana', '21');
INSERT INTO address (state, city, street, number) VALUES ('Serbia', 'Kg', 'Grada Sirena', '15');
INSERT INTO address (state, city, street, number) VALUES ('Serbia', 'Bg', 'Bulevar Arsenija Carnojevica', '58');
INSERT INTO address (state, city, street, number) VALUES ('Serbia', 'Bg', 'Carlija Caplina', 'bb');
INSERT INTO address (state, city, street, number) VALUES ('Serbia', 'Bg', 'Ljutice Bogdana', '1a');
INSERT INTO address (state, city, street, number) VALUES ('Serbia', 'NS', 'Sutjeska', '2');
INSERT INTO address (state, city, street, number) VALUES ('Serbia', 'NS', 'Dimitrija Tucovica', '1');

-- data for location table
INSERT INTO location (name, address) VALUES ('Stadion Cika Daca', 1);
INSERT INTO location (name, address) VALUES ('Hala Jezero', 2);
INSERT INTO location (name, address) VALUES ('Stark Arena', 3);
INSERT INTO location (name, address) VALUES ('Hala Pionir', 4);
INSERT INTO location (name, address) VALUES ('Stadion Rajko Mitic', 5);
INSERT INTO location (name, address) VALUES ('TC Spens', 6);
INSERT INTO location (name, address) VALUES ('Stadion Karadjordje', 7);

-- data for manifestation table
INSERT INTO manifestation (name, description, start_date_time, location) 
VALUES ('Utakmica Radicki-Sloboda', 'Fudbalska utakmica izmedju ekipe iz Kragujevca i ekipe iz Uzica.', '2021-02-25 15:00:00', 1);
INSERT INTO manifestation (name, description, start_date_time, location) 
VALUES ('Koncert Smaka', 'Koncert grupe Smak.', '2021-03-05 18:00:00', 2);
INSERT INTO manifestation (name, description, start_date_time, location) 
VALUES ('Koncert Andre Rieu', 'Koncert klasicne muzike.', '2021-03-20 19:30:00', 3);
INSERT INTO manifestation (name, description, start_date_time, location) 
VALUES ('Utakmica Zvezda-Real', 'Kosarkaska utakmica izmedju ekipe iz KK Crvena Zvezda i ekipe Real Madrida.', '2021-04-02 20:00:00', 4);
INSERT INTO manifestation (name, description, start_date_time, location) 
VALUES ('Utakmica kvalifikacija Srbija', 'Fudbalska utakmica izmedju ekipe Srbije i Ukrajine za kvalifikacija za evropsko prvenstvo.', '2021-04-14 16:00:00', 5);
INSERT INTO manifestation (name, description, start_date_time, location) 
VALUES ('Turnir u stonom tenisu', 'Turnir Srbije u stonom tenisu.', '2021-05-05 15:00:00', 6);
INSERT INTO manifestation (name, description, start_date_time, location) 
VALUES ('Utakmica Vojvodina-Rad', 'Fudbalska utakmica izmedju ekipe iz Novog Sada i ekipe iz Beograda.', '2021-03-28 15:00:00', 7);