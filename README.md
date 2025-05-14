# EventMint - USSD Event Ticketing System

A USSD-based event ticketing system that allows users to purchase event tickets and manage events using their mobile phones. Built with PHP and integrated with Africa's Talking for SMS notifications.

## Developers

- MASAGENSHO PACIFIQUE
- MBONIMPA ISHIMWE Theogene

## Features

- User registration and PIN setup
- Event ticket purchasing
- Mobile money integration for payments
- SMS notifications for ticket purchases
- Event organizer registration and management
- Balance checking and mobile money transfers

## Prerequisites

- PHP 7.4 or higher
- MySQL 5.7 or higher
- XAMPP/WAMP/LAMP server
- Composer for PHP dependency management
- Africa's Talking account for SMS functionality

## Installation

1. Open Command Prompt (CMD) and run the following commands to create your project:
   ```cmd
   :: Set working directory
   cd /d C:\xampp\htdocs

   :: Create a clean project folder
   mkdir merged_project
   cd merged_project

   :: Clone MASENGESHO PACIFIQUE's repo (core files) into temp_a
   git clone -b group-3-22RP03084-EVENTTICKETING https://github.com/pabon25/GROUP3-22RP03084-22RP01832-EVENTTICKETING.git temp_a

   :: Clone MBONIMPA ISHIMWE THEOGENE's repo (UI files) into temp_b
   git clone -b group-3-22RP01832-EVENTTICKETING https://github.com/M-I-Theogene/GROUP3-22RP03084-22RP01832-EVENTTICKETING.git temp_b

   :: Copy selected core files from MASENGESHO PACIFIQUE's repo
   copy temp_a\sms.php .
   copy temp_a\momo.php .
   copy temp_a\util.php .
   copy temp_a\composer.json .
   copy temp_a\composer.lock .

   :: Copy vendor directory from temp_a
   xcopy temp_a\vendor vendor /E /I /H

   :: Copy selected UI files from MBONIMPA ISHIMWE THEOGENE's repo
   copy temp_b\index.php .
   copy temp_b\menu.php .

   :: Delete temp folders
   rmdir /S /Q temp_a
   rmdir /S /Q temp_b
   ```

2. Install PHP dependencies:
   ```bash
   cd ticketing_ussd
   composer install
   ```

3. Create a MySQL database named 'even':
   ```sql
   CREATE DATABASE even;
   ```

4. Import the database schema from `DB/schema.sql`

5. Configure your Africa's Talking credentials in `util.php`:
   - Update `AT_USERNAME` and `AT_API_KEY` with your credentials
   - Update `SMS_SENDER` with your registered sender ID

## Usage

1. Start your XAMPP Apache server

2. Set up ngrok for creating a public URL:
   ```bash
   # Download and install ngrok from https://ngrok.com/download
   ngrok http 80
   ```
   This will give you a public URL like `https://xyz.ngrok.io`

3. Set up a USSD shortcode with Africa's Talking:
   - Log in to your Africa's Talking account
   - Create a new USSD channel
   - Set the callback URL to your ngrok URL + /ticketing_ussd/index.php
     Example: `https://xyz.ngrok.io/ticketing_ussd/index.php`

4. Users can now access the system by dialing the USSD code

5. Follow the on-screen prompts to:
   - Register as a user
   - Purchase tickets
   - Check balance
   - Transfer money
   - Manage events (for organizers)

Note: Remember that ngrok URLs change every time you restart ngrok. For production, use a permanent domain.

## Security

- User PINs are hashed using PHP's password_hash function
- Input sanitization is implemented to prevent SQL injection
- PDO prepared statements are used for database queries
- Transaction management ensures data consistency

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
