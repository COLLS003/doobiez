-- Database
CREATE DATABASE hospital;
\c hospital;

-- Patient
CREATE TABLE patient (
  id serial NOT NULL,
  PRIMARY KEY (id),
  name character varying NOT NULL,
  age integer NOT NULL,
  location  character varying NOT NULL,
  email  character varying NOT NULL,
  password character varying NOT NULL
);


-- specialist
CREATE TABLE specialist (
  id serial NOT NULL,
  PRIMARY KEY (id),
  name character varying NOT NULL,
  category_id  integer NOT NULL,
  location  character varying NOT NULL,
  email  character varying NOT NULL,
  availability  integer NOT NULL
);

-- category
CREATE TABLE category (
  id uuid NOT NULL,
  name  character varying NOT NULL,
  description   character varying NOT NULL

);


-- symptoms
CREATE TABLE symptoms (
  id uuid NOT NULL,
  name  character varying NOT NULL,
  description   character varying NOT NULL

);

-- illness
CREATE TABLE illness (
  id serial NOT NULL,
  PRIMARY KEY (id),
  name character varying NOT NULL,
  description   character varying NOT NULL
);


-- subIllness
CREATE TABLE subIllness (
  id serial NOT NULL,
  PRIMARY KEY (id),
  name character varying NOT NULL,
  illness integer NOT NULL,
  description   character varying NOT NULL
);

-- Link between illness  and symptoms
CREATE TABLE illnessSymptoms (
  illness_id integer NOT NULL,
  symptom_id integer NOT NULL
);
-- create the bill table
CREATE TABLE bill (
    id serial NOT NULL,
    PRIMARY KEY (id),
    patient_id character varying NOT NULL,
    amount  character varying NOT NULL
);
-- link the tables


--ALTER TABLE specialist
--ADD FOREIGN KEY (category_id) REFERENCES category (id);
--
--ALTER TABLE illnessSymptoms
--ADD FOREIGN KEY (illness_id) REFERENCES illness (id);
--
--ALTER TABLE illnessSymptoms
--ADD FOREIGN KEY (symptom_id)  REFERENCES symptoms (id);
--
--ALTER TABLE subIllness
--ADD FOREIGN KEY (illness_id)  REFERENCES illness (id);

-- Link between illness  and symptoms

--ALTER TABLE movies_actors
--ADD CONSTRAINT movies_actors_id_movies_id_actors PRIMARY KEY (movie_id, actor_id);
--ALTER TABLE movies_actors
--ADD FOREIGN KEY (movie_id) REFERENCES movies (id);
--ALTER TABLE movies_actors
--ADD FOREIGN KEY (actor_id) REFERENCES actors (id);
--data insertion
-- Patients
INSERT INTO patient (name, age, location, email, password)
VALUES
  ('John Doe', 30, 'New York', 'john.doe@example.com', 'password1'),
  ('Alice Smith', 25, 'Los Angeles', 'alice.smith@example.com', 'password2'),
  ('Bob Johnson', 40, 'Chicago', 'bob.johnson@example.com', 'password3'),
  ('Mary White', 35, 'San Francisco', 'mary.white@example.com', 'password4'),
  ('David Lee', 28, 'Houston', 'david.lee@example.com', 'password5');
COMMIT;

-- Specialists
INSERT INTO specialist (name, category_id, location, email, availability)
VALUES
  ('Dr. Smith', 1, 'New York', 'dr.smith@example.com', 5),
  ('Dr. Johnson', 2, 'Los Angeles', 'dr.johnson@example.com', 4),
  ('Dr. Brown', 3, 'Chicago', 'dr.brown@example.com', 6),
  ('Dr. White', 1, 'San Francisco', 'dr.white@example.com', 3),
  ('Dr. Lee', 2, 'Houston', 'dr.lee@example.com', 7);
COMMIT;

-- Categories
INSERT INTO category (id, name, description)
VALUES
  ('1cbb8c1f-69d0-4bea-9c26-92b86b9e2b1e', 'Cardiology', 'Deals with heart-related issues'),
  ('01c8a65a-af36-4db2-b077-f3c52453100d', 'Dermatology', 'Specializes in skin diseases'),
  ('c097b0a7-07f6-4b0b-8dfc-2d488b176a45', 'Orthopedics', 'Focuses on bone and joint problems');
COMMIT;

-- Symptoms
INSERT INTO symptoms (name, description)
VALUES
  ('Fever', 'Elevated body temperature'),
  ('Rash', 'Skin irritation or redness'),
  ('Chest Pain', 'Discomfort in the chest area');
COMMIT;

-- Illnesses
INSERT INTO illness (name, description)
VALUES
  ('Hypertension', 'High blood pressure condition'),
  ('Eczema', 'Skin inflammation and irritation'),
  ('Fractured Bone', 'Broken bone injury');
COMMIT;

-- Sub-Illnesses
INSERT INTO subIllness (name, illness, description)
VALUES
  ('Hypertension Stage 1', 1, 'Mild high blood pressure condition'),
  ('Atopic Dermatitis', 2, 'Chronic skin condition'),
  ('Broken Arm', 3, 'Fractured upper arm bone');
COMMIT;

-- Illness-Symptoms Link
INSERT INTO illnessSymptoms (illness_id, symptom_id)
VALUES
  (1, 1), -- Hypertension is associated with Fever
  (2, 2), -- Eczema is associated with Rash
  (3, 3); -- Fractured Bone is associated with Chest Pain
COMMIT;

-- Bills
INSERT INTO bill (patient_id, amount)
VALUES
  (1, '100.00'),
  (2, '75.50'),
  (3, '120.25'),
  (4, '90.75'),
  (5, '110.50');
COMMIT;
