# RentMate 🏕️

A comprehensive camping equipment rental platform that connects item owners with renters, featuring secure payments, real-time chat, and streamlined rental management.

## 📋 Overview

RentMate is a full-stack web application designed to facilitate the rental of camping equipment and outdoor gear. The platform enables users to list their items for rent, browse available equipment, manage rental transactions, and communicate seamlessly through an integrated messaging system.

## ✨ Features

### For Renters
- 🔍 **Browse & Search** - Discover camping equipment with advanced filtering
- 📱 **Real-time Chat** - Communicate directly with item owners
- 💳 **Secure Payments** - Upload payment slips and track transactions
- 📊 **Rental Dashboard** - Monitor all active and past rentals
- ⭐ **Review System** - Rate and review rental experiences
- 🔔 **Notifications** - Stay updated on rental status changes

### For Lenders
- 📝 **Item Listing** - Easy listing creation with image uploads
- ✅ **Rental Management** - Approve or reject rental requests
- 💰 **Payment Tracking** - Verify payments and manage refunds
- 📸 **Return Verification** - Review return photos before completing rentals
- 🏦 **Banking Integration** - Manage multiple bank accounts for payouts

### Admin Features
- 👥 **User Management** - Verify and manage user accounts
- 📦 **Item Approval** - Review and approve item listings
- 💼 **Rental Oversight** - Monitor all platform transactions
- 📈 **Statistics Dashboard** - Track platform metrics and performance
- 🎫 **Support Tickets** - Handle user inquiries and issues

## 🛠️ Tech Stack

### Frontend
- **HTML5** - Semantic markup and structure
- **CSS3** - Styling with Tailwind CSS
- **Tailwind CSS v3.3.0** - Utility-first CSS framework for rapid UI development
- **Vanilla JavaScript** - Client-side interactivity and API consumption
- **Responsive Design** - Mobile-first approach for all screen sizes

### Backend

- **MySQL** - Relational database management system## Development

- **mysql2 v3.15.1** - MySQL client for Node.js with Promise support

To run in development mode with auto-reload:

#### Authentication & Security
- **Node.js** - JavaScript runtime environment
- **Express.js v4.18.2** - Fast, minimalist web framework
- **RESTful API** - Clean API architecture for frontend-backend communication

### Database
- **MySQL v3.15.1** - Relational database management system
- **mysql2** - MySQL client for Node.js with Promise support

### Authentication & Security
- **JWT (jsonwebtoken v9.0.2)** - Secure token-based authentication
- **bcryptjs v2.4.3** - Password hashing and encryption
- **express-validator v7.0.1** - Server-side input validation
- **CORS v2.8.5** - Cross-Origin Resource Sharing middleware

### File Management
- **Multer v1.4.5-lts.1** - Multipart/form-data handling for file uploads
- **Base64 Encoding** - Image storage and retrieval

### Development Tools
- **Nodemon v3.0.1** - Auto-restart development server
- **dotenv v16.3.1** - Environment variable management
- **Git** - Version control system

### Architecture Patterns
- **MVC Pattern** - Model-View-Controller architecture
- **Middleware Chain** - Authentication and validation layers
- **RESTful Conventions** - Standard HTTP methods and status codes
- **JWT Authentication** - Stateless authentication mechanism

## 📁 Project Structure

```
nodeapp/
├── backend/
│   ├── config/
│   │   └── database.js          # MySQL database configuration
│   ├── controllers/             # Request handlers and business logic
│   │   ├── userController.js
│   │   ├── itemController.js
│   │   ├── rentalController.js
│   │   ├── paymentController.js
│   │   ├── chatController.js
│   │   ├── reviewController.js
│   │   ├── notificationController.js
│   │   ├── bankingController.js
│   │   └── supportController.js
│   ├── middleware/
│   │   └── auth.js              # JWT authentication middleware
│   ├── models/                  # Database models
│   │   ├── User.js
│   │   ├── Item.js
│   │   ├── Rental.js
│   │   ├── Review.js
│   │   └── Banking.js
│   ├── routes/                  # API route definitions
│   │   ├── userRoutes.js
│   │   ├── itemRoutes.js
│   │   ├── rentalRoutes.js
│   │   ├── paymentRoutes.js
│   │   ├── chatRoutes.js
│   │   ├── reviewRoutes.js
│   │   ├── notificationRoutes.js
│   │   ├── bankingRoutes.js
│   │   └── supportRoutes.js
│   ├── scripts/                 # Database migration and setup scripts
│   ├── package.json
│   └── server.js               # Backend entry point
├── public/                      # Frontend static files
│   ├── admin/                  # Admin panel pages
│   ├── *.html                  # User interface pages
│   ├── *.js                    # Frontend JavaScript
│   └── styles.css              # Compiled Tailwind CSS
├── assets/
│   └── images/                 # Static images
├── src/
│   └── input.css               # Tailwind CSS source
├── database/                   # SQL scripts
├── .env                        # Environment variables (not in repo)
├── .gitignore
├── LICENSE
├── package.json
├── tailwind.config.js
└── README.md
```

## 🚀 Getting Started

### Prerequisites

- **Node.js** (v14 or higher)
- **MySQL** (v5.7 or higher)
- **npm** or **yarn** package manager

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Swann-Htet/RentMate.git
   cd RentMate
   ```

2. **Install root dependencies**
   ```bash
   npm install
   ```

3. **Install backend dependencies**
   ```bash
   cd backend
   npm install
   cd ..
   ```

4. **Configure environment variables**
   
   Create a `.env` file in the `backend` directory:
   ```env
   # Server Configuration
   PORT=5000
   NODE_ENV=development

   # Database Configuration
   DB_HOST=localhost
   DB_USER=your_mysql_username
   DB_PASSWORD=your_mysql_password
   DB_NAME=rentmate_db
   DB_PORT=3306

   # JWT Configuration
   JWT_SECRET=your_super_secret_jwt_key_here
   JWT_EXPIRE=30d

   # File Upload Configuration
   MAX_FILE_SIZE=10485760
   ```

5. **Set up the database**
   ```bash
   cd backend
   npm run setup
   ```

6. **Build Tailwind CSS** (in a separate terminal)
   ```bash
   npm run build:css
   ```

7. **Start the development server**
   ```bash
   npm run dev
   ```

8. **Access the application**
   
   Open your browser and navigate to:
   - Frontend: `http://localhost:3000`
   - Backend API: `http://localhost:5000`

## 📝 API Endpoints

### Authentication
- `POST /api/users/register` - User registration
- `POST /api/users/login` - User login
- `GET /api/users/profile` - Get user profile (Protected)

### Items
- `GET /api/items` - Get all items
- `GET /api/items/:id` - Get single item
- `POST /api/items` - Create new item (Protected)
- `PUT /api/items/:id` - Update item (Protected)
- `DELETE /api/items/:id` - Delete item (Protected)

### Rentals
- `GET /api/rentals` - Get user rentals (Protected)
- `POST /api/rentals` - Create rental request (Protected)
- `PUT /api/rentals/:id/status` - Update rental status (Protected)
- `POST /api/rentals/:id/refund` - Process refund (Protected)

### Payments
- `POST /api/payments/upload` - Upload payment slip (Protected)
- `GET /api/payments/:rentalId` - Get payment details (Protected)

### Chat
- `GET /api/chat/conversations` - Get user conversations (Protected)
- `GET /api/chat/:conversationId` - Get messages (Protected)
- `POST /api/chat` - Send message (Protected)

### Reviews
- `GET /api/reviews/item/:itemId` - Get item reviews
- `POST /api/reviews` - Create review (Protected)

### Banking
- `GET /api/banking/accounts` - Get bank accounts (Protected)
- `POST /api/banking/accounts` - Add bank account (Protected)
- `PUT /api/banking/accounts/:id` - Update bank account (Protected)

## 🔒 Security Features

- **Password Hashing** - Bcrypt encryption for user passwords
- **JWT Authentication** - Secure token-based authentication
- **Input Validation** - Express-validator for request sanitization
- **CORS Protection** - Configured cross-origin resource sharing
- **SQL Injection Prevention** - Parameterized queries with mysql2
- **File Upload Restrictions** - Size and type validation

## 🎨 Key Workflows

### Rental Workflow
1. **Browse** → User finds desired camping equipment
2. **Request** → User submits rental request with dates
3. **Approval** → Owner reviews and approves/rejects request
4. **Payment** → Renter uploads payment slip
5. **Verification** → Owner verifies payment
6. **Pickup** → Rental period begins
7. **Return** → Renter uploads return photo
8. **Completion** → Owner confirms return and rental completes

### Payment & Refund Workflow
- Payment slip upload and verification
- Security deposit management
- Automated refund processing
- Multi-bank account support for lenders

## 🤝 Contributing

This is an academic project. If you'd like to contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Credits

**Project Client & Collaborator:**
- This project was developed as an academic collaboration. Special thanks to the client who provided the project requirements and feedback throughout the development process.

**Developer:**
- [Swann Htet](https://github.com/Swann-Htet)

## 📧 Contact

For inquiries or support, please open an issue in the GitHub repository.

## 🙏 Acknowledgments

- Built as an academic client project
- Inspired by modern sharing economy platforms
- Thanks to the open-source community for excellent tools and libraries

---

**Made with ❤️ for the camping community**
