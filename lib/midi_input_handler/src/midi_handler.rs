use midi_control::*;
use midir::*;
use std::sync::mpsc::{channel, Receiver, Sender};
use std::thread;

#[allow(dead_code)]
pub const FRENCH_NOTE_TABLE: [&str; 12] = [
    "do", "do#", "re", "re#", "mi", "fa", "fa#", "sol", "sol#", "la", "la#", "si",
];
pub const ENGLISH_NOTE_TABLE: [&str; 12] = [
    "C", "C#", "D", "D#", "E", "F", "F#", "F", "F#", "A", "A#", "B",
];

pub struct Note {
    pub oct: u8,
    pub note: u8,
    pub velocity: u8,

    pub channel: Channel,
}
impl Note {
    pub fn from(key: KeyEvent, channel: Channel) -> Self {
        Note {
            oct: key.key / 12,
            note: key.key % 12,
            velocity: key.value,
            channel,
        }
    }

    fn to_string(&self) -> String {
        format!(
            "{}-{}",
            ENGLISH_NOTE_TABLE[usize::from(self.note)],
            self.oct
        )
    }
    #[allow(dead_code)]
    pub fn get_channel_num(&self) -> u8 {
        match self.channel {
            Channel::Ch1 => 1,
            Channel::Ch2 => 2,
            Channel::Ch3 => 3,
            Channel::Ch4 => 4,
            Channel::Ch5 => 5,
            Channel::Ch6 => 6,
            Channel::Ch7 => 7,
            Channel::Ch8 => 8,
            Channel::Ch9 => 9,
            Channel::Ch10 => 10,
            Channel::Ch11 => 11,
            Channel::Ch12 => 12,
            Channel::Ch13 => 13,
            Channel::Ch14 => 14,
            Channel::Ch15 => 15,
            Channel::Ch16 => 16,
            Channel::Invalid => 0,
        }
    }
}

#[allow(dead_code)]
pub struct MidiValue {
    pub value: i16,
    pub key: u8,
    pub channel: Channel,
}
impl MidiValue {
    #[allow(dead_code)]
    pub fn to_string(&self) -> String {
        format!("{}-{}-{:?}", self.value, self.key, self.channel)
    }
    #[allow(dead_code)]
    pub fn get_channel_num(&self) -> u8 {
        match self.channel {
            Channel::Ch1 => 1,
            Channel::Ch2 => 2,
            Channel::Ch3 => 3,
            Channel::Ch4 => 4,
            Channel::Ch5 => 5,
            Channel::Ch6 => 6,
            Channel::Ch7 => 7,
            Channel::Ch8 => 8,
            Channel::Ch9 => 9,
            Channel::Ch10 => 10,
            Channel::Ch11 => 11,
            Channel::Ch12 => 12,
            Channel::Ch13 => 13,
            Channel::Ch14 => 14,
            Channel::Ch15 => 15,
            Channel::Ch16 => 16,
            Channel::Invalid => 0,
        }
    }
}

#[allow(dead_code)]

pub enum MidiInputPressed {
    Note(Note),
    JoystickX(MidiValue),
    JoystickY(MidiValue),
    Knob(MidiValue),
    Unknow(u16),
    None,
}

impl MidiInputPressed {
    #[allow(dead_code)]
    pub fn get_input_name(&self) -> String {
        match self {
            Self::None => "None".to_string(),
            Self::Note(note) => note.to_string(),
            Self::JoystickX(val) => val.to_string(),
            Self::JoystickY(val) => val.to_string(),
            Self::Knob(val) => val.to_string(),
            Self::Unknow(val) => format!("{:x}", val),
        }
    }
}

fn callback(_timestamp: u64, data: &[u8], sender: &mut Sender<MidiInputPressed>) {
    let message = MidiMessage::from(data);
    #[cfg(debug_assertions)]
    print!("\nreceived midi data  -> {:?}", data);
    match message {
        MidiMessage::NoteOn(channel, key) => {
            let note: Note = Note::from(key, channel);
            #[cfg(debug_assertions)]
            println!("{} on channel : {channel:?} ", note.to_string());
        }
        MidiMessage::NoteOff(channel, key) => {
            let note: Note = Note::from(key, channel);
            #[cfg(debug_assertions)]
            println!("{} on channel : {channel:?} ", note.to_string());
            sender.send(MidiInputPressed::Note(note)).unwrap(); //TODO HANDLE UNWRAP !!
        }

        MidiMessage::PitchBend(channel, x, y) => {
            #[cfg(debug_assertions)]
            println!("pitch bend : ({x},{y}) on channel : {channel:?}");
            let axis = MidiValue {
                value: -1 * i16::from(y) * 2,
                key: 0,
                channel,
            };
            sender.send(MidiInputPressed::JoystickX(axis)).unwrap(); //TODO HANDLE UNWRAP !!
        }

        MidiMessage::PolyKeyPressure(channel, key) => {
            #[cfg(debug_assertions)]
            println!(
                "polykey pressure : ({:?}) on channel : {channel:?}",
                key.key
            );
            let axis = MidiValue {
                value: i16::from(key.value),
                key: key.key,
                channel,
            };
            sender.send(MidiInputPressed::JoystickX(axis)).unwrap(); //TODO HANDLE UNWRAP !!
        }

        MidiMessage::ControlChange(channel, controle) => {
            #[cfg(debug_assertions)]
            println!(
                "control change : ({:?}) -> ({:?}) on channel : {channel:?}",
                controle.control, controle.value
            );
            let knob = MidiValue {
                value: i16::from(controle.value),
                key: controle.control,
                channel,
            };
            sender.send(MidiInputPressed::Knob(knob)).unwrap(); //TODO HANDLE UNWRAP !!
        }

        _ => {
            #[cfg(debug_assertions)]
            println!("unknow message received ! data : {:?}", data);
            let mut val: u16 = 0;
            for (i, n) in (0_u8..).zip(data.iter()) {
                val += u16::from(*n) << (8 * i);
            }
            sender.send(MidiInputPressed::Unknow(val)).unwrap(); //TODO HANDLE UNWRAP !!
        }
    }
}

pub fn init() -> Receiver<MidiInputPressed> {
    //initialisation

    let (sender, receiver) =  channel::<MidiInputPressed>();
    thread::spawn(move || {
        let sender = sender.clone();
        let midi_input: MidiInput = match MidiInput::new("input") {
            Ok(result) => result,
            Err(e) => panic!("{}", e),
        };

        //conection
        let ports_nb = midi_input.port_count();
        println!("{} ports avalaibles", ports_nb);
        let _connection_number = 0;

        let mut connections: Vec<MidiInputConnection<Sender<MidiInputPressed>>> =
            init_connections(&midi_input, &sender);

        loop {//TODO stop active loop
            if connections.len() != midi_input.port_count() {
                connections = init_connections(&midi_input, &sender);
            }
        }
    });
    receiver
}

fn init_connections(
    midi_input: &MidiInput,
    sender: &Sender<MidiInputPressed>,
) -> Vec<MidiInputConnection<Sender<MidiInputPressed>>> {
    let mut return_vec: Vec<MidiInputConnection<Sender<MidiInputPressed>>> = vec![];

    for port in midi_input.ports() {
        let port_name = midi_input
            .port_name(&port)
            .expect("Error getting port name");
        let name: &str = port_name.as_str();

        match MidiInput::new(&format!("conection {port_name}"))
            .expect("error new midi input")
            .connect(&port, name, callback, sender.clone())
        {
            Ok(result) => return_vec.push(result),
            Err(e) => eprintln!("Error connecting to port {}: {:?}", name, e),
        }
    }

    return_vec
}
