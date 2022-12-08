create database climatechange_db;
create user 'webapp'@'%' identified by 'test123';
grant select on climatechange_db.* to 'webapp'@'%';
flush privileges;

use climatechange_db;

create table people(
    age int not null,
    peopleID int auto_increment not null,
    religion varchar(20),
    income float,
    gender varchar(10) not null,
    race varchar(30) not null,
    annual_emissions float anot null,
    first_name varchar(20) not null,
    last_name varchar(20) not null,
    email text,
    phone text,
    fax text,
    street text not null,
    postal_code int not null,
    industryID int,
    cityID int,
    primary key(peopleID),
    constraint fk_1 foreign key (industryID)
                   references industry(industryID)
                   on update cascade on delete restrict,
    constraint fk_2 foreign key (cityID)
                   references cities(cityID)
                   on update cascade on delete restrict
);

create table industry(
    industryID int auto_increment not null,
    name varchar(30) not null,
    annual_emissions float not null,
    annual_revenue float not null,
    countryID int,
    primary key(industryID),
    constraint fk_1 foreign key (countryID)
                     references countries(countryID)
                     on update cascade on delete restrict

);

create table countries(
    countryID int auto_increment not null,
    name varchar(30) not null,
    GDP float not null,
    air_quality float not null,
    population int not null,
    sea_level float not null,
    continentID int,
    primary key(countryID),
    constraint fk_1 foreign key (continentID)
                      references continents(continentID)
                      on update cascade on delete restrict
);

create table continents(
    continentID int auto_increment not null,
    name varchar(20) not null,
    primary key(continentID)
);

create table cities(
    cityID int auto_increment not null,
    GDP float not null,
    name varchar(30) not null,
    population float not null,
    sea_level float not null,
    countryID int,
    trend_year year,
    primary key(cityID),
    constraint fk_1 foreign key (countryID)
                   references countries(countryID)
                   on update cascade on delete restrict,
    constraint fk_2 foreign key (trend_year)
                   references climate_change_trends(trend_year)
                   on update cascade on delete restrict
);

create table climate_change_trends(
    trend_year year not null,
    temperature float not null,
    air_quality float not null,
    sea_level float not null
);

create table appendix(
    acronym varchar(10) not null,
    definition text not null,
    phrase varchar(20) not null,
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
    constraint fk_1 foreign key (energyID)
                     references energy(energyID)
                     on update cascade on delete restrict
    );

create table radiative_forcing(
    cityID int auto_increment not null,
    co2 float not null,
    other_GHG float not null,
    ozone float not null,
    ARI float not null,
    surface_albedo float not null,
    contrails float not null,
    SWCH4 float not null,
    solar_irradiance float not null,
    trend_year year,
    primary key(cityID),
    constraint fk_1 foreign key (trend_year)
                              references climate_change_trends(trend_year)
                              on update cascade on delete restrict
);

create table adaptation_techniques(
    adapatationID int auto_increment not null,
    name varchar(30) not null,
    est_lives_saved_per_dollar int not null,
    est_dollars_saved_per_dollar float not null,
    primary key(adapatationID)
);

create table mitigation_techniques(
    mitigationID int auto_increment not null,
    name varchar(30) not null,
    WPM_RFMPD float not null

);

create table city_mitigation_techs(
    mitigationID int,
    cityID int,
    constraint fk_1 foreign key (mitigationID)
                                  references mitigation_techniques(mitigationID)
                                  on update cascade on delete restrict,
    constraint fk_2 foreign key (cityID)
                                  references cities(cityID)
                                  on update cascade on delete restrict
);

create table city_energy(
    energyID int,
    cityID int,
    constraint fk_1 foreign key (energyID)
                        references energy(energyID)
                        on update cascade on delete restrict,
    constraint fk_2 foreign key (cityID)
                        references cities(cityID)
                        on update cascade on delete restrict
);