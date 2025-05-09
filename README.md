# GameAutoMakeServer

A Rails application that provides an API for game design and development automation. GameAutoMakeServer is a platform for AI-assisted game creation, compilation, and publishing.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [APIs](#apis)
- [Platform Support](#platform-support)
- [Development Guide](#development-guide)
- [Contributing](#contributing)

## Overview

GameAutoMakeServer enables users to:
- Create game projects with AI assistance
- Compile games into different formats (HTML, WebGL)
- Publish games and track scores

The platform serves as the backend for [QuickPlayArcade](https://github.com/kd-research/QuickPlayArcade) and provides APIs for game design, customization, and score tracking.

## Features

### AI-Assisted Game Creation
The system uses AI to help users create games through:
- Chat conversations with AI consultants
- Game generation with AI developers

### Game Compilation
Games can be compiled into different formats:
- HTML games (standard, stable, nightly, demo)
- Future support for WebGL games

### Game Customization Service
The platform includes a powerful Game Customization Service that provides AI-powered capabilities to modify existing HTML games or generate new ones based on natural language requests. This service follows a multi-stage pipeline:

1. Game Design Document Reconstruction
2. HTML5 Game Modification Export  
3. Theme Design Generation
4. Game Icon Prompt Generation
5. Game Icon Generation (using DALL-E)

### Score Tracking
The platform includes a scoring system for published games:
- Tracks scores across different client terminals
- Maintains leaderboards for games

## Architecture

### Core Models

The application is built around several key data models:
- **User**: Handles authentication, authorization, and manages user profiles
- **GameProject**: Central entity for game creation, connects to conversations for AI assistance
- **GameCompile**: Transforms game specifications into playable games
- **Conversation/Dialog**: Enable AI-assisted game design through structured interactions
- **HtmlGameCompile**: Specific compilation type for HTML games
- **PublishedGame**: Manages game publishing
- **ScoreBoardScore**: Tracks game scores and maintains leaderboards

### Project Structure

#### Models
- `app/models/`: Contains all data models
- `app/models/concerns/`: Shared model behaviors
- `app/models/game_project.rb`: Game project model
- `app/models/user.rb`: User model
- `app/models/current.rb`: Current user context

#### Controllers
- `app/controllers/`: Contains all controllers
- `app/controllers/published_games_controller.rb`: Manages published games

#### Views
- `app/views/`: Contains all view templates
- `app/views/game_projects/`: Game project views
- `app/views/dialogs/`: Dialog views

#### Database
- `db/migrate/`: Database migration files
- `db/schema.rb`: Database schema

#### Configuration
- `config/`: Application configuration
- `config/environments/`: Environment-specific configurations

#### Libraries
- `lib/`: Custom libraries and modules
- `lib/patch_platform.rb`: Platform-specific patches

## APIs

### Quick Play Arcade API

The Quick Play Arcade API is built using the Grape framework and is mounted at the root path with a `/v1` prefix. The API interacts with several key data models including `ClientTerminal`, `ScoreBoard::Score`, and `PublishedGame`.

#### Key API Endpoints

##### Device Registration
- `GET /v1/register_device`: Registers a new device and returns a token for subsequent API calls

##### Score Management
- `GET /v1/top_scores/:game_id`: Retrieves the top 10 scores for a specific game
- `POST /v1/device/upload_score`: Records a new score for a game from a specific device
- `POST /v1/device/scores`: Retrieves a device's personal scores for a specific game

##### Game Customization
- `POST /v1/customize_game`: Modifies an existing game based on a natural language request
- `POST /v1/generate_game`: Creates a new game based on a natural language request

## Platform Support

### Android Integration

GameAutoMakeServer provides comprehensive Android integration for deploying HTML games to Android devices with features for content management, game patching, score tracking, and customization.

#### Hot Patch Games System

The Android::HotPatchGame model allows HTML games to be packaged and deployed to Android devices with the ability to update them without requiring a full app update through app stores.

##### Model Structure
- **Name**: The game's display name
- **Icon**: The game's app icon (attached file)
- **Splash**: Optional splash screen image (attached file)
- **HTML**: The game's HTML content (attached file)
- **Groups**: Comma-separated list of groups/tags associated with the game

##### Management Workflow
Hot patch games follow a workflow that includes creation, review, and publication:
- **Creation**: Games can be created by admins or regular users
- **Review Status**: Non-admin uploads are marked as pending-review
- **Approval**: Admins can review and approve games by removing the pending-review tag

#### Platform API

The Android integration includes a JavaScript API called Platform that is injected into HTML games to provide a bridge between the game and Android-specific functionality:

| Method | Return Type | Description |
|--------|------------|-------------|
| majorVersion() | number | Returns the platform API major version (currently 1) |
| minorVersion() | number | Returns the platform API minor version |
| setHighestScore(score) | void | Saves the highest score for the current game |
| getHighestScore() | number | Gets the previously saved highest score |
| getSoundVolume() | number | Gets the device sound volume setting (0-100) |
| getProferredDifficulty() | number | Gets the player's preferred difficulty (0=easy, 1=medium, 2=hard, 3=no preference) |

#### Patching Process

The PatchPlatform injects the Platform API into HTML games through these steps:
1. Parse HTML with Nokogiri
2. Inject Platform API script
3. Add version compatibility check
4. Return patched HTML file

#### Android Service Testing

The system includes a testing interface for Android-specific services:
- Upload an HTML game file
- Provide a natural language request for changes
- Specify a system prompt and AI model
- Submit for processing and receive a customized game

This allows testing how game customization will work in the Android environment without deploying to actual devices.

### Patch Platform Integration

The PatchPlatform service allows for patching HTML games to include platform-specific functionality:
- Modifies HTML games for compatibility with different platforms
- Includes JavaScript stubs for platform integration (like score tracking)
- Prepares games for deployment to Android devices

## Development Guide

### Development Requirements

- Ruby 3.3.7
- Node.js 22.2.0
- Yarn 1.22.22
- Redis 7.2.5
- PostgreSQL

### Before First Time Running

- Install the gems with `bundle install`
- Install the node modules with `yarn install`
- Set up the database with `bin/rails db:setup`

### Development with VS Code Dev Containers

This project supports development using VS Code Dev Containers, which provides a consistent development environment across different machines.

#### Setup Instructions

1. Install [VS Code](https://code.visualstudio.com/) and the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Clone this repository to your local machine
3. Open the project folder in VS Code
4. When prompted to "Reopen in Container", click "Reopen in Container", or use the command palette (F1) and select "Dev Containers: Reopen in Container"
5. VS Code will build the development container and configure the environment according to the specifications in `.devcontainer/devcontainer.json`
6. Once the container is ready, you'll have a full development environment with all dependencies installed

The dev container automatically:
- Installs Ruby 3.3 and required gems
- Sets up Node.js and Yarn
- Configures Redis server
- Forwards port 3000 for web access

### Running the Application

#### Using the Development Container Terminal

Once inside the development container:

1. Start the Rails server:
   ```
   bin/rails server -b 0.0.0.0
   ```

2. Or use the development Procfile to start both the Rails server and any background processes:
   ```
   bin/dev
   ```

The application will be available at `http://localhost:3000`

#### Using Docker

You can also run the application using Docker with the included Dockerfile:

1. Build the Docker image:
   ```
   docker build -t game-auto-make-server .
   ```

2. Run the container:
   ```
   docker run -p 3000:3000 -e POSTGRES_HOST=your_postgres_host -e RAILS_MASTER_KEY=your_master_key game-auto-make-server
   ```

For production deployments, make sure to:
- Set appropriate environment variables
- Configure a database
- Set the `RAILS_MASTER_KEY` environment variable

### Testing

Run the test suite with:
```
bin/rails test
```

## Contributing

We welcome contributions to the GameAutoMakeServer project. Please follow these guidelines:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request 