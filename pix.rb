require './src/conf'
require './src/engine/appstate/statemachine'
require './src/game/appstate/menu'

game = Engine::AppState::StateMachine

game.init Conf::WIDTH, Conf::HEIGHT
game.state = Game::AppState::Menu
game.loop
