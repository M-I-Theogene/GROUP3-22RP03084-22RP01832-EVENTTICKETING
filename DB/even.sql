-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 14, 2025 at 04:24 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `even`
--

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `organizer_id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `location` varchar(150) NOT NULL,
  `date` date NOT NULL,
  `price` int(11) NOT NULL,
  `total_tickets` int(11) NOT NULL DEFAULT 0,
  `tickets_sold` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `organizer_id`, `name`, `location`, `date`, `price`, `total_tickets`, `tickets_sold`, `created_at`) VALUES
(1, 1, 'DB', 'ARENA', '2025-05-24', 500, 2, 2, '2025-05-13 17:42:41'),
(2, 2, 'Ceremony', 'Arena', '2025-05-25', 2000, 200, 2, '2025-05-13 21:45:10');

-- --------------------------------------------------------

--
-- Table structure for table `organizers`
--

CREATE TABLE `organizers` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `brand_name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `organizers`
--

INSERT INTO `organizers` (`id`, `user_id`, `full_name`, `brand_name`, `phone`, `created_at`) VALUES
(1, 3, 'pacc', 'cypadi', '+250792453617', '2025-05-13 17:39:32'),
(2, 34, 'Pacifique', 'CY', '+250792359800', '2025-05-13 18:41:52'),
(3, 34, 'Pacifique', 'cypadi', '+250792359800', '2025-05-13 21:04:30');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `session_id` varchar(128) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `menu_state` text NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`session_id`, `phone_number`, `menu_state`, `updated_at`) VALUES
('', '', '', '2025-05-13 17:38:15'),
('ATUid_0ad5feb6c0022d0c397a20058bf7af36', '+250792359800', '1', '2025-05-13 21:42:13'),
('ATUid_0fd2e61d4c1391e2de6089e2b202111a', '+250790989830', '1*3*CY', '2025-05-13 19:18:55'),
('ATUid_1572df9c3806eabba9347d9ce0d63aa4', '+250792359800', 'Paccifique', '2025-05-13 17:59:54'),
('ATUid_175361d35f594bd1baa2ac3e22f68e94', '+250790989830', '1*3*CY', '2025-05-13 19:18:40'),
('ATUid_18ade3143aa009ff1ddbc35720e08539', '+250792359800', '3*1*Pacifique*CY', '2025-05-13 18:41:52'),
('ATUid_192a6c2b166b8685b78fc514339c27ad', '+250792359800', '1', '2025-05-13 21:04:41'),
('ATUid_1944ffa7938be4c3a37411c6913fb8be', '+250783672819', '', '2025-05-13 17:44:56'),
('ATUid_1cb4034207c51bd67bb547baded7d709', '+250792359800', '1*3*cypadi', '2025-05-13 21:04:30'),
('ATUid_278180ab919b219257871e7362d206a1', '+250792359800', '1*3', '2025-05-13 21:44:12'),
('ATUid_28b41b27118bc024d09df86b3734856d', '+250792359800', '1*1', '2025-05-13 19:12:48'),
('ATUid_2a438974de3d5d7c6000238a6db3285d', '+250792359800', '3', '2025-05-14 13:52:04'),
('ATUid_2d6d2f33243fd491e59a1fbe2535b125', '+250792453610', 'theo*1234', '2025-05-13 21:03:14'),
('ATUid_30819ad9a4d5bc563852eb13b230e6e9', '+250792359800', '3', '2025-05-13 18:41:26'),
('ATUid_3283abd401628ce0df8099fd69f3cbca', '+250792453617', '3*1*Birthday*Kigali Arena*2025-05-25', '2025-05-13 17:42:00'),
('ATUid_3384de7bb91cb5137e7c37615cc00ed5', '+250792359800', '1*1*1', '2025-05-13 17:46:53'),
('ATUid_39bf5a68e5bd66ed0a58349f58373e2b', '+250792359800', 'Pacifique*1234', '2025-05-13 19:00:09'),
('ATUid_3f51fcfd8f134acb429e37fd331b7f58', '+250792359800', '', '2025-05-13 18:26:37'),
('ATUid_3f60024c8d201a4e2144c93e398c9b74', '+250789033570', '', '2025-05-14 13:53:06'),
('ATUid_41389c516a94b9fd70bd3b50bcb573d4', '+250792453617', '2*9', '2025-05-13 17:39:13'),
('ATUid_453e8238a3c984884883baf43db4e066', '+250790989830', 'Mathias*1234', '2025-05-13 19:16:39'),
('ATUid_4667897e9f06160aa4f53545f4ec8386', '+250790989830', '', '2025-05-13 21:02:13'),
('ATUid_48fa67dfa688b6bc620a6c5190cb16fc', '+250792359800', '3', '2025-05-13 21:39:58'),
('ATUid_4934551a0587473d4b5a360440494a64', '+250792359800', '1*1', '2025-05-13 19:00:37'),
('ATUid_4b3923ee3e2312b207bd43dbb903bb84', '+250792359800', '', '2025-05-14 13:51:43'),
('ATUid_4e0c4a0562b48a306998822d48573113', '+250792359800', '', '2025-05-13 18:26:00'),
('ATUid_50289257c5b6c9a27a1ca9c24165beee', '+250789033570', '', '2025-05-14 13:52:56'),
('ATUid_5291cb4de02619bfb8a29e8f87e27162', '+250792359800', '1*3*1*Ceremony*2025-05-25*Arena*2000*200', '2025-05-13 21:45:10'),
('ATUid_55f57d78e83cb5b74cbe09e328ef3d9e', '+250790989830', '1*3*CCYPADI', '2025-05-13 19:18:24'),
('ATUid_58a3780daa37fe807454bebee4846392', '+250792359800', '', '2025-05-14 13:51:35'),
('ATUid_5c44e875c0da702f6c84b46038aba03c', '+250792359800', '3', '2025-05-13 21:42:30'),
('ATUid_664d921e4b7bd9978e8ba1220f02fe8f', '+250790989830', '1*3*CYPADI Ltd', '2025-05-13 19:18:05'),
('ATUid_688bc997ebc03108e0ba44235eaaeaec', '+250792453617', '3*1*pacc*cypadi', '2025-05-13 17:39:32'),
('ATUid_6c46893261bee7a4669356a8ea68c11d', '+250789033570', 'PAX', '2025-05-14 13:52:43'),
('ATUid_6f59e437077a145b1df80bcc17014c68', '+250783672819', '', '2025-05-13 17:44:56'),
('ATUid_6fcf87cae760d91de75831a22f6db861', '+250792359800', '3', '2025-05-13 19:02:27'),
('ATUid_72ad46122ae5b4ce20b9d25f04b0ee6a', '+250792359800', '', '2025-05-13 21:42:45'),
('ATUid_74666db999468917d432eae0ea381864', '+250792359800', '2*1', '2025-05-13 19:13:05'),
('ATUid_79228ef885244d871b46ebce6ed7343a', '+250792359800', '1*1', '2025-05-13 21:52:43'),
('ATUid_7ac26f1dbbc96b45f36d99d552d3a1da', '+250792359800', '1', '2025-05-13 18:41:18'),
('ATUid_7b693d47f08f233e88fe40eb0a907913', '+250792453617', '3*1*DB*ARENA*2025-05-24*500*2*1', '2025-05-13 17:42:41'),
('ATUid_7d4e9e13613d8b2eac6463348e9a27c6', '+250792359800', '', '2025-05-13 21:04:03'),
('ATUid_83c018bbf9e7cb716538d72b861d9e5d', '+250792359800', '1', '2025-05-13 17:23:24'),
('ATUid_85dee63c97b633d3c96343141b00906e', '+250792359800', 'pacifique', '2025-05-13 18:00:10'),
('ATUid_8cec566785a1025d5e0d32eb98e40adc', '+250792359800', '1*98', '2025-05-13 19:03:11'),
('ATUid_907f4f49e2c34d9ab294affbfdb28220', '+250792359800', '', '2025-05-13 17:46:42'),
('ATUid_93ff8d09d9fcaf54e0649d9054ba38b6', '+250790989830', '2*1', '2025-05-13 19:17:18'),
('ATUid_95f9362ed9c7312d38e2a1bb4804ae27', '+250792359800', '1*3*1*bd*2025-05-25*arena', '2025-05-13 21:41:57'),
('ATUid_9babd51dae904edc876323b42b1dbd61', '+250792359800', '', '2025-05-13 19:00:41'),
('ATUid_9dd594bd175eb89cb0961bc7e6da131f', '+250792359800', '', '2025-05-13 18:26:03'),
('ATUid_9eacc0b2b2791fffd6842c30aba58acf', '+250792359800', '', '2025-05-13 17:46:42'),
('ATUid_a46262fcf419fe8f4913504d01b9c29e', '+250790989830', '', '2025-05-13 19:17:29'),
('ATUid_a60dddc26d3d78ba83992588c24f5ffb', '+250792453617', '', '2025-05-13 17:38:53'),
('ATUid_a80522060619c87c4082b2c5efdd98d0', '+250792359800', '', '2025-05-13 21:42:35'),
('ATUid_af014a0116de77c1509fa141d3dbb573', '+250792453617', '1*1*1', '2025-05-13 17:43:10'),
('ATUid_b408a6f50bd7f4953e9274fc0894ceed', '+250792359800', '', '2025-05-13 21:40:13'),
('ATUid_b52f1791d6a50b8ae782678e8a0c33c3', '+250790989830', '1', '2025-05-13 21:01:50'),
('ATUid_bd4ac5c1b15d203a9f0628bdcaa5f07b', '+250792359800', '3', '2025-05-13 17:22:58'),
('ATUid_be77a17e0ead405f27e0e4fd7d70e464', '+250783672819', '', '2025-05-13 17:44:56'),
('ATUid_c089d1b9485e0d6e6a7967cb9c00f534', '+250783672819', '1*1*1*1234', '2025-05-13 21:54:19'),
('ATUid_c2a2ab5d2d8ad166b8e4168428c65c99', '+250792359800', '3', '2025-05-13 19:11:38'),
('ATUid_c45cf7781f987b2c66f8b66851b37347', '+250783672819', 'ISHIMWE*1234', '2025-05-13 21:53:50'),
('ATUid_c9b0e29c2eb1dd883ca1f0f06b0d5458', '+250792359800', '1*1*1*1234', '2025-05-13 21:46:38'),
('ATUid_d0595256b3bd40801fcfe3d2aefbe822', '+250792359800', '', '2025-05-13 17:23:03'),
('ATUid_d8740012c69e2fa8a9721da52ed07dc2', '+250792359800', '2*2*+250792453617*10000', '2025-05-13 19:14:16'),
('ATUid_db9b1aaedd2f9a119db7556058c7ae1a', '+250792359800', '2', '2025-05-13 17:23:16'),
('ATUid_ddeecfb7d8ff439e9ac76a6658351519', '+250792359800', '2*1', '2025-05-13 19:02:48'),
('ATUid_de6ef86fe92588d4724fbc00735344b2', '+250790989830', '1*1', '2025-05-13 21:02:08'),
('ATUid_e1c66caf9af9e2d4ecf864bb1f15a1b2', '+250792359800', '3', '2025-05-13 19:15:09'),
('ATUid_e55014b7211fd68a5a11915018a2edaa', '+250792359800', '', '2025-05-13 21:45:59'),
('ATUid_ea99a66e2c9a0262423deef817c8894a', '+250790989830', '3', '2025-05-13 21:01:29'),
('ATUid_f05cd93b1d4bd8672fd16231b6fbd809', '+250792359800', '1', '2025-05-13 17:23:31'),
('ATUid_f0844ced65e29691a45e8999835698a0', '+250792359800', '2*1*1234', '2025-05-13 21:40:39'),
('ATUid_f53c20e62a899afe80bf3944007fb3e0', '+250792359800', '1*3', '2025-05-13 19:12:28'),
('ATUid_ffaecf7fd7010a91ff63d8be1df80118', '+250792359800', '1', '2025-05-13 17:47:29');

-- --------------------------------------------------------

--
-- Table structure for table `tickets`
--

CREATE TABLE `tickets` (
  `id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `total` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tickets`
--

INSERT INTO `tickets` (`id`, `event_id`, `user_id`, `quantity`, `total`, `created_at`) VALUES
(1, 1, 3, 1, 500, '2025-05-13 17:43:10'),
(2, 1, 34, 1, 500, '2025-05-13 17:46:53'),
(3, 2, 34, 0, 2000, '2025-05-13 21:46:38'),
(4, 2, 31, 0, 2000, '2025-05-13 21:54:19');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `reference` varchar(50) NOT NULL,
  `user_phone` varchar(20) NOT NULL,
  `amount` int(11) NOT NULL,
  `type` enum('send') NOT NULL DEFAULT 'send',
  `status` enum('completed','failed') NOT NULL DEFAULT 'completed',
  `fee` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `reference`, `user_phone`, `amount`, `type`, `status`, `fee`, `created_at`) VALUES
(1, 'TX-682384ae93206', '+250792453617', 500, 'send', 'completed', 0, '2025-05-13 17:43:10'),
(2, 'TX-6823858da2c99', '+250792359800', 500, 'send', 'completed', 0, '2025-05-13 17:46:53'),
(3, 'TX-68239a08ee794', '+250792359800', 10000, 'send', 'completed', 200, '2025-05-13 19:14:16'),
(4, 'TX-6823bdbe3a994', '+250792359800', 2000, 'send', 'completed', 200, '2025-05-13 21:46:38'),
(5, 'EVENTMINT-6823bf8bb98c5', '+250783672819', 2000, 'send', 'completed', 200, '2025-05-13 21:54:19');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `pin_hash` varchar(255) DEFAULT NULL,
  `balance` int(11) NOT NULL DEFAULT 0,
  `role` enum('user','organizer') NOT NULL DEFAULT 'user',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `phone_number`, `full_name`, `pin_hash`, `balance`, `role`, `created_at`) VALUES
(3, '+250792453617', NULL, NULL, 60500, 'organizer', '2025-05-13 17:38:53'),
(31, '+250783672819', 'ISHIMWE', '$2y$10$99GY9HhbRhO9F0SLBrE.guVYCKgm8X9ZX5nbxypkcu2N6btGasJ..', 47800, 'user', '2025-05-13 17:44:56'),
(34, '+250792359800', 'Pacifique', '$2y$10$6bcoclQJglmklDvi75hGXeLqxgcF38N8xFSU5k2Slp9PojqVE0zQu', 30900, 'organizer', '2025-05-13 17:46:35'),
(58, '+250790989830', 'Mathias', '$2y$10$ZOUskvDorxbMq95oMVk7POaUa4x8wHqMxtst6RzgiuQ5soyokL5dG', 50000, 'organizer', '2025-05-13 19:16:23'),
(59, '+250792453610', 'theo', '$2y$10$a1Sj2BQeqQJe87dY5bMa.OHit.dV73XBJADxhLWukg15q3WDJw2Nu', 50000, 'user', '2025-05-13 21:02:58'),
(60, '', NULL, NULL, 50000, 'user', '2025-05-14 13:51:07'),
(61, '+250789033570', 'PAX', NULL, 50000, 'user', '2025-05-14 13:52:27');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_events_organizer_id` (`organizer_id`);

--
-- Indexes for table `organizers`
--
ALTER TABLE `organizers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_organizers_user_id` (`user_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`session_id`);

--
-- Indexes for table `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tickets_event_id` (`event_id`),
  ADD KEY `idx_tickets_user_id` (`user_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reference` (`reference`),
  ADD KEY `idx_transactions_user_phone` (`user_phone`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `phone_number` (`phone_number`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `organizers`
--
ALTER TABLE `organizers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `fk_events_organizer` FOREIGN KEY (`organizer_id`) REFERENCES `organizers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `organizers`
--
ALTER TABLE `organizers`
  ADD CONSTRAINT `fk_organizers_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tickets`
--
ALTER TABLE `tickets`
  ADD CONSTRAINT `fk_tickets_event` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tickets_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
