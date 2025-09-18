☕ *Smart Ahwa Manager*

A simple Flutter app for managing a coffee shop (Ahwa).
It uses Cubit (flutter_bloc) for state management, and demonstrates OOP and SOLID principles in practice.

📌 Features

Add new orders with drink customization (extra sugar, extra mint, double shot, etc.).

Manage pending orders and mark them as completed.

View daily reports:

Total revenue.

Number of orders.

Top-selling drinks.

Console notifications when receiving or completing an order.

Clean and simple Flutter UI.

🛠️ Tech Stack

Flutter

flutter_bloc (Cubit) for state management.

equatable for object equality.

🧑‍💻 OOP Concepts Used

Abstraction

abstract class Drink defines the common interface for all drinks (name, price, icon, methods for price and description).

Subclasses like Shai, TurkishCoffee, and HibiscusTea must implement those.

Inheritance

Classes Shai, TurkishCoffee, HibiscusTea inherit from Drink.

They reuse base properties and add their own logic.

Polymorphism

Methods like calculatePrice() and getDescription() behave differently depending on the specific subclass.

Encapsulation

Order class uses private fields (e.g., _id, _drink) with getters to control access.

Guarantees data integrity by updating only through controlled methods.

Factory Constructors

Order.create ensures consistent order creation.

Order.completed creates a completed copy of an existing order.

🧩 SOLID Principles Applied

S - Single Responsibility Principle (SRP)

AhwaManagerCubit → handles state management.

OrderRepository → handles order storage and retrieval.

ReportGenerator → generates daily reports.

O - Open/Closed Principle (OCP)

Adding a new drink (e.g., Latte) requires only creating a new subclass of Drink, without modifying existing code.

L - Liskov Substitution Principle (LSP)

Any subclass of Drink (Shai, TurkishCoffee, etc.) can be used wherever a Drink is expected.

I - Interface Segregation Principle (ISP)

Interfaces are split by responsibility:

OrderRepository for order management.

ReportGenerator for reports.

OrderNotificationService for notifications.

Clients only depend on what they actually need.

D - Dependency Inversion Principle (DIP)

AhwaManagerCubit depends on abstractions (OrderRepository, OrderNotificationService), not concrete implementations.

Makes it easy to swap storage (InMemory → Database) or notifications (Console → Push).

📂 Project Structure
lib/
 ├── core/
 │    └── services/
 │         └── notification_service.dart        # Notification service
 │
 ├── features/
 │    ├── data/
 │    │    ├── models/                          # Entities & drink models
 │    │    │    ├── drink.dart
 │    │    │    ├── hibiscus_tea.dart
 │    │    │    ├── order.dart
 │    │    │    ├── shai_model.dart
 │    │    │    └── turkish_coffee.dart
 │    │    │
 │    │    ├── repo/                            # Implementations
 │    │    │    ├── daily_report_generator.dart
 │    │    │    ├── in_memory_repo.dart
 │    │    │    └── order_notify_repo.dart
 │    │
 │    ├── domain/                               # Abstractions (Repositories)
 │    │    └── repo/
 │    │         ├── order_repo.dart
 │    │         └── report_generator_repo.dart
 │    │
 │    └── presentation/                         # UI + State Management
 │         ├── logic/cubit/
 │         │    ├── ahwa_manager_cubit.dart
 │         │    └── ahwa_manager_state.dart
 │         │
 │         └── ui/
 │              ├── widgets/
 │              │    └── order_card.dart
 │              │
 │              ├── add_order_screen.dart
 │              ├── ahwa_manager_home_page.dart
 │              ├── dash_board_screen.dart
 │              └── report_screen.dart
