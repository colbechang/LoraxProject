create database climatechange_db;
create user 'webapp'@'%' identified by 'abc123';
grant select on climatechange_db.* to 'webapp'@'%';
flush privileges;

use climatechange_db;

create table continents(
    continentID int auto_increment not null,
    name text not null,
    primary key(continentID)
);

create table countries(
    countryID int auto_increment not null,
    name text not null,
    GDP text not null,
    air_quality float not null,
    population int not null,
    sea_level float not null,
    continentID int,
    primary key(countryID),
    constraint continent_fk foreign key (continentID)
                      references continents(continentID)
                      on update cascade on delete restrict
);


create table industry(
    industryID int auto_increment not null,
    name text not null,
    annual_emissions float not null,
    annual_revenue text not null,
    countryID int,
    primary key(industryID),
    constraint country_fk foreign key (countryID)
                     references countries(countryID)
                     on update cascade on delete restrict

);

create table climate_change_trends(
    trend_year year not null,
    temperature float not null,
    air_quality float not null,
    sea_level float not null,
    primary key(trend_year)
);


create table cities(
    cityID int auto_increment not null,
    GDP text not null,
    name varchar(50) not null,
    population float not null,
    sea_level float not null,
    countryID int,
    trend_year year,
    primary key(cityID),
    constraint country_fk2 foreign key (countryID)
                   references countries(countryID)
                   on update cascade on delete restrict,
    constraint trend_year_fk foreign key (trend_year)
                   references climate_change_trends(trend_year)
                   on update cascade on delete restrict
);


create table people(
    age int not null,
    peopleID int auto_increment not null,
    income text,
    gender varchar(40) not null,
    race text not null,
    annual_emissions float not null,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    email text,
    phone text,
    fax text,
    street text not null,
    postal_code varchar(30),
    industryID int,
    cityID int,
    countryID int,
    primary key(peopleID),
    constraint industry_fk foreign key (industryID)
                   references industry(industryID)
                   on update cascade on delete restrict,
    constraint city_fk foreign key (cityID)
                   references cities(cityID)
                   on update cascade on delete restrict,
    constraint country_fk0 foreign key(countryID)
                   references countries(countryID)
                   on update cascade on delete restrict
);


create table appendix(
    acronym varchar(10) not null,
    definition text not null,
    phrase varchar(100) not null,
    further_reading text not null,
    primary key(acronym, phrase)
);

create table energy(
    cost_per_watt float not null,
    name varchar(20),
    energyID int auto_increment not null,
    primary key(energyID)
);

create table resource(
    resourceID int auto_increment not null,
    resource_name varchar(30) not null,
    energyID int,
    primary key(resourceID),
    constraint energy_fk foreign key (energyID)
                     references energy(energyID)
                     on update cascade on delete restrict
    );

create table radiative_forcing(
    rf_cityID int auto_increment not null,
    co2 float not null,
    other_GHG float not null,
    ozone float not null,
    ARI float not null,
    surface_albedo float not null,
    contrails float not null,
    SWCH4 float not null,
    solar_irradiance float not null,
    trend_year year,
    primary key(rf_cityID),
    constraint trend_year_fk2 foreign key (trend_year)
                              references climate_change_trends(trend_year)
                              on update cascade on delete restrict
);

create table adaptation_techniques(
    adaptationID int auto_increment not null,
    name varchar(30) not null,
    est_lives_saved_per_dollar int not null,
    est_dollars_saved_per_dollar float not null,
    primary key(adaptationID)
);

create table mitigation_techniques(
    mitigationID int auto_increment not null,
    mitigation_type varchar(30) not null,
    WPM_RFMPD float not null,
    primary key(mitigationID)

);

create table city_mitigation_techs(
    mitigationID int,
    cityID int,
    foreign key (mitigationID) references mitigation_techniques(mitigationID),
    foreign key (cityID) references cities(cityID)
);

create table city_energy(
    energyID int,
    cityID int,
    foreign key (energyID) references energy(energyID),
    foreign key (cityID) references cities(cityID)
);

create table city_adapt(
    adaptationID int,
    cityID int,
    constraint adapt_fk foreign key (adaptationID)
                       references adaptation_techniques(adaptationID)
                       on update cascade on delete restrict,
    constraint city_fk4 foreign key (cityID)
                       references cities(cityID)
                       on update cascade on delete restrict
);




insert into appendix
    (acronym, definition, phrase, further_reading)
values
    ('WPM_RFMPD', 'W/m^2 of Radiative Forcing Mitigated per Dollar', 'W/m^2 of Radiative Forcing Mitigated per Dollar', 'https://climate.mit.edu/explainers/radiative-forcing#:~:text=Radiative%20forcing%20is%20what%20happens,infrared%20radiation%20exiting%20as%20heat.'),
    ('SWCH4', 'Stratospheric Water from CH4', 'Stratospheric Water from CH4', 'https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2006GL027472'),
    ('ARI', 'Aerosol–radiation interactions stem from direct scattering and absorption of solar and terrestrial radiation by aerosols, thereby changing the planetary albedo. ', 'Aersol-Radiation Interaction', 'https://acp.copernicus.org/articles/21/1049/2021/#:~:text=Aerosol%E2%80%93radiation%20interactions%20stem%20from,or%20ice%20nuclei%20in%20clouds.');

insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (1, 'Karmen', 'Phear', 'kphear0@hp.com', 'Female', 66, '$121785.86', 1744.33, '719-244-8546', '493-174-7289', '4 Burrows Center', '11506', 'Thai');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (2, 'Martin', 'Rosbotham', 'mrosbotham1@army.mil', 'Male', 19, '$903151.17', 4391.81, '755-631-3071', '100-840-8518', '91 Drewry Street', null, 'Cherokee');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (3, 'Bastien', 'Tattam', 'btattam2@prweb.com', 'Male', 64, '$329998.81', 6877.72, '813-576-8518', '937-952-2246', '23 Lillian Center', null, 'Yakama');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (4, 'Cliff', 'Maddicks', 'cmaddicks3@webeden.co.uk', 'Male', 75, '$948296.33', 4152.66, '957-541-1908', '408-980-1522', '2624 Bayside Place', null, 'Hmong');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (5, 'Rodney', 'Village', 'rvillage4@comcast.net', 'Male', 79, '$524282.41', 9231.92, '352-513-9470', '221-588-8032', '49 Melrose Place', null, 'Crow');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (6, 'Lavinie', 'Fealy', 'lfealy5@fastcompany.com', 'Female', 36, '$634030.97', 3061.82, '998-915-6227', '682-248-4022', '5 Atwood Point', '4113', 'Chickasaw');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (7, 'Gustave', 'Dottridge', 'gdottridge6@google.ca', 'Male', 70, '$68272.76', 9505.11, '483-227-4505', '384-339-5102', '6 Montana Junction', '9400', 'Chamorro');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (8, 'Archie', 'Cotte', 'acotte7@opensource.org', 'Male', 19, '$473786.15', 8308.84, '783-202-8747', '832-256-5669', '83 Anzinger Alley', '75464 CEDEX 10', 'Cherokee');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (9, 'Maureen', 'Worsham', 'mworsham8@nhs.uk', 'Female', 39, '$262151.27', 8787.02, '634-971-2842', '338-245-2474', '19537 Arizona Avenue', '05-816', 'Seminole');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (10, 'Allsun', 'Dmitriev', 'admitriev9@cpanel.net', 'Female', 63, '$641045.77', 1503.9, '680-823-3826', '287-663-1442', '00 Green Ridge Road', null, 'Argentinian');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (11, 'Ruthi', 'Appleyard', 'rappleyarda@narod.ru', 'Female', 35, '$392557.62', 4576.24, '213-649-6579', '850-851-5174', '0 Debs Lane', '735517', 'Kiowa');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (12, 'Brooke', 'Plewman', 'bplewmanb@mapy.cz', 'Agender', 53, '$960692.38', 9821.73, '972-256-7583', '427-647-5435', '7616 Schlimgen Pass', null, 'Blackfeet');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (13, 'Jilly', 'Fiske', 'jfiskec@gnu.org', 'Female', 66, '$329019.69', 4205.54, '248-412-6269', '237-196-9977', '4869 Saint Paul Avenue', '96450-000', 'Uruguayan');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (14, 'Rooney', 'Klemke', 'rklemked@redcross.org', 'Male', 55, '$784992.18', 1603.1, '968-378-9530', '586-348-6017', '62 Pierstorff Way', null, 'Micronesian');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (15, 'Nate', 'Frier', 'nfriere@cdc.gov', 'Male', 94, '$17011.06', 6954.12, '126-794-7909', '101-820-0654', '17 Dennis Junction', '4905-074', 'Ecuadorian');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (16, 'Morna', 'Leggatt', 'mleggattf@huffingtonpost.com', 'Female', 41, '$634026.21', 6607.13, '735-998-3022', '206-828-5317', '36 American Ash Place', null, 'Black or African American');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (17, 'Cybil', 'Brosius', 'cbrosiusg@dailymotion.com', 'Female', 17, '$356081.20', 1273.65, '420-858-7643', '335-419-4023', '6 Hanson Crossing', '396340', 'American Indian and Alaska Native (AIAN)');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (18, 'Karoline', 'Tame', 'ktameh@ihg.com', 'Female', 14, '$875525.67', 8544.15, '959-311-1913', '143-100-4257', '3210 Memorial Lane', null, 'Guatemalan');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (19, 'Bonnee', 'Francklin', 'bfrancklini@jimdo.com', 'Female', 42, '$534663.79', 6835.28, '961-462-9013', '605-980-7837', '12459 Summit Place', null, 'Choctaw');
insert into people (peopleID, first_name, last_name, email, gender, age, income, annual_emissions, phone, fax, street, postal_code, race) values (20, 'Gavin', 'Daveran', 'gdaveranj@simplemachines.org', 'Male', 65, '$295092.02', 6160.5, '870-138-6979', '320-682-3230', '961 Del Mar Road', null, 'Lumbee');

insert into industry (industryID, name, annual_emissions, annual_revenue) values (1, 'Schulist and Sons', 63045.55, '$93593791.09');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (2, 'Koepp-Kertzmann', 99059.36, '$50007121.54');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (3, 'Nolan, Lueilwitz and Heidenreich', 37713.91, '$82301392.61');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (4, 'Fadel Inc', 48498.82, '$66965750.70');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (5, 'Farrell LLC', 92671.28, '$25082399.88');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (6, 'Wilkinson-Heidenreich', 17145.44, '$50775063.65');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (7, 'Marks Inc', 42852.67, '$74150235.44');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (8, 'Sanford-Stroman', 92333.54, '$59023214.51');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (9, 'Huel, Jast and Hansen', 65111.98, '$88567028.46');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (10, 'Funk, Herman and Homenick', 89501.55, '$10685414.24');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (11, 'Runolfsson, Ratke and Howell', 22400.63, '$47919948.33');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (12, 'Parisian-Bernhard', 15410.37, '$26408859.72');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (13, 'Larson-Kutch', 80592.42, '$25597834.35');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (14, 'Carter, Kiehn and Kiehn', 62442.49, '$50449618.00');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (15, 'Osinski Group', 89731.84, '$29838388.28');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (16, 'Bogan-Schuppe', 64725.3, '$62045269.45');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (17, 'Harris-Johns', 25009.87, '$19687916.40');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (18, 'Lynch-Quigley', 53388.06, '$33512617.87');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (19, 'Rau, Bogan and King', 39609.76, '$36108523.05');
insert into industry (industryID, name, annual_emissions, annual_revenue) values (20, 'Osinski-O''Reilly', 38766.75, '$94458848.13');


insert into cities (cityID, name, population, sea_level, GDP) values (1, 'Las Vegas', 1127800, 368.7, 39.53);
insert into cities (cityID, name, population, sea_level, GDP) values (2, 'Meixian', 1355112, 334.1, 18.98);
insert into cities (cityID, name, population, sea_level, GDP) values (3, 'Mora', 8876076, 445.1, 30.04);
insert into cities (cityID, name, population, sea_level, GDP) values (4, 'Tondano', 9154413, 786.1, 41.89);
insert into cities (cityID, name, population, sea_level, GDP) values (5, 'Carregado', 4976609, 40.0, 40.39);
insert into cities (cityID, name, population, sea_level, GDP) values (6, 'Saint-Priest', 5286388, 77.6, 48.62);
insert into cities (cityID, name, population, sea_level, GDP) values (7, 'Vahdat', 3560551, 353.6, 3.89);
insert into cities (cityID, name, population, sea_level, GDP) values (8, 'Nice', 8888301, 892.2, 39.1);
insert into cities (cityID, name, population, sea_level, GDP) values (9, 'Huaitu', 6004079, 116.0, 40.59);
insert into cities (cityID, name, population, sea_level, GDP) values (10, 'Woro', 2525182, 898.6, 49.18);
insert into cities (cityID, name, population, sea_level, GDP) values (11, 'Xiangqiao', 4569868, 459.3, 38.52);
insert into cities (cityID, name, population, sea_level, GDP) values (12, 'Yuecheng', 6927218, 585.2, 25.82);
insert into cities (cityID, name, population, sea_level, GDP) values (13, 'Xianghu', 3831207, 419.4, 10.38);
insert into cities (cityID, name, population, sea_level, GDP) values (14, 'Hedaru', 5441014, 233.6, 2.67);
insert into cities (cityID, name, population, sea_level, GDP) values (15, 'Senglea', 1362469, 623.2, 19.91);
insert into cities (cityID, name, population, sea_level, GDP) values (16, 'Cúa', 9528707, 949.7, 42.64);
insert into cities (cityID, name, population, sea_level, GDP) values (17, 'Oropesa', 4454091, 287.4, 39.4);
insert into cities (cityID, name, population, sea_level, GDP) values (18, 'Senekal', 3787746, 152.4, 14.45);
insert into cities (cityID, name, population, sea_level, GDP) values (19, 'Bayombong', 6242713, 197.6, 49.34);
insert into cities (cityID, name, population, sea_level, GDP) values (20, 'Orosh', 938317, 297.3, 46.53);

insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (1, 'Russia', 521408263, 286, 98, '$34.05');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (2, 'Ukraine', 860924979, 179, 26, '$24.99');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (3, 'Somalia', 335716841, 250, 28, '$36.04');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (4, 'Morocco', 462806955, 121, 50, '$45.55');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (5, 'China', 705698335, 355, 69, '$12.62');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (6, 'United States', 434514612, 335, 47, '$33.82');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (7, 'Latvia', 291913532, 451, 44, '$48.19');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (8, 'Nigeria', 170868037, 1, 74, '$23.95');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (9, 'Czech Republic', 734444456, 58, 39, '$40.89');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (10, 'France', 285766467, 377, 43, '$47.85');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (11, 'Indonesia', 563527239, 177, 89, '$27.28');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (12, 'Indonesia', 600778212, 44, 20, '$40.99');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (13, 'China', 648361474, 307, 86, '$43.40');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (14, 'Japan', 798895467, 215, 55, '$48.25');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (15, 'Brazil', 397818647, 355, 96, '$34.51');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (16, 'Greece', 479409147, 148, 59, '$19.31');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (17, 'Poland', 283919095, 471, 82, '$35.22');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (18, 'United States', 676799619, 324, 82, '$41.25');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (19, 'Portugal', 541427071, 76, 87, '$2.09');
insert into countries (countryID, name, population, air_quality, sea_level, GDP) values (20, 'Philippines', 20989720, 32, 51, '$43.10');


insert into continents (continentID, name) values (1, 'SA');
insert into continents (continentID, name) values (2, 'AS');
insert into continents (continentID, name) values (3, 'NA');
insert into continents (continentID, name) values (4, 'NA');
insert into continents (continentID, name) values (5, 'EU');
insert into continents (continentID, name) values (6, 'SA');
insert into continents (continentID, name) values (7, 'OC');
insert into continents (continentID, name) values (8, 'AS');
insert into continents (continentID, name) values (9, 'EU');
insert into continents (continentID, name) values (10, 'OC');
insert into continents (continentID, name) values (11, 'EU');
insert into continents (continentID, name) values (12, 'AF');
insert into continents (continentID, name) values (13, 'SA');
insert into continents (continentID, name) values (14, 'OC');
insert into continents (continentID, name) values (15, 'OC');
insert into continents (continentID, name) values (16, 'AF');
insert into continents (continentID, name) values (17, 'EU');
insert into continents (continentID, name) values (18, 'EU');
insert into continents (continentID, name) values (19, 'SA');
insert into continents (continentID, name) values (20, 'AF');


insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (1, 28.38, 28.71, 21.02, 74.52, 55.69, 4.25, 76.11, 81.88);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (2, 70.38, 32.88, 54.49, 81.09, 84.26, 32.04, 19.82, 20.45);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (3, 88.52, 37.45, 87.03, 29.55, 85.04, 1.78, 25.57, 96.21);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (4, 21.9, 9.63, 75.77, 50.87, 85.48, 73.25, 4.78, 7.09);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (5, 43.72, 60.13, 46.49, 46.98, 1.33, 81.01, 67.26, 91.85);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (6, 2.27, 72.78, 7.17, 46.1, 61.24, 59.36, 58.94, 77.52);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (7, 36.39, 1.39, 27.64, 27.67, 18.12, 38.8, 68.91, 35.05);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (8, 66.88, 7.43, 89.17, 29.25, 17.1, 74.73, 49.78, 19.88);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (9, 69.54, 86.35, 45.6, 29.97, 88.7, 84.67, 4.91, 92.63);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (10, 83.12, 6.22, 9.13, 98.45, 9.47, 35.03, 50.57, 94.84);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (11, 40.84, 73.18, 46.49, 21.78, 1.05, 24.23, 64.23, 53.47);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (12, 48.22, 82.52, 48.73, 26.94, 6.53, 74.75, 79.66, 79.91);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (13, 46.85, 10.08, 83.78, 50.42, 97.87, 80.69, 70.36, 90.23);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (14, 64.24, 37.5, 22.29, 5.88, 75.14, 57.38, 86.27, 33.87);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (15, 58.17, 37.74, 16.15, 29.64, 90.77, 46.84, 39.81, 48.2);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (16, 94.77, 29.72, 94.77, 13.01, 51.9, 75.07, 58.71, 81.74);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (17, 94.05, 95.63, 19.76, 24.8, 90.9, 73.32, 78.95, 22.31);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (18, 99.52, 87.55, 71.42, 32.27, 47.1, 66.1, 34.37, 3.95);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (19, 77.41, 54.66, 78.97, 65.33, 35.59, 48.24, 50.93, 71.76);
insert into radiative_forcing (rf_cityID, co2, other_GHG, ozone, ARI, surface_albedo, contrails, SWCH4, solar_irradiance) values (20, 58.36, 55.83, 98.86, 27.4, 24.26, 11.31, 63.15, 3.17);

insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (27.6, 2008, 403, 70);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (0.5, 2003, 127, 66);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (5.0, 2013, 228, 66);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (22.1, 1995, 197, 17);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (22.8, 2016, 341, 29);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (25.7, 2020, 75, 84);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (16.9, 2014, 359, 43);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (0.1, 2010, 279, 97);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (20.3, 1987, 210, 38);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (25.7, 1989, 61, 40);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (26.1, 1988, 238, 55);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (17.0, 2002, 15, 45);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (20.1, 1996, 93, 68);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (23.5, 1993, 333, 20);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (24.8, 2009, 398, 95);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (15.5, 1976, 191, 47);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (15.9, 2007, 224, 70);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (3.1, 2005, 148, 77);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (0.8, 1999, 420, 27);
insert into climate_change_trends (temperature, trend_year, air_quality, sea_level) values (8.3, 1982, 397, 92);


insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (1, 'justo', 48, 76);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (2, 'sit', 29, 24);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (3, 'suspendisse', 42, 39);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (4, 'fusce', 15, 68);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (5, 'augue', 11, 25);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (6, 'lorem', 35, 91);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (7, 'fusce', 40, 79);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (8, 'volutpat', 28, 25);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (9, 'nibh', 34, 52);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (10, 'eget', 29, 41);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (11, 'nibh', 21, 26);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (12, 'ut', 47, 59);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (13, 'augue', 50, 36);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (14, 'integer', 49, 85);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (15, 'montes', 21, 24);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (16, 'nisi', 14, 21);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (17, 'in', 17, 97);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (18, 'natoque', 43, 44);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (19, 'quam', 22, 80);
insert into adaptation_techniques (adaptationID, name, est_lives_saved_per_dollar, est_dollars_saved_per_dollar) values (20, 'eu', 49, 30);

insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (1, 'libero', 81);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (2, 'elit', 8);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (3, 'rutrum', 22);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (4, 'consectetuer', 28);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (5, 'in', 62);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (6, 'volutpat', 18);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (7, 'congue', 15);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (8, 'ac', 77);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (9, 'amet', 5);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (10, 'cum', 62);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (11, 'pede', 75);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (12, 'pede', 13);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (13, 'in', 15);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (14, 'habitasse', 99);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (15, 'consectetuer', 33);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (16, 'sed', 11);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (17, 'quis', 56);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (18, 'lacinia', 63);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (19, 'vel', 38);
insert into mitigation_techniques (mitigationID, mitigation_type, WPM_RFMPD) values (20, 'praesent', 77);


insert into energy (energyID, name, cost_per_watt) values (1, 'nulla', 36);
insert into energy (energyID, name, cost_per_watt) values (2, 'semper', 79);
insert into energy (energyID, name, cost_per_watt) values (3, 'nascetur', 19);
insert into energy (energyID, name, cost_per_watt) values (4, 'nonummy', 86);
insert into energy (energyID, name, cost_per_watt) values (5, 'maecenas', 42);
insert into energy (energyID, name, cost_per_watt) values (6, 'orci', 63);
insert into energy (energyID, name, cost_per_watt) values (7, 'ipsum', 37);
insert into energy (energyID, name, cost_per_watt) values (8, 'sit', 70);
insert into energy (energyID, name, cost_per_watt) values (9, 'vel', 100);
insert into energy (energyID, name, cost_per_watt) values (10, 'augue', 40);
insert into energy (energyID, name, cost_per_watt) values (11, 'nisl', 11);
insert into energy (energyID, name, cost_per_watt) values (12, 'dapibus', 15);
insert into energy (energyID, name, cost_per_watt) values (13, 'feugiat', 67);
insert into energy (energyID, name, cost_per_watt) values (14, 'lobortis', 89);
insert into energy (energyID, name, cost_per_watt) values (15, 'turpis', 92);
insert into energy (energyID, name, cost_per_watt) values (16, 'est', 19);
insert into energy (energyID, name, cost_per_watt) values (17, 'penatibus', 85);
insert into energy (energyID, name, cost_per_watt) values (18, 'sed', 37);
insert into energy (energyID, name, cost_per_watt) values (19, 'vestibulum', 18);
insert into energy (energyID, name, cost_per_watt) values (20, 'donec', 90);

insert into resource (resourceID, resource_name) values (1, 'in');
insert into resource (resourceID, resource_name) values (2, 'non');
insert into resource (resourceID, resource_name) values (3, 'maecenas');
insert into resource (resourceID, resource_name) values (4, 'nec');
insert into resource (resourceID, resource_name) values (5, 'quis');
insert into resource (resourceID, resource_name) values (6, 'odio');
insert into resource (resourceID, resource_name) values (7, 'erat');
insert into resource (resourceID, resource_name) values (8, 'in');
insert into resource (resourceID, resource_name) values (9, 'lectus');
insert into resource (resourceID, resource_name) values (10, 'dictumst');
insert into resource (resourceID, resource_name) values (11, 'eu');
insert into resource (resourceID, resource_name) values (12, 'at');
insert into resource (resourceID, resource_name) values (13, 'odio');
insert into resource (resourceID, resource_name) values (14, 'amet');
insert into resource (resourceID, resource_name) values (15, 'lacus');
insert into resource (resourceID, resource_name) values (16, 'dapibus');
insert into resource (resourceID, resource_name) values (17, 'sapien');
insert into resource (resourceID, resource_name) values (18, 'massa');
insert into resource (resourceID, resource_name) values (19, 'velit');
insert into resource (resourceID, resource_name) values (20, 'sit');

insert into city_mitigation_techs (mitigationID, cityID) values (1,1);
insert into city_mitigation_techs (mitigationID, cityID) values (2, 2);
insert into city_mitigation_techs (mitigationID, cityID) values (3, 3);
insert into city_mitigation_techs (mitigationID, cityID) values (4, 4);
insert into city_mitigation_techs (mitigationID, cityID) values (5, 5);
insert into city_mitigation_techs (mitigationID, cityID) values (6, 6);
insert into city_mitigation_techs (mitigationID, cityID) values (7, 7);
insert into city_mitigation_techs (mitigationID, cityID) values (8, 8);
insert into city_mitigation_techs (mitigationID, cityID) values (9, 9);
insert into city_mitigation_techs (mitigationID, cityID) values (10, 10);
insert into city_mitigation_techs (mitigationID, cityID) values (11, 11);
insert into city_mitigation_techs (mitigationID, cityID) values (12, 12);
insert into city_mitigation_techs (mitigationID, cityID) values (13, 13);
insert into city_mitigation_techs (mitigationID, cityID) values (14, 14);
insert into city_mitigation_techs (mitigationID, cityID) values (15, 15);
insert into city_mitigation_techs (mitigationID, cityID) values (16, 16);
insert into city_mitigation_techs (mitigationID, cityID) values (17, 17);
insert into city_mitigation_techs (mitigationID, cityID) values (18, 18);
insert into city_mitigation_techs (mitigationID, cityID) values (19, 19);
insert into city_mitigation_techs (mitigationID, cityID) values (20, 20);

insert into city_adapt (cityID, adaptationID) values (1, 1);
insert into city_adapt (cityID, adaptationID) values (2, 2);
insert into city_adapt (cityID, adaptationID) values (3, 3);
insert into city_adapt (cityID, adaptationID) values (4, 4);
insert into city_adapt (cityID, adaptationID) values (5, 5);
insert into city_adapt (cityID, adaptationID) values (6, 6);
insert into city_adapt (cityID, adaptationID) values (7, 7);
insert into city_adapt (cityID, adaptationID) values (8, 8);
insert into city_adapt (cityID, adaptationID) values (9, 9);
insert into city_adapt (cityID, adaptationID) values (10, 10);
insert into city_adapt (cityID, adaptationID) values (11, 11);
insert into city_adapt (cityID, adaptationID) values (12, 12);
insert into city_adapt (cityID, adaptationID) values (13, 13);
insert into city_adapt (cityID, adaptationID) values (14, 14);
insert into city_adapt (cityID, adaptationID) values (15, 15);
insert into city_adapt (cityID, adaptationID) values (16, 16);
insert into city_adapt (cityID, adaptationID) values (17, 17);
insert into city_adapt (cityID, adaptationID) values (18, 18);
insert into city_adapt (cityID, adaptationID) values (19, 19);
insert into city_adapt (cityID, adaptationID) values (20, 20);

insert into city_energy (energyID, cityID) values (1, 1);
insert into city_energy (energyID, cityID) values (2, 2);
insert into city_energy (energyID, cityID) values (3, 3);
insert into city_energy (energyID, cityID) values (4, 4);
insert into city_energy (energyID, cityID) values (5, 5);
insert into city_energy (energyID, cityID) values (6, 6);
insert into city_energy (energyID, cityID) values (7, 7);
insert into city_energy (energyID, cityID) values (8, 8);
insert into city_energy (energyID, cityID) values (9, 9);
insert into city_energy (energyID, cityID) values (10, 10);
insert into city_energy (energyID, cityID) values (11, 11);
insert into city_energy (energyID, cityID) values (12, 12);
insert into city_energy (energyID, cityID) values (13, 13);
insert into city_energy (energyID, cityID) values (14, 14);
insert into city_energy (energyID, cityID) values (15, 15);
insert into city_energy (energyID, cityID) values (16, 16);
insert into city_energy (energyID, cityID) values (17, 17);
insert into city_energy (energyID, cityID) values (18, 18);
insert into city_energy (energyID, cityID) values (19, 19);
insert into city_energy (energyID, cityID) values (20, 20);
