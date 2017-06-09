DROP TABLE customers;
DROP TABLE films;
DROP TABLE tickets;

CREATE customers (
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255),
  funds INT4
  deleted BOOLEAN DEFAULT FALSE
);

CREATE films (
  id SERIAL8 PRIMARY KEY,
  title VARCHAR(255),
  price INT4


);
