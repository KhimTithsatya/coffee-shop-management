# Coffee Shop Management System

Starter project:
- `frontend/`: Flutter Web dashboard and product management screen
- `backend/`: Spring Boot REST API for products
- MySQL database

## Requirements
- Flutter SDK and Chrome
- Java 17+
- MySQL 8+
- Internet access for Maven/Gradle dependencies on first run

## 1. Create the MySQL database

Log in to MySQL and run:

```sql
CREATE DATABASE coffee_shop;
```

## 2. Configure backend database access

Edit `backend/src/main/resources/application.properties` and set your own MySQL username/password.

Default example:
```properties
spring.datasource.username=root
spring.datasource.password=your_password
```

Do not commit real passwords to GitHub.

## 3. Run backend

Open a terminal:

```bash
cd backend
./mvnw spring-boot:run
```

If the project does not contain the Maven Wrapper for your environment, use:
```bash
mvn spring-boot:run
```

The API runs at `http://localhost:8080`.
Test products: `http://localhost:8080/api/products`

## 4. Run frontend

Open another terminal:

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

The frontend calls `http://localhost:8080/api/products`.

## Included in this starter
- Dashboard shell
- Product listing, add, edit, and deactivate
- Spring Boot product REST endpoints
- MySQL persistence via Spring Data JPA
- CORS configuration for local Flutter Web development

## Next milestones
1. Add login and admin/cashier roles.
2. Build POS cart and checkout.
3. Save orders and order items in a transaction.
4. Add ingredients, stock movements, and purchases.
5. Add sales reports and receipt printing.

This is a development starter, not production-ready. Add authentication, validation, secure configuration, and tests before real shop use.
