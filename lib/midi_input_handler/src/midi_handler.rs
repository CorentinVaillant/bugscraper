
use midi_control::*;
use midir::*;

pub static mut LAST_INPUT : MidiInputPressed = MidiInputPressed::None;

#[allow(dead_code)]
pub const FRENCH_NOTE_TABLE : [&str;12] = ["do" ,"do#","re","re#","mi","fa","fa#","sol","sol#","la","la#","si"];
pub const ENGLISH_NOTE_TABLE : [&str;12]= ["C" , "C#", "D", "D#", "E", "F", "F#", "F" , "F#" , "A", "A#", "B" ];

#[allow(dead_code)]
pub struct Note {
    oct: u8,
    note: u8,
    velocity: u8,

    channel: Channel,
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

    fn to_string(&self) -> String{
        format!("{}-{}",ENGLISH_NOTE_TABLE[usize::from(self.note)],self.oct)
    }
    
}

#[allow(dead_code)]
pub struct MidiValue{
    value : i16,
    key :u8,
    channel : Channel
}
impl MidiValue {
    pub fn to_string(&self) ->String{
        format!("{}-{}-{:?}",self.value,self.key,self.channel)
    }
}

pub enum MidiInputPressed {
    Note(Note),
    JoystickX(MidiValue),
    JoystickY(MidiValue),
    Knob(MidiValue),
    None
}

impl MidiInputPressed {
    pub fn get_input_name(&self)->String{
        match self {
            Self::None=>"None".to_string(),
            Self::Note(note) => note.to_string(),
            Self::JoystickX(val) => val.to_string(),
            Self::JoystickY(val) => val.to_string(),
            Self::Knob(val) => val.to_string()
        
        }
    }
}





fn callback(_timestamp: u64, data: &[u8], _:&mut ()) {
    let message = MidiMessage::from(data);
    print!("\nreceived midi data {:?} -> ", data);
    match message {
        MidiMessage::NoteOn(channel, key) => {
            let note: Note = Note::from(key, channel);
            #[cfg(debug_assertions)] println!("{} on channel : {channel:?} ", note.to_string());
            unsafe { LAST_INPUT = MidiInputPressed::Note(note); }
        }
        MidiMessage::NoteOff(channel, key) => {
            let note: Note = Note::from(key, channel);
            #[cfg(debug_assertions)] println!("{} on channel : {channel:?} ", note.to_string());
            unsafe { LAST_INPUT = MidiInputPressed::Note(note)};
        }

        MidiMessage::PitchBend(channel,x ,y ) =>{
            #[cfg(debug_assertions)] println!("pitch bend : ({x},{y}) on channel : {channel:?}");
            let axis =MidiValue{ value:-1*i16::from(y)*2,key:0, channel};
            unsafe{ LAST_INPUT = MidiInputPressed::JoystickX(axis)};

        }

        MidiMessage::PolyKeyPressure(channel,key ) =>{
            #[cfg(debug_assertions)] println!("polykey pressure : ({:?}) on channel : {channel:?}",key.key);
            let axis =MidiValue{ value:i16::from(key.value),key:key.key , channel};
            unsafe{ LAST_INPUT = MidiInputPressed::JoystickY(axis)};
        }

        MidiMessage::ControlChange(channel,controle ) => {
            #[cfg(debug_assertions)] println!("control change : ({:?}) -> ({:?}) on channel : {channel:?}",controle.control,controle.value);
            let knob =MidiValue{ value:i16::from(controle.value),key:controle.control, channel};
            unsafe{ LAST_INPUT = MidiInputPressed::Knob(knob)};
        }
        

        _ => println!("unknow message received !"),

    }
}

pub fn init() {
    //initialisation
    let midi_input: MidiInput = match MidiInput::new("input") {
        Ok(result) => result,
        Err(e) => panic!("{}", e),
    };

    // callback_func.call::<_,()>(());

    //conection
    let ports_nb = midi_input.port_count();
    println!("{} ports avalaibles", ports_nb);
    let _connection_number = 0;

    let mut connections: Vec<MidiInputConnection<()>> = innit_connections(&midi_input);

    #[allow(while_true)]
    while true {


        if connections.len() != midi_input.port_count() {
            connections = innit_connections(&midi_input);
        }
    }

    println!("[rust] exit !!");
}

fn innit_connections<'a>(midi_input: & MidiInput) -> Vec<MidiInputConnection<()>> {
    let mut return_vec: Vec<MidiInputConnection<()>> = vec![];

    for port in midi_input.ports() {

        let port_name = midi_input
            .port_name(&port)
            .expect("Error getting port name");
        let name: &str = port_name.as_str();

        match MidiInput::new(&format!("conection {port_name}"))
            .expect("error new midi input")
            .connect(&port, name, callback,  ())
        {
            Ok(result) => return_vec.push(result),
            Err(e) => eprintln!("Error connecting to port {}: {:?}", name, e),
        }
    }

    return_vec
}
