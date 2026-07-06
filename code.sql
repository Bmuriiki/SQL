create schema if not exists digicity;

set search_path to digicity;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone_number VARCHAR(20),
    joined_on DATE
);

INSERT INTO customers (
    full_name,
    email,
    phone_number,
    joined_on
)
VALUES
('Brian Muriiki', 'brian.muriiki@gmail.com', '+254701428898', '2025-07-06'),
('Faith Wanjiku', 'faith.wanjiku@gmail.com', '+254712345601', '2025-02-15'),
('John Kamau', 'john.kamau@gmail.com', '+254712345602', '2025-03-11'),
('Mary Atieno', 'mary.atieno@gmail.com', '+254712345603', '2025-04-08'),
('Peter Otieno', 'peter.otieno@gmail.com', '+254712345604', '2025-01-20'),
('Grace Njeri', 'grace.njeri@gmail.com', '+254712345605', '2025-05-02'),
('James Mwangi', 'james.mwangi@gmail.com', '+254712345606', '2025-06-18')
