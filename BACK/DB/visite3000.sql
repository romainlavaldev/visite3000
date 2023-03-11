-- phpMyAdmin SQL Dump
-- version 5.2.1-1.fc37
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : sam. 11 mars 2023 à 13:18
-- Version du serveur : 10.5.18-MariaDB
-- Version de PHP : 8.1.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `visite3000`
--

-- --------------------------------------------------------

--
-- Structure de la table `cards`
--

CREATE TABLE `cards` (
  `id` int(11) NOT NULL,
  `phone` int(11) DEFAULT NULL,
  `mail` int(11) DEFAULT NULL,
  `role` int(11) DEFAULT NULL,
  `ownerId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `cards`
--

INSERT INTO `cards` (`id`, `phone`, `mail`, `role`, `ownerId`) VALUES
(1, NULL, NULL, NULL, 1),
(2, NULL, NULL, NULL, 1),
(3, NULL, NULL, NULL, 2),
(4, NULL, NULL, NULL, 3),
(5, NULL, NULL, NULL, 3);

-- --------------------------------------------------------

--
-- Structure de la table `gameScores`
--

CREATE TABLE `gameScores` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `time` int(11) NOT NULL,
  `displayTime` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Structure de la table `userCards`
--

CREATE TABLE `userCards` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `cardId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `userCards`
--

INSERT INTO `userCards` (`id`, `userId`, `cardId`) VALUES
(1, 3, 1),
(2, 3, 2),
(3, 3, 3),
(4, 3, 5),
(5, 1, 4);

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `token` varchar(75) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `firstname`, `lastname`, `token`) VALUES
(1, 'rlaval', 'romain', 'Romain', 'Laval', '1af57de4f-bc2b-11'),
(2, 'jbeuvier', 'jules', 'Jules', 'Beuvier', NULL),
(3, 'dev', 'dev', 'dev', 'dev', '39c1ca641-bc2b-11');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `cards`
--
ALTER TABLE `cards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `foreign_cards_ownerId` (`ownerId`);

--
-- Index pour la table `gameScores`
--
ALTER TABLE `gameScores`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `userCards`
--
ALTER TABLE `userCards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `foreign_userCards_userId` (`userId`),
  ADD KEY `foreign_userCards_cardId` (`cardId`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `cards`
--
ALTER TABLE `cards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `gameScores`
--
ALTER TABLE `gameScores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `userCards`
--
ALTER TABLE `userCards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `cards`
--
ALTER TABLE `cards`
  ADD CONSTRAINT `foreign_cards_ownerId` FOREIGN KEY (`ownerId`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `userCards`
--
ALTER TABLE `userCards`
  ADD CONSTRAINT `foreign_userCards_cardId` FOREIGN KEY (`cardId`) REFERENCES `cards` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `foreign_userCards_userId` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
