return {
    game = {
        combo = "COMBO %d!",
        demo = "DEMO",
        fps = "%d FPS",
        fps_warning = "Low framerate: disabling vsync might help",
        congratulations = "CONGRATULATIONS!",
        win_thanks = "Thank you for playing the demo",
        win_wishlist = "Wishlist on Steam :)",
        win_prompt = "[Pause to continue]",
    },
    gun = {
        machinegun = "pea gun",
        triple = "triple pepper",
        burst = "pollen burst",
        shotgun = "raspberry shotgun",
        minigun = "seed minigun",
        ring = "big berry",
        mushroom_cannon = "mushroom cannon",
    },
    upgrade = {
        tea = {
            title = "GREEN TEA",
            description = "+2 temporary ❤",
        },
        espresso = {
            title = "ESPRESSO",
            description = "x2 shooting speed for a minute", 
        },
        milk = {
            title = "MILK",
            description = "+1 permanent ❤",
        },
        peanut = {
            title = "PEANUT",
            description = "x2 maximum ammo",
        }
    },
    input = {
        prompts = {
            move = "Move",
            left = "Left",
            right = "Right",
            up = "Up",
            down = "Down",
            jump = "Jump",
            shoot = "Shoot",
            leave_game = "Leave",

            ui_left = "Menu left",
            ui_right = "Menu right",
            ui_up = "Menu up",
            ui_down = "Menu down",
            ui_select = "Confirm",
            ui_back = "Back",
            ui_reset_keys = "Clear keys",
            pause = "Pause",

            join = "Join",
            split_keyboard = "Split keyboard",
            unsplit_keyboard = "Unsplit keyboard",
        },
    },
    menu = {
        pause = {
            title = "PAUSE",
            resume = "RESUME",
            retry = "RETRY",
            options = "OPTIONS",
            credits = "CREDITS",
            feedback = "FEEDBACK",
            quit = "QUIT",
        },
        options = {
            title = "OPTIONS",

            input = {
                title = "Input",
                input = "INPUT SETTINGS...",
            },
            input_submenu = {
                title = "Input settings",
                reset_controls = "RESET CONTROLS",
                controller_button_style = "BUTTON STYLE",
                controller_button_style_value = {
                    detect = "detect",
                    switch = "Switch",
                    playstation4 = "PlayStation 4",
                    playstation5 = "PlayStation 5",
                    xbox = "Xbox",
                },
                deadzone = "JOYSTICK DEADZONE",
                vibration = "VIBRATION",
                low_deadzone_warning = "Low values may cause issues",
                note_deadzone = "Deadzone settings will be applied after leaving this menu",

                gameplay = "Gameplay",
                interface = "Interface",
                global = "Global",
                note_ui_min_button = "At least one binding is required",
                note_global_keyboard = "These bindings are the same for all keyboard players",
                note_global_controller = "These bindings are the same for all controllers",
                subtitle_no_player = "[⚠ NO PLAYER %d]",
                subtitle_no_controller = "[⚠ NO CONTROLLER CONNECTED]",

                keyboard = "Keyboard",
                keyboard_solo = "KEYBOARD (Default)",
                keyboard_p1 = "KEYBOARD (Split 1)",
                keyboard_p2 = "KEYBOARD (Split 2)",

                controller = "Controller",
                controller_p1 = "CONTROLLER (Player 1)",
                controller_p2 = "CONTROLLER (Player 2)",
                controller_p3 = "CONTROLLER (Player 3)",
                controller_p4 = "CONTROLLER (Player 4)",
            },
            audio = {
                title = "Audio",
                sound = "SOUND",
                volume = "VOLUME",
                music_volume = "MUSIC VOLUME",
                music_pause_menu = "MUSIC ON PAUSE MENU",
                background_sounds = "BACKGROUND_SOUNDS",
            },
            visuals = {
                title = "Visuals",
                fullscreen = "FULLSCREEN",
                pixel_scale = "PIXEL SCALE",
                pixel_scale_value = {
                    auto = "auto",
                    max_whole = "max whole",
                };
                vsync = "VERTICAL SYNC",
            },
            game = {
                title = "Gameplay",
                timer = "TIMER",
                mouse_visible = "SHOW MOUSE CURSOR",
                pause_on_unfocus = "PAUSE ON LOST FOCUS",
                screenshake = "SCREENSHAKE",
                show_fps_warning = "SHOW LOW FRAMERATE WARNING",

            }
        },
        feedback = {
            title = "FEEDBACK",
            bugs = "REPORT A BUG 🔗",
            features = "SUGGEST A FEATURE 🔗",
        },
        game_over = {
            title = "GAME OVER!",
            kills = "Kills",
            time = "Time",
            floor = "Floor",
            max_combo = "Max combo",
            continue = "CONTINUE",
        },
        win = {
            wishlist = "WISHLIST ON STEAM",
            continue = "CONTINUE",
            title = "CONGRATULATIONS!",
        },
        joystick_removed = {
            title = "CONTROLLER DISCONNECTED",
            description = "Please plug in the following controllers:",
            continue = "CONTINUE ANYWAY",
            item = "Player %d (%s)",
        },
        credits = {
            title = "CREDITS",
            game_by = "A game by",
            music_and_sound_design = "Music and sound design",
            playtesting = "Playtesting",
            special_thanks = "Special thanks",
            asset_creators = "Asset creators",
            licenses = "Asset & library licenses",

            asset_item = "%s by %s / %s", -- "THING by CREATOR / LICENCE"
        },
        open_source = {
            title = "Open source libraries",
        },
        see_more = "see more..."
    },
}