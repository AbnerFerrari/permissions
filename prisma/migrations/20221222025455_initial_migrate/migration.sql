-- CreateTable
CREATE TABLE `users` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,

    UNIQUE INDEX `users_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `clients` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,

    UNIQUE INDEX `clients_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `client_users` (
    `userId` INTEGER NOT NULL,
    `clientId` INTEGER NOT NULL,

    PRIMARY KEY (`userId`, `clientId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `roles` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL,

    UNIQUE INDEX `roles_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `user_roles` (
    `userId` INTEGER NOT NULL,
    `roleId` INTEGER NOT NULL,

    PRIMARY KEY (`userId`, `roleId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `client_realtors` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `clientId` INTEGER NOT NULL,
    `userId` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `client_enterprises` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `clientId` INTEGER NOT NULL,
    `name` VARCHAR(191) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `client_enterprise_realtors` (
    `clientEnterpriseId` INTEGER NOT NULL,
    `clientRealtorId` INTEGER NOT NULL,

    PRIMARY KEY (`clientEnterpriseId`, `clientRealtorId`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `client_users` ADD CONSTRAINT `client_users_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `client_users` ADD CONSTRAINT `client_users_clientId_fkey` FOREIGN KEY (`clientId`) REFERENCES `clients`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `user_roles` ADD CONSTRAINT `user_roles_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `user_roles` ADD CONSTRAINT `user_roles_roleId_fkey` FOREIGN KEY (`roleId`) REFERENCES `roles`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `client_realtors` ADD CONSTRAINT `client_realtors_clientId_fkey` FOREIGN KEY (`clientId`) REFERENCES `clients`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `client_realtors` ADD CONSTRAINT `client_realtors_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `client_enterprises` ADD CONSTRAINT `client_enterprises_clientId_fkey` FOREIGN KEY (`clientId`) REFERENCES `clients`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `client_enterprise_realtors` ADD CONSTRAINT `client_enterprise_realtors_clientEnterpriseId_fkey` FOREIGN KEY (`clientEnterpriseId`) REFERENCES `client_enterprises`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `client_enterprise_realtors` ADD CONSTRAINT `client_enterprise_realtors_clientRealtorId_fkey` FOREIGN KEY (`clientRealtorId`) REFERENCES `client_realtors`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

INSERT INTO playground.users (name) VALUES
	 ('Abner'),
	 ('Andrei');

INSERT INTO playground.clients (name) VALUES
	 ('Construtora X'),
	 ('Construtora Y');

INSERT INTO playground.roles (name) VALUES
	 ('Admin'),
	 ('Corretor');

INSERT INTO playground.user_roles (userId,roleId) VALUES
	 (1,1),
	 (1,2),
	 (2,2);

INSERT INTO playground.client_realtors (clientId,userId) VALUES
	 (1,1),
	 (2,2);

INSERT INTO playground.client_users (userId,clientId) VALUES
	 (1,1),
	 (2,2);

INSERT INTO playground.client_enterprises (clientId,name) VALUES
	 (1,'Empreendimento 1'),
	 (1,'Empreendimento 2'),
	 (2,'Empreendimento 3'),
	 (2,'Empreendimento 4');

INSERT INTO playground.client_enterprise_realtors (clientEnterpriseId,clientRealtorId) VALUES
	 (1,1),
	 (2,1),
	 (3,2),
	 (4,2);

