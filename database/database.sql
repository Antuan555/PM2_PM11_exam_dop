CREATE DATABASE book_world;
\c book_world;

CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    role_id INTEGER NOT NULL REFERENCES roles(role_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    full_name TEXT NOT NULL,
    login TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL
);

CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE publishers (
    publisher_id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    article TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    author_id INTEGER NOT NULL REFERENCES authors(author_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    genre_id INTEGER NOT NULL REFERENCES genres(genre_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    publisher_id INTEGER NOT NULL REFERENCES publishers(publisher_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    year INTEGER NOT NULL CHECK (year >= 0),
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    discount_price NUMERIC(10,2) DEFAULT NULL CHECK (discount_price >= 0),
    is_on_sale BOOLEAN DEFAULT FALSE,
    stock INTEGER DEFAULT 0 CHECK (stock >= 0),
    description TEXT,
    cover_path TEXT DEFAULT 'picture.png'
);

CREATE TABLE pickup_points (
    pickup_point_id SERIAL PRIMARY KEY,
    address TEXT NOT NULL UNIQUE
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    pickup_point_id INTEGER NOT NULL REFERENCES pickup_points(pickup_point_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    order_date DATE NOT NULL,
    delivery_date DATE NOT NULL,
    receive_code TEXT NOT NULL,
    status TEXT CHECK (status IN ('Новый', 'В обработке', 'Доставлен', 'Отменён')) NOT NULL
);

CREATE TABLE order_details (
    detail_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE ON UPDATE CASCADE,
    book_id INTEGER NOT NULL REFERENCES books(book_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0)
);

INSERT INTO roles (name) VALUES 
('Администратор'),
('Менеджер'),
('Авторизованный клиент');

INSERT INTO users (role_id, full_name, login, password_hash) VALUES
(1, 'Орлова Алина Викторовна', 'a.orlova@bookworld.ru', 'Ah7kLp'),
(1, 'Волков Денис Сергеевич', 'd.volkov@bookworld.ru', 'Bm2qR9'),
(2, 'Семенова Ирина Олеговна', 'i.semenova@bookworld.ru', 'Cn8tWx'),
(2, 'Козлов Максим Игоревич', 'm.kozlov@bookworld.ru', 'Df4yUz'),
(2, 'Николаева Татьяна Петровна', 't.nikolaeva@bookworld.ru', 'Eg6vAs'),
(3, 'Белов Алексей Дмитриевич', 'a.belov@example.com', 'Fh9jQw'),
(3, 'Соколова Мария Андреевна', 'm.sokolova@example.com', 'Gi1kEx'),
(3, 'Морозов Иван Павлович', 'i.morozov@example.com', 'Hj2lFy'),
(3, 'Лебедева Ольга Васильевна', 'o.lebedeva@example.com', 'Kk3mGz');

INSERT INTO authors (name) VALUES
('Михаил Булгаков'),
('Джордж Оруэлл'),
('Федор Достоевский'),
('Эрих Мария Ремарк'),
('Антуан де Сент-Экзюпери'),
('Артур Конан Дойл'),
('Джоан Роулинг'),
('Агата Кристи'),
('Лев Толстой'),
('Пауло Коэльо'),
('Оскар Уайльд'),
('Джером Сэлинджер'),
('Орсон Скотт Кард'),
('Дуглас Адамс'),
('Дэниел Киз');

INSERT INTO genres (name) VALUES
('Классика'),
('Антиутопия'),
('Детская'),
('Детектив'),
('Фэнтези'),
('Роман'),
('Фантастика'),
('Научная фантастика');

INSERT INTO publishers (name) VALUES
('Эксмо'),
('АСТ'),
('Азбука'),
('Махаон'),
('София'),
('Иностранка');

INSERT INTO books (article, title, author_id, genre_id, publisher_id, year, price, discount_price, is_on_sale, stock, description, cover_path) VALUES
('B112F4', 'Мастер и Маргарита', 1, 1, 1, 2020, 450, 380.00, TRUE, 12, 'Бессмертное произведение русской литературы.', '1.png'),
('F635R4', '1984', 2, 2, 2, 2019, 520, NULL, FALSE, 8, 'Антиутопия о тоталитарном обществе.', '2.png'),
('H782T5', 'Преступление и наказание', 3, 1, 1, 2021, 480, 430.00, TRUE, 15, 'Психологический роман о раскаянии.', '3.png'),
('G783F5', 'Три товарища', 4, 1, 3, 2018, 590, NULL, FALSE, 7, 'История о дружбе и любви.', '4.png'),
('J384T6', 'Маленький принц', 5, 3, 4, 2022, 380, 340.00, TRUE, 20, 'Философская сказка для детей и взрослых.', '5.png'),
('D572U8', 'Шерлок Холмс (сборник)', 6, 4, 1, 2020, 650, 590.00, TRUE, 9, 'Расследования великого сыщика.', '6.png'),
('F572H7', 'Гарри Поттер и философский камень', 7, 5, 4, 2021, 720, NULL, FALSE, 14, 'Первая книга культовой серии о Гарри Поттере.', '7.png'),
('D329H3', 'Убийство в Восточном экспрессе', 8, 4, 1, 2019, 430, 390.00, TRUE, 11, 'Дело Эркюля Пуаро.', '8.png'),
('B320R5', 'Война и мир (том 1)', 9, 1, 2, 2021, 550, NULL, FALSE, 6, 'Роман-эпопея о войне с Наполеоном.', '9.png'),
('G432E4', 'Алхимик', 10, 6, 5, 2020, 480, 430.00, TRUE, 18, 'Притча о поиске предназначения.', '10.png'),
('S213E3', 'Портрет Дориана Грея', 11, 1, 1, 2018, 460, NULL, FALSE, 5, 'История о красоте и разврате.', 'picture.png'),
('E482R4', 'Над пропастью во ржи', 12, 1, 3, 2019, 390, 350.00, TRUE, 10, 'Роман о подростковом бунте.', 'picture.png'),
('S634B5', 'Игра Эндера', 13, 7, 1, 2021, 540, NULL, FALSE, 0, 'Фантастика о юном гении.', 'picture.png'),
('K345R4', 'Автостопом по галактике', 14, 7, 2, 2020, 510, 460.00, TRUE, 13, 'Юмористическая фантастика.', 'picture.png'),
('O754F4', 'Цветы для Элджернона', 15, 8, 6, 2021, 470, 420.00, TRUE, 8, 'История эксперимента по повышению интеллекта.', 'picture.png');

INSERT INTO pickup_points (address) VALUES
('г. Москва, ул. Тверская, д. 10'),
('г. Санкт-Петербург, Невский пр-т, д. 45'),
('г. Екатеринбург, ул. Ленина, д. 33'),
('г. Новосибирск, Красный пр-т, д. 20'),
('г. Казань, ул. Баумана, д. 15');

INSERT INTO orders (order_id, user_id, pickup_point_id, order_date, delivery_date, receive_code, status) VALUES
(1001, 6, 1, '2025-02-15', '2025-02-20', 'Z1X9Y2', 'Доставлен'),
(1002, 7, 2, '2025-02-16', '2025-02-21', 'A3B4C5', 'Доставлен'),
(1003, 8, 3, '2025-02-18', '2025-02-23', 'D6E7F8', 'Доставлен'),
(1004, 9, 4, '2025-02-20', '2025-02-25', 'G9H0I1', 'Доставлен'),
(1005, 6, 5, '2025-03-01', '2025-03-06', 'J2K3L4', 'В обработке');

INSERT INTO order_details (order_id, book_id, quantity) VALUES
(1001, 1, 1), (1001, 2, 2),
(1002, 3, 1), (1002, 4, 1),
(1003, 5, 1), (1003, 6, 1),
(1004, 7, 1), (1004, 8, 1),
(1005, 1, 2), (1005, 2, 1);
