import random
from datetime import datetime
import json

ID_LENGTH = 5

ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

class Player:

    def __init__(self):
        self.score = 0
        #self.pressed_time = None if not has_pressed else datetime.now()
        self.pressed_time = None


class GameState:

    def __init__(self):
        self.players = {}
        self.presser = None

    def add_player(self):
        name = _generate_name(self.players)
        self.players[name] = Player()
        return name

    def get_player_score(self, name):
        if self.presser == name:
            old_press_time = self.players[self.presser].pressed_time
            added_score = datetime.now() - old_press_time

            score = self.players[name].score + added_score.seconds
        else:
            score = self.players[name].score

        return score

    def get_player_state(self, name):
        #return self.players[name].has_pressed
        return self.presser == name

    def player_push(self, name):
        # Recalculate the score of the last presser
        if self.presser != None:
            old_press_time = self.players[self.presser].pressed_time
            added_score = datetime.now() - old_press_time

            self.players[self.presser].score += added_score.seconds


        self.presser = name
        self.players[name].pressed_time = datetime.now()
        return True


def handle_request(request, game_state):
    parsed = json.loads(request)
    try:
        action = parsed['action']
    except KeyError:
        raise TypeError('Invalid request! No action key!')
    if action == 'new':
        return _new_player(game_state)
    elif action == 'get':
        return _get_state(parsed['id'], game_state)
    elif action == 'score':
        return _get_score(parsed['id'], game_state)
    elif action == 'push':
        return _push(parsed['id'], game_state)
    else:
        raise TypeError('Invalid action \'{}\''.format(action))


def _new_player(game_state):
    return json.dumps({'id': game_state.add_player()})


def _get_score(name, game_state):
    return json.dumps({'score': game_state.get_player_score(name)})


def _get_state(name, game_state):
    return json.dumps({'state': game_state.get_player_state(name)})


def _push(name, game_state):
    return json.dumps({'success': game_state.player_push(name)})


def _generate_name(players):
    result = ""
    for i in range(ID_LENGTH):
        result += ALPHABET[random.randint(0, len(ALPHABET) - 1)]
    return result

